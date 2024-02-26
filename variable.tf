variable "resource_group" {
    type = string
    description = "Resource group name"
    default = "TestAzVM"
}
variable "create_resource_group" {
  description = "Flag to indicate whether to create the resource group or not"
  type        = bool
  default     = true  # Set the default value to true if you want to create the resource group by default
}

variable "location" {
    type = string
    description = "RG and resources location"
    default = "South India"
}

variable "win_username" {
  description = "Windows node username"
  type        = string
  sensitive   = false
}

variable "win_userpass" {
  description = "Windows node password"
  type        = string
  sensitive   = true
}

variable "Domain_DNSName" {
  description = "FQDN for the Active Directory forest root domain"
  type        = string
  sensitive   = false
}

variable "netbios_name" {
  description = "NETBIOS name for the AD domain"
  type        = string
  sensitive   = false
}

variable "SafeModeAdministratorPassword" {
  description = "Password for AD Safe Mode recovery"
  type        = string
  sensitive   = true
}