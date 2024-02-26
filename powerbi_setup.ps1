# # Install Power BI module
# Install-Module -Name MicrosoftPowerBIMgmt -Force -AllowClobber -Scope CurrentUser -ErrorAction Stop

# # Import Power BI module
# Import-Module MicrosoftPowerBIMgmt -ErrorAction Stop

# # Connect to Power BI (interactive login)
# Connect-PowerBIServiceAccount -ErrorAction Stop

# # Wait for the user to authenticate in the browser
# Start-Sleep -Seconds 60

# # Create Power BI workspace
# # Assuming you've already authenticated, no need for -UseDeviceAuthentication
# New-PowerBIWorkspace -Name 'Balaji' -ErrorAction Stop
# Install MicrosoftPowerBIMgmt module
#Install-Module -Name MicrosoftPowerBIMgmt -Force -AllowClobber -Scope CurrentUser -ErrorAction Stop
#$env:PSGallerySource = 'https://www.powershellgallery.com/api/v2/'
# Install-Module -Name MicrosoftPowerBIMgmt -Force -AllowClobber -Scope CurrentUser -ErrorAction Stop
# #Install-Module -Name MicrosoftPowerBIMgmt.Profile
# # Import Power BI module
# Import-Module MicrosoftPowerBIMgmt -ErrorAction Stop

# # Connect to Power BI (interactive login)
# Connect-PowerBIServiceAccount -ErrorAction Stop

# # Wait for the user to authenticate in the browser
# Start-Sleep -Seconds 60

# Create Power BI workspace
# Assuming you've already authenticated, no need for -UseDeviceAuthentication
#New-PowerBIWorkspace -Name 'Harsha1' -ErrorAction Stop

$moduleName = "MicrosoftPowerBIMgmt"

# Check if the module is already installed
if (-not (Get-Module -Name $moduleName -ListAvailable)) {
    # Module not found, install it
    Install-Module -Name $moduleName -Force -AllowClobber -Scope CurrentUser -Verbose
}

# Import the module
Import-Module -Name $moduleName

# Now you can proceed with your PowerShell commands that require the MicrosoftPowerBIMgmt module
