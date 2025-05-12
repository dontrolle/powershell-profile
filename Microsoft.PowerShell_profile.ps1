# Simplify Powershell debugging 
Set-PSDebug -strict

# Various PowerShell modules
Import-Module PSReadLine
Import-Module AngleParse

# Various options
## controls for outdated checks
$private:outedDatedLastCheckFile = "$Home\.outdatedLastCheck"
$private:outedDatedLastCheckDateFormat = 'dd-MM-yyyy'
$private:outedDatedLastCheckPeriodInDays = 21

# controls for (optional) check for NVidia drivers
$private:ImportNvidiaDrivercheck = $false
$private:ProductType = "GeForce"
$private:ProductSeries = "GeForce RTX 30 Series"
$private:Product = "GeForce RTX 3080"
$private:OperatingSystem = "Windows 10 64-bit"
$private:DownloadType = "Game Ready Driver (GRD)"
$private:Language = "English (US)"

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

if ($ImportNvidiaDrivercheck)
{
  Import-Module -Name "C:\src\Powershell\nvidiadrivercheck.psm1" -ArgumentList "NVIDIA GeForce RTX 3080", $ProductType, $ProductSeries, $Product, $OperatingSystem, $DownloadType, $Language
}

. "c:\src\Powershell\out-clip.ps1"
. "C:\src\Powershell\Get-FileDefiningFunction.ps1"
. "C:\src\Powershell\close-vshandles.ps1"

### Posh git stuff

# Ensure that Get-ChildItemColor is loaded
Import-Module Get-ChildItemColor

# Set l and ls alias to use the new Get-ChildItemColor cmdlets
Set-Alias l Get-ChildItemColor -Option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope

# Ensure posh-git is loaded
Import-Module -Name posh-git

# oh-my-posh load and set theme
# * Remember to install a nerd font and use it your shell (I like Terminal), see https://ohmyposh.dev/docs/fonts
# * For font, I like "FuraCode Nerd Font Mono", because it has nordic characters

# Set prompt theme
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/powerlevel10k_rainbow.omp.json" | Invoke-Expression

# winget autocomplete
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
      [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
      $Local:word = $wordToComplete.Replace('"', '""')
      $Local:ast = $commandAst.ToString().Replace('"', '""')
      winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
          [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
      }
}

# A little header with some reminders, because I forget things

function _Write-HeaderInfo($line)
{
  Write-Host $line -ForegroundColor Yellow
}

Write-Host "Installing stuff" -ForegroundColor DarkYellow 
_Write-HeaderInfo "  [powershell]`t`tInstall-Module"
 Write-Host "Other" -ForegroundColor DarkYellow

 if($ImportNvidiaDrivercheck) {
  _Write-HeaderInfo "  Check NVIDIA drivers`tTest-NvidiaDriver"
 }

 _Write-HeaderInfo "  Loaded PS Modules`tGet-Module -ListAvailable"
_Write-HeaderInfo ""

# check for outdated packages now and then
$private:outDatedCheckNecessary = $false

if(!(Test-Path -Path $outedDatedLastCheckFile)){
  # no date for last check recorded; we should check and create file
  $outDatedCheckNecessary = $true
}
else {
  # has relevant number of days gone by since last check?
  $lastCheckString = Get-Content -Path $outedDatedLastCheckFile  
  $lastCheck = [DateTime]::ParseExact($lastCheckString, $outedDatedLastCheckDateFormat, $null)
  $lastCheckAddDays = $lastCheck.AddDays($outedDatedLastCheckPeriodInDays)
  $today = Get-Date
  if($lastCheckAddDays -lt $today){
    $outDatedCheckNecessary = $true
  }
}

if($outDatedCheckNecessary){
    # check for winget upgradeable
    _Write-HeaderInfo ""
    _Write-HeaderInfo "Winget upgradeable:"
    winget upgrade

    # Write current date to file, recording that we've performed the check today
    Get-Date -format $outedDatedLastCheckDateFormat | Out-File -FilePath $outedDatedLastCheckFile
}

Set-Location -Path "c:\src"
