
############################################################ DARKMODE ############################################################

Write-Host "`nApplying DarkMode..."

Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0

# SET DARKMODE WALLPAPER
$wallpaperPath = "C:\Windows\Web\Wallpaper\Windows\img19.jpg"
$code = @'
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
'@

Add-Type $code
$SPI_SETDESKWALLPAPER = 0x0014
$UPDATE_INI_FILE = 0x01
$SEND_CHANGE = 0x02

[Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $wallpaperPath, ($UPDATE_INI_FILE -bor $SEND_CHANGE))

Write-Host "DarkMode set successfully!"


############################################################ EXPLORER ############################################################

Write-Host "`nConfiguring Explorer settings..."

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f

# FIX SLOW MSI PACKAGE INSTALL | SEE: https://github.com/microsoft/Windows-Sandbox/issues/68#issuecomment-2754867968
reg add HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy /v VerifiedAndReputablePolicyState /t REG_DWORD /d 0 /f
CiTool.exe --refresh --json | Out-Null

# CHANGE EXECUTION POLICY TO ALLOW RUNNING SCRIPTS
try { Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine -ErrorAction Stop | Out-Null } catch {}

# ADD 'Open PowerShell/CMD Here' TO CONTEXT MENU
Write-Host "Adding 'Open PowerShell/CMD Here' context menu options..."
$powershellPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$cmdPath = "C:\Windows\System32\cmd.exe"
If (!(Test-Path $powershellPath)) { $powershellPath = $null; Write-Host "PowerShell executable not found. Can't add context menu option 'Open PowerShell Here'." }
If ($null -ne $powershellPath) {
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\MyPowerShell" /ve /d "Open PowerShell Here" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\MyPowerShell" /v "Icon" /t REG_SZ /d "$powershellPath,0" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\MyPowerShell\command" /ve /d "powershell.exe -noexit -command Set-Location -literalPath '%V'" /f
}
If (!(Test-Path $cmdPath)) { $cmdPath = $null; Write-Host "CMD executable not found. Can't add context menu option 'Open CMD Here'." }
If ($null -ne $cmdPath) {
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\Mycmd" /ve /d "Open CMD Here" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\Mycmd" /v "Icon" /t REG_SZ /d "$cmdPath,0" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\Mycmd\command" /ve /d "cmd.exe /s /k cd /d `"\`"%V`"\`"" /f
}

# ADD FILE TYPES FOR CREATING NEW FILES TO CONTEXT MENU
Write-host "Adding 'New Text Document' to context menu..."
reg add "HKEY_CLASSES_ROOT\txtfile" /ve /d "Text Document" /f
reg add "HKEY_CLASSES_ROOT\.txt\ShellNew" /f
reg --% add "HKEY_CLASSES_ROOT\.txt\ShellNew" /v "NullFile" /t REG_SZ /d "" /f
reg add "HKEY_CLASSES_ROOT\.txt\ShellNew" /v "ItemName" /t REG_SZ /d "New Text Document" /f
Write-host "Adding 'New PowerShell Script' to context menu..."
reg add "HKEY_CLASSES_ROOT\.ps1" /ve /d "ps1file" /f
reg add "HKEY_CLASSES_ROOT\ps1file" /ve /d "PowerShell Script" /f
reg add "HKEY_CLASSES_ROOT\ps1file\DefaultIcon" /ve /d "%SystemRoot%\System32\imageres.dll,-5372" /f
reg add "HKEY_CLASSES_ROOT\.ps1\ShellNew" /ve /d "ps1file" /f
reg add "HKEY_CLASSES_ROOT\.ps1\ShellNew" /f
reg --% add "HKEY_CLASSES_ROOT\.ps1\ShellNew" /v "NullFile" /t REG_SZ /d "" /f
reg add "HKEY_CLASSES_ROOT\.ps1\ShellNew" /v "ItemName" /t REG_SZ /d "script" /f

Write-host "Configured Explorer settings successfully!"


############################################################ FINALIZATION ############################################################

# RESTART EXPLORER SO CHANGES TAKE EFFECT
Stop-Process -Name explorer -Force
Start-Process explorer
