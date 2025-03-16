# Original script by: Jatin-Makhija-sys
# Source: https://github.com/Jatin-Makhija-sys/Powershell-Scripts/blob/master/Intune/Windows%20General/Create%20Desktop%20Shortcuts/Create_Desktop_Shortcuts_Public_Desktop_v1.ps1
# Modified by: Blitzes27
# Changes:
# - Changed web shortcut creation from .LNK files to .URL files.
# - Uses Set-Content to create .URL files with [InternetShortcut] format.
# - Removed WScript.Shell COM object for web links, as it is unnecessary for .URL files.
# - Program shortcuts (.EXE) still use .LNK files.
# - Added error handling for shortcut creation process.
# - Ensured compatibility with Intune deployment.


# Define the shortcuts to create
$Shortcuts = @(
    @{ Name = "Notepad"; TargetPath = "C:\Windows\System32\notepad.exe" },
    @{ Name = "Calculator"; TargetPath = "C:\Windows\System32\calc.exe" },
    @{ Name = "Aftonbladet"; TargetPath = "https://www.Aftonbladet.se" },
    @{ Name = "Macrumors"; TargetPath = "https://www.macrumors.com" }
)

# Path to the public desktop folder
$PublicDesktopPath = "$env:Public\Desktop"

# Loop through the shortcuts to create
foreach ($App in $Shortcuts) {

    # Define the path to the shortcut file
    $ShortcutFile = Join-Path -Path $PublicDesktopPath -ChildPath "$($App.Name).lnk"
    
    # Check if the shortcut already exists
    if (Test-Path -Path $ShortcutFile) {
        Write-Output "Shortcut for $($App.Name) already exists at $ShortcutFile. Skipping creation." | Out-File -FilePath "C:\shortcut_log.txt" -Append
        continue
    }
    # Check if the target path is a URL
    $isUrl = $false
    if ($App.TargetPath -and $App.TargetPath -like "http*") {
        $isUrl = $true
    }

    # Check if the target path exists for non-URL shortcuts
    if (-Not $isUrl -and $App.TargetPath -and (-Not (Test-Path -Path $App.TargetPath))) {
        Write-Output "The target file for $($App.Name) at $($App.TargetPath) does not exist. Skipping shortcut creation." | Out-File -FilePath "C:\shortcut_log.txt" -Append
        continue
    }

    try {
        if ($isUrl) {
            # Create a .URL file for web links
            $ShortcutFile = "$PublicDesktopPath\$($App.Name).url"
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
        # Handle any errors that occur during the shortcut creation process
        Write-Output "An error occurred while creating the shortcut for $($App.Name): $_" | Out-File -FilePath "C:\shortcut_log.txt" -Append
    }
}
# Output a message when the shortcut creation process is completed
Write-Output "Shortcut creation process completed." | Out-File -FilePath "C:\shortcut_log.txt" -Append