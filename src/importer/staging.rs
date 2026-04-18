use std::{
    fs,
    io::{self, Read, Write},
    path::{Path, PathBuf},
};

use anyhow::{anyhow, Context, Result};
use sha2::{Digest, Sha256};
use uuid::Uuid;

const STAGED_FILE_NAME_FRAGMENT_LIMIT: usize = 96;

pub(super) fn sha256_hex(bytes: &[u8]) -> String {
    let mut hasher = Sha256::new();
    hasher.update(bytes);
    format!("{:x}", hasher.finalize())
}

pub(super) fn stage_reader_with_sha256<R: Read>(
    mut reader: R,
    staging_dir: &Path,
    file_name_hint: &Path,
    max_file_import_bytes: Option<u64>,
) -> Result<(PathBuf, String, u64)> {
    let staged_path = staged_copy_path(staging_dir, file_name_hint);
    let mut staged_file = fs::File::create(&staged_path)
        .with_context(|| format!("creating {}", staged_path.display()))?;
    let cleanup = FileCleanupGuard::new(&staged_path);
    let mut copied_bytes = 0_u64;
    let mut hasher = Sha256::new();
    let mut buffer = [0_u8; 64 * 1024];
    let result = (|| -> Result<(String, u64)> {
        loop {
            let bytes_read = reader
                .read(&mut buffer)
                .with_context(|| format!("reading source for {}", staged_path.display()))?;
            if bytes_read == 0 {
                break;
            }
            let projected_bytes = copied_bytes.saturating_add(bytes_read as u64);
            if let Some(max_file_import_bytes) = max_file_import_bytes {
                if projected_bytes > max_file_import_bytes {
                    return Err(anyhow!(
                        "file too large: {projected_bytes} > {max_file_import_bytes}"
                    ));
                }
            }
            hasher.update(&buffer[..bytes_read]);
            staged_file
                .write_all(&buffer[..bytes_read])
                .with_context(|| format!("writing {}", staged_path.display()))?;
            copied_bytes = projected_bytes;
        }

        staged_file
            .flush()
            .with_context(|| format!("flushing {}", staged_path.display()))?;

        Ok((format!("{:x}", hasher.finalize()), copied_bytes))
    })();

    match result {
        Ok((sha256, file_size_bytes)) => {
            cleanup.disarm();
            Ok((staged_path, sha256, file_size_bytes))
        }
        Err(err) => Err(err),
    }
}

pub(super) fn staged_copy_path(staging_dir: &Path, file_name_hint: &Path) -> PathBuf {
    let file_name = sanitized_file_name_fragment(file_name_hint);
    staging_dir.join(format!(".{file_name}.{}.tmp", Uuid::new_v4()))
}

fn sanitized_file_name_fragment(file_name_hint: &Path) -> String {
    let raw_name = file_name_hint
        .file_name()
        .and_then(|name| name.to_str())
        .unwrap_or("import");
    let mut sanitized = String::new();

    for ch in raw_name.chars() {
        if sanitized.len() >= STAGED_FILE_NAME_FRAGMENT_LIMIT {
            break;
        }
        sanitized.push(if ch.is_ascii_alphanumeric() { ch } else { '_' });
    }

    let sanitized = sanitized.trim_matches('_');
    if sanitized.is_empty() {
        "import".to_string()
    } else {
        sanitized.to_string()
    }
}

pub(super) fn replace_file(source: &Path, destination: &Path) -> Result<()> {
    match fs::rename(source, destination) {
        Ok(()) => Ok(()),
        Err(error) if error.kind() == io::ErrorKind::AlreadyExists => {
            remove_file_if_exists(destination)
                .with_context(|| format!("removing {}", destination.display()))?;
            fs::rename(source, destination).with_context(|| {
                format!(
                    "retrying move {} to {}",
                    source.display(),
                    destination.display()
                )
            })
        }
        Err(error) if is_cross_device_rename_error(&error) => {
            copy_across_devices(source, destination)
        }
        Err(error) => Err(error)
            .with_context(|| format!("moving {} to {}", source.display(), destination.display())),
    }
}

