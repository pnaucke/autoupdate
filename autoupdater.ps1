# Zorg dat je script als administrator draait
# Controleer op updates via Windows Update module

# Laad de Windows Update module
Import-Module PSWindowsUpdate -ErrorAction SilentlyContinue

if (-not (Get-Command Get-WindowsUpdate -ErrorAction SilentlyContinue)) {
    Write-Output "De PSWindowsUpdate module is niet geïnstalleerd. Installeer deze eerst met:"
    Write-Output "Install-Module -Name PSWindowsUpdate"
    return
}

# Zoek naar beschikbare updates
$updates = Get-WindowsUpdate -MicrosoftUpdate -IgnoreUserInput -AcceptAll -ErrorAction SilentlyContinue

if ($updates.Count -eq 0) {
    Write-Output "✅ Je systeem is up-to-date. Geen updates gevonden."
} else {
    Write-Output "🔔 Er zijn $($updates.Count) update(s) beschikbaar:"
    $updates | ForEach-Object {
        Write-Output "- $($_.Title)"
    }
}