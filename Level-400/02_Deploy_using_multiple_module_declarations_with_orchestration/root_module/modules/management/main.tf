# Configure Terraform to set the required AzureRM provider
# version and features{} block

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.54.0"
    }
  }
}

# Define the provider configuration

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id_management
}

# Get the current client configuration from the AzureRM provider

data "azurerm_client_config" "current" {}

# Declare the Azure landing zones Terraform module
# and provide the connectivity configuration.

module "alz" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "4.0.1" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  default_location = "eastus"
  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  # Base module configuration settings
  root_parent_id = data.azurerm_client_config.current.tenant_id
  root_id        = var.root_id

  # Disable creation of the core management group hierarchy
  # as this is being created by the core module instance
  deploy_core_landing_zones = false

  # Configuration settings for management resources
  deploy_management_resources    = true
  configure_management_resources = local.configure_management_resources
  subscription_id_management     = var.subscription_id_management

}
