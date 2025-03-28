<#
.SYNOPSIS
  Enables Windows Firewall for Domain, Private, and Public profiles.
#>

Write-Host "Enabling Windows Firewall for Domain, Private, and Public profiles..."
Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled True
Write-Host "Windows Firewall enabled successfully."