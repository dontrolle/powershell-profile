# Various options - tweak these to customize behavior.

## path to the dontrolle/Powershell utils repo (https://github.com/dontrolle/Powershell)
## override by setting $PowershellUtilsPath or $env:POWERSHELL_UTILS_PATH in profile.local.ps1
## (loaded before this file - see README) if you cloned it somewhere other than the default below.
$private:PowershellUtilsPath = $PowershellUtilsPath ?? $env:POWERSHELL_UTILS_PATH ?? "$Home\src\Powershell"

## controls for outdated (winget) package checks
$private:outedDatedLastCheckFile = $outedDatedLastCheckFile ?? "$Home\.outdatedLastCheck"
$private:outedDatedLastCheckDateFormat = $outedDatedLastCheckDateFormat ?? 'dd-MM-yyyy'
$private:outedDatedLastCheckPeriodInDays = $outedDatedLastCheckPeriodInDays ?? 21

