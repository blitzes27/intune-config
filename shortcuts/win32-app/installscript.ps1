# Define the shortcuts to create
$Shortcuts = @(
    @{ Name = "Control Panel"; TargetPath = "C:\Windows\System32\control.exe" },
    @{ Name = "CMD"; TargetPath = "C:\Windows\System32\cmd.exe" },
    @{ Name = "Prisjakt"; TargetPath = "https://www.prisjakt.nu" },
    @{ Name = "Amazon"; TargetPath = "https://www.amazon.se" }
)

# Path to the public desktop folder
$UserDesktopPath = "C:\Users\Public\Desktop"

# Loop through the shortcuts to create
foreach ($App in $Shortcuts) {

    # Check if the target path is a URL
    $isUrl = $false
    if ($App.TargetPath -and $App.TargetPath -like "http*") {
        $isUrl = $true
    }

    # Define the path to the shortcut file based on whether it's a URL or not
    if ($isUrl) {
        $ShortcutFile = Join-Path -Path $UserDesktopPath -ChildPath "$($App.Name).url"
    }
    else {
        $ShortcutFile = Join-Path -Path $UserDesktopPath -ChildPath "$($App.Name).lnk"
    }

    # Check if the shortcut already exists
    if (Test-Path -Path $ShortcutFile) {
        Write-Output "Shortcut for $($App.Name) already exists at $ShortcutFile. Skipping creation." | Out-File -FilePath "C:\shortcut_log.txt" -Append
        continue
    }

    # Check if the target path exists for non-URL shortcuts
    if (-Not $isUrl -and $App.TargetPath -and (-Not (Test-Path -Path $App.TargetPath))) {
        Write-Output "The target file for $($App.Name) at $($App.TargetPath) does not exist. Skipping shortcut creation." | Out-File -FilePath "C:\shortcut_log.txt" -Append
        continue
    }

    try {
        if ($isUrl) {
            # Create a .URL file for web links
            $URLShortcut = "[InternetShortcut]`nURL=$($App.TargetPath)"
            Set-Content -Path $ShortcutFile -Value $URLShortcut
            Write-Output "Web link for $($App.Name) created successfully at $ShortcutFile." | Out-File -FilePath "C:\shortcut_log.txt" -Append
        }
        else {
            # Create a .LNK file for applications shortcuts
            $WScriptShell = New-Object -ComObject WScript.Shell
            $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
            $Shortcut.TargetPath = $App.TargetPath
            $Shortcut.WorkingDirectory = [System.IO.Path]::GetDirectoryName($App.TargetPath)
            $Shortcut.Save()
            Write-Output "Shortcut for $($App.Name) created successfully at $ShortcutFile." | Out-File -FilePath "C:\shortcut_log.txt" -Append
        }
    }
    catch {
        Write-Output "An error occurred while creating the shortcut for $($App.Name): $_" | Out-File -FilePath "C:\shortcut_log.txt" -Append
    }
}
# Output a message when the shortcut creation process is completed
# Write-Output "Shortcut creation process completed." | Out-File -FilePath "C:\shortcut_log.txt" -Append