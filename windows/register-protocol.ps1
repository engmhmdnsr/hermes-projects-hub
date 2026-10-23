#Requires -RunAsAdministrator
# Registers the mysessions:// URL scheme so picker-page buttons can open
# a ready terminal session via session-launcher.vbs.
# Rename the scheme here AND in session-launcher.vbs if you want your own.
# Hermes Desktop owns hermes:// : never register that scheme yourself.
$Scheme = "mysessions"
$Handler = Join-Path $PSScriptRoot "session-launcher.vbs"
$Base = "HKCU:\Software\Classes\$Scheme"
New-Item -Path $Base -Force | Out-Null
Set-ItemProperty -Path $Base -Name "(Default)" -Value "URL:Project Session Launcher"
New-ItemProperty -Path $Base -Name "URL Protocol" -Value "" -Force | Out-Null
$Cmd = "$Base\shell\open\command"
New-Item -Path $Cmd -Force | Out-Null
Set-ItemProperty -Path $Cmd -Name "(Default)" -Value "wscript.exe `"$Handler`" `"%1`""
Write-Host "Registered $Scheme :// -> $Handler"
