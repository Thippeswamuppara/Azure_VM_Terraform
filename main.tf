# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "=3.57.0"
#     }
#   }
# }

# provider "azurerm" {
#   features {
#   }
# }

# #Creates the Azure Resource Group
# resource "azurerm_resource_group" "rg" {
#   name     = var.resource_group
#   location = var.location
#    count = var.create_resource_group ? 1 : 0
# }

# #Creates the Azure Virtual Network
# resource "azurerm_virtual_network" "vnet" {
#   name                = "testvm"
#   # location            = azurerm_resource_group.rg.location
#   # resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg[0].location  # Use index 0 assuming there's only one resource group
#   resource_group_name = azurerm_resource_group.rg[0].name 
#   address_space       = ["192.168.10.0/24"]
# }

# #Creates the subnet
# resource "azurerm_subnet" "testvmsubnet" {
#   name                 = "testvmsubnet"
#   resource_group_name  = azurerm_resource_group.rg[0].name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["192.168.10.0/24"]
# }

# #Creates a vNIC for the VM

# resource "azurerm_public_ip" "public_ip" {
#   name                = "acceptanceTestPublicIp1"
#   # resource_group_name = azurerm_resource_group.rg.name
#   # location            = azurerm_resource_group.rg.location
#     location            = azurerm_resource_group.rg[0].location  # Use index 0 assuming there's only one resource group
#   resource_group_name = azurerm_resource_group.rg[0].name
#   allocation_method   = "Dynamic"

#   tags = {
#     environment = "Production"
#   }
# }
# resource "azurerm_network_interface" "dc01_nic" {
#   name                = "dc01_nic"
#   location            = azurerm_resource_group.rg[0].location
#   resource_group_name =azurerm_resource_group.rg[0].name

#   ip_configuration {
#     name                          = "dc01_nic"
#     subnet_id                     = azurerm_subnet.testvmsubnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.public_ip.id  # Add this line
#   }
# }

# #Creates the Azure VM
# resource "azurerm_windows_virtual_machine" "dc01" {
#   name                = "DC01"
#   resource_group_name = azurerm_resource_group.rg[0].name
#   location            =azurerm_resource_group.rg[0].location
#   size                = "Standard_B1s"
#   admin_username      = var.win_username
#   admin_password      = var.win_userpass
#   network_interface_ids = [
#     azurerm_network_interface.dc01_nic.id
#   ]

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2022-Datacenter"
#     version   = "latest"
#   }
# }

# #Install Active Directory on the DC01 VM
# resource "azurerm_virtual_machine_extension" "install_ad" {
#   name                 = "install_ad"
# #  resource_group_name  = azurerm_resource_group.main.name
#   virtual_machine_id   = azurerm_windows_virtual_machine.dc01.id
#   publisher            = "Microsoft.Compute"
#   type                 = "CustomScriptExtension"
#   type_handler_version = "1.9"

#   protected_settings = <<SETTINGS
#   {    
#     "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.ADDS.rendered)}')) | Out-File -filepath ADDS.ps1\" && powershell -ExecutionPolicy Unrestricted -File ADDS.ps1 -Domain_DNSName ${data.template_file.ADDS.vars.Domain_DNSName} -Domain_NETBIOSName ${data.template_file.ADDS.vars.Domain_NETBIOSName} -SafeModeAdministratorPassword ${data.template_file.ADDS.vars.SafeModeAdministratorPassword}"
#   }
#   SETTINGS
# }

# #Variable input for the ADDS.ps1 script
# data "template_file" "ADDS" {
#     template = "${file("ADDS.ps1")}"
#     vars = {
#         Domain_DNSName          = "${var.Domain_DNSName}"
#         Domain_NETBIOSName      = "${var.netbios_name}"
#         SafeModeAdministratorPassword = "${var.SafeModeAdministratorPassword}"
#   }
# }
# resource "null_resource" "create_powerbi_workspace" {
#   provisioner "local-exec" {
#     command = <<-EOT
      
