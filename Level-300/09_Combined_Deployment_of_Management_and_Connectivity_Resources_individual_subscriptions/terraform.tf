
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.54.0"
      configuration_aliases = [
        azurerm.management,
      ]
    }
  }
}
# Declare a standard provider block using your preferred configuration.
# This will target the "default" Subscription and be used for the deployment of all "Core resources".
provider "azurerm" {
  features {}
}

# Declare an aliased provider block using your preferred configuration.
# This will be used for the deployment of all "Connectivity resources" to the specified `subscription_id`.
# provider "azurerm" {
#   alias           = "connectivity"
#   subscription_id = "c771a68d-4f8b-4e76-be68-f8dbcd5872f1"
#   features {}
# }

# Declare a standard provider block using your preferred configuration.
# This will be used for the deployment of all "Management resources" to the specified `subscription_id`.
provider "azurerm" {
  alias           = "management"
  subscription_id = "bee810ca-7121-40a1-8465-71ec3b0d7449"
  features {}
}


