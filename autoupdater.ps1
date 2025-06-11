$configPath = Join-Path $PSScriptRoot "autoupdater.json"
$config = Get-Content -Path $configPath -Raw | ConvertFrom-Json

$logFolder = $config.LogFolder

if (-not (Test-Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory -Force | Out-Null
}

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logPath = Join-Path $logFolder "update-log_$timestamp.log"
$rebootMsg = "Automatische herstart is ingeschakeld indien vereist door updates."

Import-Module PSWindowsUpdate -ErrorAction SilentlyContinue

if (-not (Get-Command Get-WindowsUpdate -ErrorAction SilentlyContinue)) {
    $msg = "De PSWindowsUpdate module is niet geïnstalleerd. Dit wordt nu geïnstalleerd. Druk op Yes bij een melding. Bij vragen contacteer een beheerder."
    Write-Output $msg
    Add-Content -Path $logPath -Value $msg
    exit 1
}

$updates = Get-WindowsUpdate -MicrosoftUpdate -IgnoreUserInput -ErrorAction SilentlyContinue

if (-not $updates -or $updates.Count -eq 0) {
    $msg = "Je systeem is up-to-date. Geen updates gevonden."
    Write-Output $msg
    Add-Content -Path $logPath -Value $msg
} else {
    Write-Output "$($updates.Count) update(s) gevonden. Installatie wordt gestart."
    $updates | ForEach-Object { Write-Output "- $($_.Title)" }
    
    Write-Output $rebootMsg
    Add-Content -Path $logPath -Value $rebootMsg

    $installResults = Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot:$true -ErrorAction Continue

    if (-not $installResults) {
        $msg = "Installatie resultaten zijn niet beschikbaar."
        Write-Output $msg
        Add-Content -Path $logPath -Value $msg
    } else {
        $failedUpdates = $installResults | Where-Object { $_.Result -ne 'Succeeded' }

        if (-not $failedUpdates -or $failedUpdates.Count -eq 0) {
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
    }
    Write-Output "Logbestand opgeslagen op: $logPath"
}