fn copy_across_devices(source: &Path, destination: &Path) -> Result<()> {
    let temporary_destination = destination.with_file_name(format!(
        ".{}.{}.tmp",
        sanitized_file_name_fragment(destination),
        Uuid::new_v4()
    ));

    let result = (|| -> Result<()> {
        fs::copy(source, &temporary_destination).with_context(|| {
            format!(
                "copying {} to temporary {}",
                source.display(),
                temporary_destination.display()
            )
        })?;

        match fs::rename(&temporary_destination, destination) {
            Ok(()) => {}
            Err(error) if error.kind() == io::ErrorKind::AlreadyExists => {
                remove_file_if_exists(destination)
                    .with_context(|| format!("removing {}", destination.display()))?;
                fs::rename(&temporary_destination, destination).with_context(|| {
                    format!(
                        "retrying move {} to {}",
                        temporary_destination.display(),
                        destination.display()
                    )
                })?;
            }
            Err(error) => {
                return Err(error).with_context(|| {
                    format!(
                        "moving {} to {}",
                        temporary_destination.display(),
                        destination.display()
                    )
                });
            }
        }

        remove_file_if_exists(source).with_context(|| format!("removing {}", source.display()))?;
        Ok(())
    })();

    if result.is_err() {
        let _ = remove_file_if_exists(&temporary_destination);
    }

    result
}

fn is_cross_device_rename_error(error: &io::Error) -> bool {
    #[cfg(unix)]
    {
        return error.raw_os_error() == Some(18);
    }

    #[cfg(windows)]
    {
        return error.raw_os_error() == Some(17);
    }

    #[cfg(not(any(unix, windows)))]
    {
        false
    }
}

pub(super) fn remove_file_if_exists(path: &Path) -> std::io::Result<()> {
    match fs::remove_file(path) {
        Ok(()) => Ok(()),
        Err(err) if err.kind() == std::io::ErrorKind::NotFound => Ok(()),
        Err(err) => Err(err),
    }
}

#[derive(Debug)]
pub(super) struct FileCleanupGuard {
    path: PathBuf,
    armed: std::cell::Cell<bool>,
}

impl FileCleanupGuard {
    pub(super) fn new(path: impl AsRef<Path>) -> Self {
        Self {
            path: path.as_ref().to_path_buf(),
            armed: std::cell::Cell::new(true),
        }
    }

    pub(super) fn path(&self) -> &Path {
        &self.path
    }

    pub(super) fn disarm(&self) {
        self.armed.set(false);
    }
}

impl Drop for FileCleanupGuard {
    fn drop(&mut self) {
        if self.armed.get() {
            let _ = remove_file_if_exists(&self.path);
        }
    }
}

#[cfg(test)]
mod tests {
    use std::{
        fs, io,
        io::Read,
        path::{Path, PathBuf},
    };

    use tempfile::tempdir;

    use super::stage_reader_with_sha256;

    struct FailAfterFirstChunkReader {
        chunk: Vec<u8>,
        delivered_chunk: bool,
    }

    impl FailAfterFirstChunkReader {
        fn new(chunk: impl Into<Vec<u8>>) -> Self {
            Self {
                chunk: chunk.into(),
                delivered_chunk: false,
            }
        }
    }

    impl Read for FailAfterFirstChunkReader {
        fn read(&mut self, buf: &mut [u8]) -> io::Result<usize> {
            if self.delivered_chunk {
                return Err(io::Error::other("simulated reader failure"));
            }

            let bytes_to_copy = self.chunk.len().min(buf.len());
            buf[..bytes_to_copy].copy_from_slice(&self.chunk[..bytes_to_copy]);
            self.delivered_chunk = true;
            Ok(bytes_to_copy)
        }
    }

