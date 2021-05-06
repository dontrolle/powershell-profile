# Simplify Powershell debugging 
Set-PSDebug -strict

# Various PowerShell modules
Import-Module PSReadLine
Import-Module AngleParse

function Test-IsElevated
{
    $id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $p = New-Object System.Security.Principal.WindowsPrincipal($id)

    if ($p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator))
    { 
      Write-Output $true 
    }
    else
    { 
      Write-Output $false 
    }
}

function s { Set-Location .. }

## Load various utils by me - see https://github.com/dontrolle/Powershell
Import-Module -Name "C:\src\Powershell\nvidiadrivercheck.psm1" -ArgumentList "NVIDIA GeForce RTX 3080", "https://www.nvidia.com/Download/processDriver.aspx?psid=120&pfid=929&rpf=1&osid=57&lid=1&lang=en-us&ctk=0&dtid=1&dtcid=1"

. "c:\src\Powershell\out-clip.ps1"
. "C:\src\Powershell\Get-FileDefiningFunction.ps1"

### Posh git stuff

# Ensure that Get-ChildItemColor is loaded
Import-Module Get-ChildItemColor

# Set l and ls alias to use the new Get-ChildItemColor cmdlets
Set-Alias l Get-ChildItemColor -Option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope

# Ensure posh-git is loaded
Import-Module -Name posh-git

# Ensure oh-my-posh is loaded
# * Remember to install a nerd font and use it your shell (I like Terminal), see https://ohmyposh.dev/docs/fonts
# * For font, I like "FuraCode Nerd Font Mono", because it has nordic characters
Import-Module -Name oh-my-posh

# Set prompt theme
Set-PoshPrompt powerline

### Choco stuff

$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# A little header with some reminders, because I forget things

function _Write-HeaderInfo($line)
{
  Write-Host $line -ForegroundColor Yellow
}

Write-Host "Installing stuff:" -ForegroundColor DarkYellow 
_Write-HeaderInfo "  [apps] winget install"
_Write-HeaderInfo "  [apps] choco install"
_Write-HeaderInfo "  [powershell] install-module"
_Write-HeaderInfo "  [npm] npm "
 Write-Host "Other" -ForegroundColor DarkYellow 
 _Write-HeaderInfo "  Check NVIDIA drivers    Test-NvidiaDriver"
_Write-HeaderInfo ""

Set-Location -Path "c:\src"