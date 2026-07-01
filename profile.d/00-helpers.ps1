# Shared helper functions used by the other profile.d scripts.

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

function _Write-HeaderInfo($line)
{
  Write-Host $line -ForegroundColor Yellow
}

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
