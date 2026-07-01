# Various PowerShell modules

# Helper: import a module only if it's installed, otherwise warn and continue
# (so a missing dependency doesn't abort loading of the rest of the profile)
function _Import-ModuleIfAvailable([string]$Name)
{
  if (Get-Module -ListAvailable -Name $Name)
  {
    Import-Module -Name $Name
  }
  else
  {
    Write-Warning "Module '$Name' not found - skipping. Install it with: Install-Module $Name"
  }
}

# Helper: dot-source a script only if it exists, otherwise warn and continue
function _Invoke-DotSourceIfExists([string]$Path)
{
  if (Test-Path -Path $Path)
  {
    . $Path
  }
  else
  {
    Write-Warning "Script '$Path' not found - skipping."
  }
}

_Import-ModuleIfAvailable PSReadLine
_Import-ModuleIfAvailable AngleParse

# Various options
## path to the dontrolle/Powershell utils repo (https://github.com/dontrolle/Powershell)
## override by setting $env:POWERSHELL_UTILS_PATH before this profile loads, e.g. in your own
## profile.local.ps1 (see README), if you cloned it somewhere other than the default below.
$private:PowershellUtilsPath = if ($env:POWERSHELL_UTILS_PATH) { $env:POWERSHELL_UTILS_PATH } else { "$Home\src\Powershell" }

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

# Various alias's etc (assumes relevant exe's are in PATH)
function s { Set-Location .. }

function OpenWithVisualStudio ([string] $path) 
{ 
  if([string]::IsNullOrEmpty($path))
    {
      # is there a single .sln file in the directory(?) - then default to opening that one
      $slns = Get-ChildItem -filter *.sln
      if($slns.count -eq 1)
      {
        $path = $slns[0]
      }
      # on the off chance that there are several sln-files, let's signal this and make sure we open the right one
      elseif ($slns.count -gt 1){
        throw "No path given, and several .sln-files in current directory. Please specify which .sln-file to open."
      }
    }
  Start-Process devenv $path 
}

Set-Alias -Name vs -Value OpenWithVisualStudio

function OpenWithRider ([string] $path) { rider64.exe $path }

Set-Alias -Name rider -Value OpenWithRider

# Chris Titus' winutil: https://github.com/ChrisTitusTech/winutil/tree/main
Function RunCTTWinUtil { Invoke-RestMethod "https://christitus.com/win" | Invoke-Expression }

Set-Alias -Name winutil -Value RunCTTWinUtil

## Load various utils by me - see https://github.com/dontrolle/Powershell

if ($ImportNvidiaDrivercheck)
{
  $private:nvidiaModulePath = "$PowershellUtilsPath\nvidiadrivercheck.psm1"
  if (Test-Path -Path $nvidiaModulePath)
  {
    Import-Module -Name $nvidiaModulePath -ArgumentList "NVIDIA GeForce RTX 3080", $ProductType, $ProductSeries, $Product, $OperatingSystem, $DownloadType, $Language
  }
  else
  {
    Write-Warning "'$nvidiaModulePath' not found - skipping NVIDIA driver check. Is `$PowershellUtilsPath ('$PowershellUtilsPath') correct?"
  }
}

_Invoke-DotSourceIfExists "$PowershellUtilsPath\out-clip.ps1"
_Invoke-DotSourceIfExists "$PowershellUtilsPath\Get-FileDefiningFunction.ps1"
_Invoke-DotSourceIfExists "$PowershellUtilsPath\close-vshandles.ps1"
_Invoke-DotSourceIfExists "$PowershellUtilsPath\Update-File.ps1"

### git stuff

# Ensure that Get-ChildItemColor is loaded
_Import-ModuleIfAvailable Get-ChildItemColor

# Set l and ls alias to use the new Get-ChildItemColor cmdlets
Set-Alias l Get-ChildItemColor -Option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope

# oh-my-posh load and set theme
# * Remember to install a nerd font and use it your shell (I like Terminal), see https://ohmyposh.dev/docs/fonts
# * For font, I like "FuraCode Nerd Font Mono", because it has nordic characters

# Set prompt theme
if (Get-Command -Name oh-my-posh -ErrorAction SilentlyContinue)
{
  oh-my-posh init pwsh --config "powerlevel10k_rainbow" | Invoke-Expression
}
else
{
  Write-Warning "oh-my-posh not found on PATH - skipping prompt theme. See https://ohmyposh.dev/docs/installation/windows"
}

# winget autocomplete (only if winget is installed)
if (Get-Command -Name winget -ErrorAction SilentlyContinue)
{
  Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
  }
}
else
{
  Write-Warning "winget not found on PATH - skipping winget autocomplete and upgrade checks."
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

if($outDatedCheckNecessary -and (Get-Command -Name winget -ErrorAction SilentlyContinue)){
    # check for winget upgradeable
    _Write-HeaderInfo ""
    _Write-HeaderInfo "Winget upgradeable:"
    winget upgrade

    # Write current date to file, recording that we've performed the check today
    Get-Date -format $outedDatedLastCheckDateFormat | Out-File -FilePath $outedDatedLastCheckFile
}

Set-Location -Path "c:\src"
