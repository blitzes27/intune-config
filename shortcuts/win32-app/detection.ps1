# Uppload this for the detection rule in the Win32 app configuration
$desktopPath = "C:\Users\Public\Desktop"
$shortcutFile = Join-Path -Path $desktopPath -ChildPath "CMD.lnk"
if (Test-Path -Path $shortcutFile) {
    exit 0   # Shortcut exists
} else {
    exit 1   # Shortcut not found
}