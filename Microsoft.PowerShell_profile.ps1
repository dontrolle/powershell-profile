# My PowerShell profile - see https://github.com/dontrolle/powershell-profile
#
# The actual logic lives in profile.d/*.ps1, loaded below in filename order. Each file focuses on
# one concern (helpers, options, modules, aliases, prompt, etc.) - see the README for an overview,
# and feel free to add, remove, or reorder files there to customize your own setup.

# $PSScriptRoot resolves to the directory of this file *as invoked* - if this profile is a symlink
# (per the README's recommended setup), that's the symlink's own directory, not the real repo it
# points to. Resolve the actual link target (if any) so profile.d/profile.local.ps1 are found
# regardless of whether this file is used directly or via a symlink.
$private:ProfileScriptItem = Get-Item -Path $PSCommandPath
$private:ProfileRoot = if ($ProfileScriptItem.LinkTarget) { Split-Path -Path $ProfileScriptItem.LinkTarget -Parent } else { $PSScriptRoot }

# Optional, gitignored, personal override file - not part of the repo. Loaded first (before
# profile.d/*.ps1) so it can pre-set any option variable used in profile.d/10-options.ps1 (e.g.
# $PowershellUtilsPath) as well as run arbitrary personal tweaks (e.g. a starting
# directory). See profile.d/*.example for inspiration and the README's "Customization" section.
$private:ProfileLocalOverride = Join-Path $ProfileRoot 'profile.local.ps1'

if (Test-Path -Path $ProfileLocalOverride)
{
  . $ProfileLocalOverride
}

$private:ProfileModulesPath = Join-Path $ProfileRoot 'profile.d'

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