#       $client_id =  "ea035bbf-e2f2-40cf-9746-25624d56b288"
#       # $client_secret="lKA8Q~t10UJYi6vIjk-Ezc6dl63PpQ5XQYEyXchL"
#       $tenant_id=  "43d6e916-db90-4a6b-908e-de4a48120835"
#       $workspaceName = "Nitni"

#       # Authenticate with Azure Active Directory and obtain access token
#       $tokenUrl = "https://login.microsoftonline.com/$tenantId/oauth2/token"
#       $body = @{
#           "grant_type"    = "client_credentials"
#           "client_id"     = $clientId
#           # "client_secret" = $clientSecret
#           "resource"      = "https://analysis.windows.net/powerbi/api"
#       }
#       $response = Invoke-RestMethod -Uri $tokenUrl -Method Post -Body $body
#       $accessToken = $response.access_token

#       # Create a new Power BI workspace
#       $workspaceUrl = "https://api.powerbi.com/v1.0/myorg/groups"
#       $body = @{
#           "name" = $workspaceName
#       }
#       $headers = @{
#           "Authorization" = "Bearer $accessToken"
#           "Content-Type"  = "application/json"
#       }
#       Invoke-RestMethod -Uri $workspaceUrl -Method Post -Headers $headers -Body ($body | ConvertTo-Json)
#     EOT
#   }
# }

#To modify your Terraform script to execute even if resources already exist, you can adjust the `count` attribute of your resources based on the `create_resource_group` variable. Here's how you can modify your `main.tf` script:

#```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.57.0"
    }
  }
}

provider "azurerm" {
  features {}
}
provider "null"  {

}

# Creates the Azure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
  count    = var.create_resource_group ? 1 : 0
}


# Creates the Azure Virtual Network
# Creates the Azure Virtual Network
resource "azurerm_virtual_network" "vnet" {
  count               = var.create_resource_group ? 1 : 0
  name                = "testvm"
  location            = azurerm_resource_group.rg[0].location
  resource_group_name = azurerm_resource_group.rg[0].name
  address_space       =["10.0.0.0/16"]
}


# Creates the subnet
resource "azurerm_subnet" "testvmsubnet" {
  count                = var.create_resource_group ? 1 : 0
  name                 = "testvmsubnet"
  resource_group_name  = element(azurerm_resource_group.rg[*].name, 0)
  virtual_network_name = element(azurerm_virtual_network.vnet[*].name, 0)
  address_prefixes     = ["10.0.0.0/24"]
}

# Creates a public IP
resource "azurerm_public_ip" "public_ip" {
  count               = var.create_resource_group ? 1 : 0
  name                = "acceptanceTestPublicIp1"
  location            = element(azurerm_resource_group.rg[*].location, 0)
  resource_group_name = element(azurerm_resource_group.rg[*].name, 0)
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}

