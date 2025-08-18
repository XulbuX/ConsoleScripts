# ConsoleScripts

All of my different Bash, Batch and PowerShell scripts.

## win11_vm_startup.ps1

This script is supposed to be run after a fresh start of a Windows virtual machine.

The script will configure the following:
- set system to dark mode
- configure the Explorer:
  - show file extensions
  - show hidden files
  - add `Open PowerShell/CMD Here` to context menu
  - add `New PowerShell/Text Document` to context menu

Run the script with the following command in a PowerShell console (*open in the directory where the script is located*):
```powershell
powershell -ExecutionPolicy Bypass -File "./win11_vm_startup.ps1"
```
