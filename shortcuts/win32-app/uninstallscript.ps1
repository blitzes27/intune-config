# Uninstallation script for desktop shortcuts created by the Win32 app

# Define the shortcuts to remove with filändelseinformation
$Shortcuts = @(
    @{ Name = "Control Panel"; FileExtension = ".lnk" },
    @{ Name = "CMD"; FileExtension = ".lnk" },
    @{ Name = "Prisjakt"; FileExtension = ".url" },
    @{ Name = "Amazon"; FileExtension = ".url" }
)

# Get the path to the logged-in user's desktop folder
$UserDesktopPath = [Environment]::GetFolderPath("Desktop")

# Loop through the shortcuts and remove them if they exist
foreach ($App in $Shortcuts) {
    $FilePath = Join-Path -Path $UserDesktopPath -ChildPath ("$($App.Name)$($App.FileExtension)")
    
    if (Test-Path -Path $FilePath) {
        try {
            Remove-Item -Path $FilePath -Force
            Write-Output "Removed shortcut for $($App.Name) at $FilePath." | Out-File -FilePath "C:\shortcut_uninstall_log.txt" -Append
        }
        catch {
            Write-Output "Error removing shortcut for $($App.Name): $_" | Out-File -FilePath "C:\shortcut_uninstall_log.txt" -Append
        }
    }
    else {
        Write-Output "Shortcut for $($App.Name) not found at $FilePath. Skipping removal." | Out-File -FilePath "C:\shortcut_uninstall_log.txt" -Append
    }
}

Write-Output "Uninstallation process completed." | Out-File -FilePath "C:\shortcut_uninstall_log.txt" -Append