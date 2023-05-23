locals {
  archetype_config_overrides = {
    myorg-landing-zones = {
      enforcement_mode = {
        Deny-IP-Forwarding       = false
        Deny-RDP-From-Internet   = false
        Deny-Storage-http        = false
        Deny-Subnet-Without-Nsg  = false
        Deploy-AKS-Policy        = false
        Deploy-SQL-DB-Auditing   = false
        Deploy-SQL-Threat        = false
        Deploy-VM-Backup         = false
        Deny-Priv-Escalation-AKS = false
        Deny-Priv-Containers-AKS = false
        Enable-DDoS-VNET         = false
        Enforce-AKS-HTTPS        = false
        Enforce-TLS-SSL          = false
      }
    }
  }
}