    fn staged_files(staging_dir: &Path) -> Vec<PathBuf> {
        fs::read_dir(staging_dir)
            .expect("read staging dir")
            .filter_map(|entry| entry.ok())
            .map(|entry| entry.path())
            .filter(|path| path.is_file())
            .collect()
    }

    #[test]
    fn staged_copy_path_sanitizes_file_name_fragment() {
        let root = tempdir().expect("create temp dir");

        let staged_path = super::staged_copy_path(root.path(), Path::new("unsafe name:with.dcm"));
        let file_name = staged_path
            .file_name()
            .expect("staged file name")
            .to_string_lossy();

        assert!(file_name.starts_with(".unsafe_name_with_dcm."));
        assert!(file_name.ends_with(".tmp"));
        assert!(!file_name.contains('/'));
        assert!(!file_name.contains(':'));
        assert!(!file_name.contains(' '));
    }

    #[test]
    fn staged_copy_path_clamps_file_name_fragment() {
        let root = tempdir().expect("create temp dir");
        let long_name = format!("{}.dcm", "a".repeat(300));

        let staged_path = super::staged_copy_path(root.path(), Path::new(&long_name));
        let file_name = staged_path
            .file_name()
            .expect("staged file name")
            .to_string_lossy();
        let fragment = file_name
            .trim_start_matches('.')
            .split('.')
            .next()
            .expect("staged file name fragment");

        assert_eq!(fragment.len(), super::STAGED_FILE_NAME_FRAGMENT_LIMIT);
    }

    #[test]
    fn replace_file_preserves_destination_when_initial_rename_fails() {
        let root = tempdir().expect("create temp dir");
        let missing_source = root.path().join("missing.dcm");
        let destination = root.path().join("destination.dcm");
        fs::write(&destination, b"existing").expect("write destination");

        let error = super::replace_file(&missing_source, &destination).unwrap_err();

        assert!(format!("{error:#}").contains("moving"));
        assert_eq!(
            fs::read(&destination).expect("read destination"),
            b"existing"
        );
    }

    #[test]
    fn replace_file_moves_source_over_destination() {
        let root = tempdir().expect("create temp dir");
        let source = root.path().join("source.dcm");
        let destination = root.path().join("destination.dcm");
        fs::write(&source, b"new").expect("write source");
        fs::write(&destination, b"existing").expect("write destination");

        super::replace_file(&source, &destination).expect("replace destination");

        assert!(!source.exists());
        assert_eq!(fs::read(&destination).expect("read destination"), b"new");
    }

    #[test]
    fn stage_reader_with_sha256_removes_partial_file_on_error() {
        let root = tempdir().expect("create temp dir");
        let staging_dir = root.path().join("staging");
        fs::create_dir_all(&staging_dir).expect("create staging dir");

        let error = stage_reader_with_sha256(
            FailAfterFirstChunkReader::new(b"abcd"),
            &staging_dir,
            Path::new("input.dcm"),
            None,
        )
        .unwrap_err();

        assert!(format!("{error:#}").contains("simulated reader failure"));
        let remaining_tmp_files = staged_files(&staging_dir);
        assert!(
            remaining_tmp_files.is_empty(),
            "expected no staged files after reader failure, found {remaining_tmp_files:?}"
        );
    }

    #[test]
    fn stage_reader_with_sha256_enforces_copy_size_limit() {
        let root = tempdir().expect("create temp dir");
        let staging_dir = root.path().join("staging");
        fs::create_dir_all(&staging_dir).expect("create staging dir");

        let error = stage_reader_with_sha256(
            io::Cursor::new(b"abcd"),
            &staging_dir,
            Path::new("input.dcm"),
            Some(3),
        )
        .unwrap_err();

        assert!(format!("{error:#}").contains("file too large: 4 > 3"));
        let remaining_tmp_files = staged_files(&staging_dir);
        assert!(
            remaining_tmp_files.is_empty(),
            "expected no staged files after size-limit failure, found {remaining_tmp_files:?}"
        );
    }
}
