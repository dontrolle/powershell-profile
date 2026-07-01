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

function _Test-DotSourceTarget([string]$Path)
{
  # NOTE: intentionally does not dot-source $Path itself - dot-sourcing from inside a function
  # would trap anything the script defines in this function's local scope, discarding it once the
  # function returns. Callers must dot-source directly, e.g.:
  #   if (_Test-DotSourceTarget $path) { . $path }
  if (Test-Path -Path $Path)
  {
    return $true
  }

  Write-Warning "Script '$Path' not found - skipping."
  return $false
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
