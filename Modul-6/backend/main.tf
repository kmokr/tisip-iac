terraform {
  required_version = ">= 1.16.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.4"
    }
  }
}

provider "azurerm" {
  features {}

  # azurerm 5.x registrerer ingen resource providers automatisk.
  resource_providers_to_register = ["Microsoft.Storage", "Microsoft.KeyVault"]
}

# Den som er logget inn med az login akkurat nå
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "backend" {
  name     = "rg-demo-backend-krmk404"
  location = "norwayeast"
  tags     = local.tags
}

resource "azurerm_storage_account" "state" {
  name                     = "stdemokrmk404"
  resource_group_name      = azurerm_resource_group.backend.name
  location                 = azurerm_resource_group.backend.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = local.tags

  allow_nested_items_to_be_public = false

  # Sikkerhetsnettet fra seksjon 2: historiske kopier + gjenoppretting i 7 dager
  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 7
    }
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.state.id
  container_access_type = "private"
}

resource "azurerm_key_vault" "demo" {
  name                        = "kv-demo-krmk404"
  location                    = azurerm_resource_group.backend.location
  resource_group_name         = azurerm_resource_group.backend.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  rbac_authorization_enabled  = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  tags                        = local.tags
}

# --- Tilgang: deg ---

resource "azurerm_role_assignment" "meg_contributor" {
  scope                = azurerm_resource_group.backend.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "meg_blob" {
  scope                = azurerm_storage_account.state.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "meg_kv" {
  scope                = azurerm_key_vault.demo.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# --- Tilgang: workflowen (service principal-en bak App Registration-en) ---

resource "azurerm_role_assignment" "pipeline_contributor" {
  scope                = azurerm_resource_group.backend.id
  role_definition_name = "Contributor"
  principal_id         = var.pipeline_principal_id
}

resource "azurerm_role_assignment" "pipeline_blob" {
  scope                = azurerm_storage_account.state.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.pipeline_principal_id
}

resource "azurerm_role_assignment" "pipeline_kv" {
  scope                = azurerm_key_vault.demo.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.pipeline_principal_id
}