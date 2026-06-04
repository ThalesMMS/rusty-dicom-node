use anyhow::{anyhow, Result};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum DimseServiceKind {
    Verification,
    Storage,
    Query,
    Retrieve,
}

pub trait ServiceProvider {
    fn kind(&self) -> DimseServiceKind;
    fn name(&self) -> &'static str;
    fn abstract_syntaxes(&self) -> &'static [&'static str];
    fn command_fields(&self) -> &'static [u16];

    fn supports_abstract_syntax(&self, abstract_syntax: &str) -> bool {
        self.abstract_syntaxes()
            .iter()
            .any(|supported| *supported == abstract_syntax)
    }

    fn supports_command(&self, command_field: u16, abstract_syntax: &str) -> bool {
        self.command_fields()
            .iter()
            .any(|supported| *supported == command_field)
            && self.supports_abstract_syntax(abstract_syntax)
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ProviderRegistration {
    pub kind: DimseServiceKind,
    pub name: &'static str,
    abstract_syntaxes: Vec<&'static str>,
    command_fields: Vec<u16>,
}

impl ProviderRegistration {
    fn from_provider(provider: &impl ServiceProvider) -> Self {
        Self {
            kind: provider.kind(),
            name: provider.name(),
            abstract_syntaxes: provider.abstract_syntaxes().to_vec(),
            command_fields: provider.command_fields().to_vec(),
        }
    }

    pub fn supports_abstract_syntax(&self, abstract_syntax: &str) -> bool {
        self.abstract_syntaxes
            .iter()
            .any(|supported| *supported == abstract_syntax)
    }

    pub fn supports_command(&self, command_field: u16, abstract_syntax: &str) -> bool {
        self.command_fields
            .iter()
            .any(|supported| *supported == command_field)
            && self.supports_abstract_syntax(abstract_syntax)
    }
}

#[derive(Debug, Clone, Default)]
pub struct ServiceClassRegistry {
    providers: Vec<ProviderRegistration>,
}

impl ServiceClassRegistry {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn with_provider(mut self, provider: &impl ServiceProvider) -> Self {
        self.register(provider);
        self
    }

    pub fn register(&mut self, provider: &impl ServiceProvider) {
        let registration = ProviderRegistration::from_provider(provider);
        self.providers
            .retain(|existing| existing.kind != registration.kind);
        self.providers.push(registration);
    }

    pub fn providers(&self) -> &[ProviderRegistration] {
        &self.providers
    }

    pub fn supported_abstract_syntaxes(&self) -> Vec<&'static str> {
        let mut syntaxes = Vec::new();
        for provider in &self.providers {
            for syntax in &provider.abstract_syntaxes {
                if !syntaxes.iter().any(|existing| existing == syntax) {
                    syntaxes.push(*syntax);
                }
            }
        }
        syntaxes
    }

    pub fn supports_abstract_syntax(&self, abstract_syntax: &str) -> bool {
        self.providers
            .iter()
            .any(|provider| provider.supports_abstract_syntax(abstract_syntax))
    }

    pub fn provider_for_command(
        &self,
        command_field: u16,
        abstract_syntax: &str,
    ) -> Result<&ProviderRegistration> {
        self.providers
            .iter()
            .find(|provider| provider.supports_command(command_field, abstract_syntax))
            .ok_or_else(|| {
                anyhow!(
                    "no DIMSE provider registered for command 0x{command_field:04X} and abstract syntax {abstract_syntax}"
                )
            })
    }
}

#[cfg(test)]
mod tests {
    use dicom_dictionary_std::uids::{CT_IMAGE_STORAGE, VERIFICATION};

    use crate::net::service::{StorageProvider, VerificationProvider};

    use super::{DimseServiceKind, ServiceClassRegistry};

    #[test]
    fn verification_only_registry_refuses_storage_abstract_syntaxes() {
        let registry = ServiceClassRegistry::new().with_provider(&VerificationProvider::new());

        assert!(registry.supports_abstract_syntax(VERIFICATION));
        assert!(!registry.supports_abstract_syntax(CT_IMAGE_STORAGE));
    }

    #[test]
    fn storage_registry_accepts_expected_storage_sop_class() {
        let registry = ServiceClassRegistry::new().with_provider(&StorageProvider::descriptor());

        assert!(registry.supports_abstract_syntax(CT_IMAGE_STORAGE));
        assert_eq!(
            registry
                .provider_for_command(0x0001, CT_IMAGE_STORAGE)
                .expect("storage provider")
                .kind,
            DimseServiceKind::Storage
        );
    }

    #[test]
    fn provider_lookup_reports_command_without_compatible_provider() {
        let registry = ServiceClassRegistry::new().with_provider(&VerificationProvider::new());

        let err = registry
            .provider_for_command(0x0001, VERIFICATION)
            .expect_err("C-STORE should not dispatch to Verification");

        assert!(err.to_string().contains("no DIMSE provider registered"));
    }
}
