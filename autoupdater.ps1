$logFolder = "C:\test"
if (-not (Test-Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory -Force
}

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logPath = Join-Path $logFolder "update-log_$timestamp.log"

Import-Module PSWindowsUpdate -ErrorAction SilentlyContinue

if (-not (Get-Command Get-WindowsUpdate -ErrorAction SilentlyContinue)) {
    $msg = "De PSWindowsUpdate module is niet geïnstalleerd. Installeer deze eerst met:`nInstall-Module -Name PSWindowsUpdate"
    Write-Output $msg
    Add-Content -Path $logPath -Value $msg
    return
}

$updates = Get-WindowsUpdate -MicrosoftUpdate -IgnoreUserInput -ErrorAction SilentlyContinue

if ($updates.Count -eq 0) {
    $msg = "Je systeem is up-to-date. Geen updates gevonden."
    Write-Output $msg
    Add-Content -Path $logPath -Value $msg
} else {
    Write-Output "$($updates.Count) update(s) gevonden. Installatie wordt gestart..."
    $updates | ForEach-Object { Write-Output "- $($_.Title)" }

    $rebootMsg = "Automatische herstart is ingeschakeld indien vereist door updates."
    Write-Output $rebootMsg
    Add-Content -Path $logPath -Value $rebootMsg

    $installResults = Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot:$true -ErrorAction Continue

    $failedUpdates = $installResults | Where-Object { $_.Result -ne 'Succeeded' }

    if ($failedUpdates.Count -eq 0) {
        $msg = "Alle updates zijn succesvol geïnstalleerd."
        Write-Output $msg
        Add-Content -Path $logPath -Value $msg
    } else {
        $msg = "Sommige updates zijn NIET succesvol geïnstalleerd:"
        Write-Output $msg
        Add-Content -Path $logPath -Value $msg

        $failedUpdates | ForEach-Object {
            $logEntry = "[$($_.Date)] $($_.Title) - Resultaat: $($_.Result)"
            Write-Output $logEntry
            Add-Content -Path $logPath -Value $logEntry
        }
    }

    Write-Output "Logbestand opgeslagen op: $logPath"
}