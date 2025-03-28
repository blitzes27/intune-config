<# 
.SYNOPSIS
    Configures Microsoft Defender Antivirus with additional advanced settings.
.DESCRIPTION
    This script enables:
      - Real-time Protection
      - Block at First Sight 
      - Scanning of all downloaded files and attachments
      - Cloud-delivered Protection (MAPS set to Advanced)
      - Automatic Sample Submission (send all samples automatically)
      - Cloud Block Level set to High
      - More information can be found at:
        https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/configure-microsoft-defender-antivirus-settings?view=o365-worldwide
.NOTES
    Run this script as Administrator.
#>

# Enable Real-time Protection
Set-MpPreference -DisableRealtimeMonitoring 0

# Enable Block at First Sight (set DisableBlockAtFirstSeen to 0)
Set-MpPreference -DisableBlockAtFirstSeen 0

# Enable scanning of all downloaded files and attachments is enabled (set DisableIOAVProtection to 0)
Set-MpPreference -DisableIOAVProtection 0

# Enable Cloud-delivered Protection by setting MAPS reporting to Advanced
Set-MpPreference -MAPSReporting Advanced

# Enable Automatic Sample Submission (Send All Samples Automatically)
Set-MpPreference -SubmitSamplesConsent SendAllSamples

# Set Cloud Block Level to High for aggressive blocking of suspicious files
Set-MpPreference -CloudBlockLevel High

Write-Host "Microsoft Defender settings have been updated."