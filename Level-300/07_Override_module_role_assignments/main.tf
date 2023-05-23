# Get the current client configuration from the AzureRM provider.
# This is used to populate the root_parent_id variable with the
# current Tenant ID used as the ID for the "Tenant Root Group"
# Management Group.

data "azurerm_client_config" "core" {}

# Declare the Azure landing zones Terraform module
# and provide a base configuration.

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "4.0.1" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  default_location = "eastus"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name
  library_path   = "${path.root}/lib"

  custom_policy_roles = {
    "/providers/Microsoft.Authorization/policySetDefinitions/a169a624-5599-4385-a696-c8d643089fab" = [
      "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c",
      "/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7"
    ],
    "/providers/Microsoft.Authorization/policyDefinitions/f4c68484-132f-41f9-9b6d-3e4b1cb55036" = [
      "/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
    ]
  }

  custom_landing_zones = {
    "${var.root_id}-customer-corp" = {
      display_name               = "Custom"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id = "customer_online"
        parameters = {
          Deploy-HITRUST-HIPAA = {
            CertificateThumbprints                                        = jsonencode("")
            DeployDiagnosticSettingsforNetworkSecurityGroupsrgName        = jsonencode("true")
            DeployDiagnosticSettingsforNetworkSecurityGroupsstoragePrefix = jsonencode(var.root_id)
            installedApplicationsOnWindowsVM                              = jsonencode("")
          },
          Deploy-SQL-Auditing = {
            retentionDays                = jsonencode("10")
            storageAccountsResourceGroup = jsonencode("")
          }
        }
        access_control = {}
      }
    }
  }
}