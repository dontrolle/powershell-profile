# My PowerShell profile - see https://github.com/dontrolle/powershell-profile
#
# The actual logic lives in profile.d/*.ps1, loaded below in filename order. Each file focuses on
# one concern (helpers, options, modules, aliases, prompt, etc.) - see the README for an overview,
# and feel free to add, remove, or reorder files there to customize your own setup.

$private:ProfileModulesPath = Join-Path $PSScriptRoot 'profile.d'

if (Test-Path -Path $ProfileModulesPath)
{
  Get-ChildItem -Path $ProfileModulesPath -Filter '*.ps1' | Sort-Object -Property Name | ForEach-Object {
    . $_.FullName
  }
}
else
{
  Write-Warning "'$ProfileModulesPath' not found - nothing loaded. Did profile.d get moved or deleted?"
}