# Creates a network interface
resource "azurerm_network_interface" "dc01_nic" {
  count               = var.create_resource_group ? 1 : 0
  name                = "dc01_nic"
  location            = element(azurerm_resource_group.rg[*].location, 0)
  resource_group_name = element(azurerm_resource_group.rg[*].name, 0)

  ip_configuration {
    name                          = "dc01_nic"
    subnet_id                     = azurerm_subnet.testvmsubnet[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip[0].id
  }
}

# Creates the Azure VM
resource "azurerm_windows_virtual_machine" "dc01" {
  count               = var.create_resource_group ? 1 : 0
  name                = "DC01"
  resource_group_name = element(azurerm_resource_group.rg[*].name, 0)
  location            = element(azurerm_resource_group.rg[*].location, 0)
  size                = "Standard_B1s"
  admin_username      = var.win_username
  admin_password      = var.win_userpass
  network_interface_ids = [
    azurerm_network_interface.dc01_nic[0].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

# Install Active Directory on the DC01 VM
resource "azurerm_virtual_machine_extension" "install_ad" {
  count               = var.create_resource_group ? 1 : 0
  name                = "install_ad"
  virtual_machine_id  = azurerm_windows_virtual_machine.dc01[0].id
  publisher           = "Microsoft.Compute"
  type                = "CustomScriptExtension"
  type_handler_version = "1.9"

  protected_settings = jsonencode({
    commandToExecute = "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.ADDS.rendered)}')) | Out-File -filepath ADDS.ps1\" && powershell -ExecutionPolicy Unrestricted -File ADDS.ps1 -Domain_DNSName ${data.template_file.ADDS.vars.Domain_DNSName} -Domain_NETBIOSName ${data.template_file.ADDS.vars.Domain_NETBIOSName} -SafeModeAdministratorPassword ${data.template_file.ADDS.vars.SafeModeAdministratorPassword}"
  })
}

# Variable input for the ADDS.ps1 script
data "template_file" "ADDS" {
  template = file("ADDS.ps1")
  vars = {
    Domain_DNSName              = var.Domain_DNSName
    Domain_NETBIOSName          = var.netbios_name
    SafeModeAdministratorPassword = var.SafeModeAdministratorPassword
  }
}
# resource "null_resource" "power_bi_setup" {
#   # This resource is used to trigger the local-exec provisioner
#   triggers = {
#     always_run = timestamp()
#   }

#   provisioner "local-exec" {
#     command = "powershell.exe -File powerbi_setup.ps1"
#   }
# }
# Define a null_resource to trigger local-exec provisioner
resource "null_resource" "power_bi_setup" {
  # This resource is used to trigger the local-exec provisioner
  triggers = {
    always_run = timestamp()
  }

  # Execute the PowerShell script
  provisioner "local-exec" {
    command = "powershell.exe -ExecutionPolicy Bypass -File powerbi_setup.ps1"
  }
}




# resource "null_resource" "power_bi_setup" {
#   # This resource is used to trigger the local-exec provisioner
#   triggers = {
#     always_run = timestamp()
#   }

#   provisioner "local-exec" {
#     # Install or update the Power BI PowerShell Module
#     command = "powershell.exe -Command \"Install-Module -Name MicrosoftPowerBIMgmt -Force -AllowClobber -Scope CurrentUser -ErrorAction Stop\""
#   }

#   provisioner "local-exec" {
#     # Import the Power BI PowerShell Module
#     command = "powershell.exe -Command \"Import-Module MicrosoftPowerBIMgmt\""
#   }

#   provisioner "local-exec" {
#     # Connect to Power BI
#     command = "powershell.exe -Command \"Connect-PowerBIServiceAccount\""
#   }

#   provisioner "local-exec" {
#     # Create a new Power BI workspace
#     command = "powershell.exe -Command \"New-PowerBIWorkspace -Name 'Tippu'\""
#     interpreter = ["PowerShell", "-Command"]
#   }

#   # Specify the null provider
#   provider = null
# }



# resource "null_resource" "power_bi_setup" {
#   # This resource is used to trigger the local-exec provisioner
#   triggers = {
#     always_run = timestamp()
#   }

#   provisioner "local-exec" {
#     # Install or update the Power BI PowerShell Module
#     command = <<EOT
#         Install-Module -Name MicrosoftPowerBIMgmt -Force -AllowClobber -Scope CurrentUser -ErrorAction Stop
#     EOT
#   }

#   provisioner "local-exec" {
#     # Import the Power BI PowerShell Module
#     command = "Import-Module MicrosoftPowerBIMgmt"
#   }

#   provisioner "local-exec" {
#     # Connect to Power BI
#     command = "Connect-PowerBIServiceAccount"
#   }

#   provisioner "local-exec" {
#     # Create a new Power BI workspace
#     command = <<EOT
#         New-PowerBIWorkspace -Name "Tippu"
#     EOT
#   }
#    provider = null
# }
# resource "null_resource" "create_powerbi_workspace" {
#   count = var.create_resource_group ? 1 : 0

#   provisioner "local-exec" {
#     command = <<-EOT
#       $client_id =  "ea035bbf-e2f2-40cf-9746-25624d56b288"
#       $tenant_id=  "43d6e916-db90-4a6b-908e-de4a48120835"
#       $workspaceName = "Nitni"

#       $tokenUrl = "https://login.microsoftonline.com/$tenantId/oauth2/token"
#       # Continue with your PowerShell script here...
#     EOT
#   }
# }
