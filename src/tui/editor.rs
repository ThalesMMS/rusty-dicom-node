#[derive(Clone, Debug, Default, PartialEq, Eq)]
pub(super) struct CommandEditor {
    buffer: String,
    cursor: usize,
}

impl CommandEditor {
    pub(super) fn insert_char(&mut self, ch: char) {
        self.buffer.insert(self.cursor, ch);
        self.cursor += ch.len_utf8();
    }

    pub(super) fn insert_str(&mut self, text: &str) {
        self.buffer.insert_str(self.cursor, text);
        self.cursor += text.len();
    }

    pub(super) fn delete_char(&mut self) {
        if let Some((next, _)) = self.char_at(self.cursor) {
            self.buffer.drain(self.cursor..next);
        }
    }

    pub(super) fn backspace(&mut self) {
        if let Some((previous, _)) = self.previous_char(self.cursor) {
            self.buffer.drain(previous..self.cursor);
            self.cursor = previous;
        }
    }

    pub(super) fn delete_word_left(&mut self) {
        let target = self.word_left_position();
        if target < self.cursor {
            self.buffer.drain(target..self.cursor);
            self.cursor = target;
        }
    }

    pub(super) fn delete_word_right(&mut self) {
        let target = self.word_right_position();
        if self.cursor < target {
            self.buffer.drain(self.cursor..target);
        }
    }

    pub(super) fn clear(&mut self) {
        self.buffer.clear();
        self.cursor = 0;
    }

    pub(super) fn set_content(&mut self, content: &str) {
        self.buffer.clear();
        self.buffer.push_str(content);
        self.cursor = self.buffer.len();
    }

    pub(super) fn move_left(&mut self) {
        if let Some((previous, _)) = self.previous_char(self.cursor) {
            self.cursor = previous;
        }
    }

    pub(super) fn move_right(&mut self) {
        if let Some((next, _)) = self.char_at(self.cursor) {
            self.cursor = next;
        }
    }

    pub(super) fn move_home(&mut self) {
        self.cursor = 0;
    }

    pub(super) fn move_end(&mut self) {
        self.cursor = self.buffer.len();
    }

    pub(super) fn move_word_left(&mut self) {
        self.cursor = self.word_left_position();
    }

    pub(super) fn move_word_right(&mut self) {
        self.cursor = self.word_right_position();
    }

    pub(super) fn content(&self) -> &str {
        &self.buffer
    }

    pub(super) fn cursor_position(&self) -> usize {
        self.cursor
    }

    pub(super) fn take_content(&mut self) -> String {
        let content = std::mem::take(&mut self.buffer);
        self.cursor = 0;
        content
    }

    fn previous_char(&self, index: usize) -> Option<(usize, char)> {
        self.buffer[..index].char_indices().next_back()
    }

    fn char_at(&self, index: usize) -> Option<(usize, char)> {
        self.buffer[index..]
            .chars()
            .next()
            .map(|ch| (index + ch.len_utf8(), ch))
    }

    fn word_left_position(&self) -> usize {
        let mut cursor = self.cursor;

        while let Some((previous, ch)) = self.previous_char(cursor) {
            if !ch.is_whitespace() {
                break;
            }
            cursor = previous;
        }

        while let Some((previous, ch)) = self.previous_char(cursor) {
            if ch.is_whitespace() {
                break;
            }
            cursor = previous;
        }

        cursor
    }

    fn word_right_position(&self) -> usize {
        let mut cursor = self.cursor;

        while let Some((next, ch)) = self.char_at(cursor) {
            if ch.is_whitespace() {
                break;
            }
            cursor = next;
        }

        while let Some((next, ch)) = self.char_at(cursor) {
            if !ch.is_whitespace() {
                break;
            }
            cursor = next;
        }

        cursor
    }
}

pub(super) fn floor_char_boundary(value: &str, index: usize) -> usize {
    let mut index = index.min(value.len());
    while !value.is_char_boundary(index) {
        index -= 1;
    }
    index
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn command_editor_supports_utf8_inline_editing() {
        let mut editor = CommandEditor::default();

        editor.insert_str("aé日");
        assert_eq!(editor.content(), "aé日");
        assert_eq!(editor.cursor_position(), "aé日".len());

        editor.move_left();
        assert_eq!(editor.cursor_position(), "aé".len());

        editor.backspace();
        assert_eq!(editor.content(), "a日");
        assert_eq!(editor.cursor_position(), "a".len());

        editor.delete_char();
        assert_eq!(editor.content(), "a");
        assert_eq!(editor.cursor_position(), "a".len());

        editor.move_home();
        editor.insert_char('ß');
        assert_eq!(editor.content(), "ßa");
        assert_eq!(editor.cursor_position(), "ß".len());

        editor.set_content("reset");
        assert_eq!(editor.content(), "reset");
        assert_eq!(editor.cursor_position(), "reset".len());

        assert_eq!(editor.take_content(), "reset");
        assert_eq!(editor.content(), "");
        assert_eq!(editor.cursor_position(), 0);
    }
    #[test]
    fn command_editor_moves_and_deletes_by_words() {
        let mut editor = CommandEditor::default();
        editor.insert_str("alpha beta  gamma");

        editor.move_home();
        editor.move_word_right();
        assert_eq!(editor.cursor_position(), "alpha ".len());

        editor.move_word_right();
        assert_eq!(editor.cursor_position(), "alpha beta  ".len());

        editor.move_word_left();
        assert_eq!(editor.cursor_position(), "alpha ".len());

        editor.delete_word_right();
        assert_eq!(editor.content(), "alpha gamma");
        assert_eq!(editor.cursor_position(), "alpha ".len());

        editor.delete_word_left();
        assert_eq!(editor.content(), "gamma");
        assert_eq!(editor.cursor_position(), 0);
    }
}
