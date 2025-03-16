

# Define the shortcuts to create
$Shortcuts = @(
    @{ Name = "Notepad"; TargetPath = "C:\Windows\System32\notepad.exe" },
    @{ Name = "Calculator"; TargetPath = "C:\Windows\System32\calc.exe" },
    @{ Name = "Aftonbladet"; TargetPath = "https://www.Aftonbladet.se" },
    @{ Name = "Macrumors"; TargetPath = "https://www.macrumors.com" }
)

# Path to the public desktop folder
$PublicDesktopPath = [Environment]::GetFolderPath("CommonDesktopDirectory")

# Loop through the shortcuts to create
foreach ($App in $Shortcuts) {

    # Kontrollera om målsökvägen är en URL
    $isUrl = $false
    if ($App.TargetPath -and $App.TargetPath -like "http*") {
        $isUrl = $true
    }

    # Definiera sökvägen till genvägsfilen baserat på om det är en URL eller ej
    if ($isUrl) {
        $ShortcutFile = Join-Path -Path $PublicDesktopPath -ChildPath "$($App.Name).url"
    }
    else {
        $ShortcutFile = Join-Path -Path $PublicDesktopPath -ChildPath "$($App.Name).lnk"
    }

    # Kontrollera om genvägen redan finns
    if (Test-Path -Path $ShortcutFile) {
        Write-Output "Shortcut for $($App.Name) already exists at $ShortcutFile. Skipping creation." | Out-File -FilePath "C:\shortcut_log.txt" -Append
        continue
    }

    # För icke-URL genvägar, kontrollera att målfilen finns
    if (-Not $isUrl -and $App.TargetPath -and (-Not (Test-Path -Path $App.TargetPath))) {
        Write-Output "The target file for $($App.Name) at $($App.TargetPath) does not exist. Skipping shortcut creation." | Out-File -FilePath "C:\shortcut_log.txt" -Append
        continue
    }

    try {
        if ($isUrl) {
            # Skapa en .URL-fil för webblänkar
            $URLShortcut = "[InternetShortcut]`nURL=$($App.TargetPath)"
            Set-Content -Path $ShortcutFile -Value $URLShortcut
            Write-Output "Web link for $($App.Name) created successfully at $ShortcutFile." | Out-File -FilePath "C:\shortcut_log.txt" -Append
        }
        else {
            # Skapa en .LNK-fil för applikationsgenvägar
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

# Skriv ut ett meddelande när skapandeprocessen är klar
Write-Output "Shortcut creation process completed." | Out-File -FilePath "C:\shortcut_log.txt" -Append