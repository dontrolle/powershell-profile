# Various options - tweak these to customize behavior.

## path to the dontrolle/Powershell utils repo (https://github.com/dontrolle/Powershell)
## override by setting $PowershellUtilsPath or $env:POWERSHELL_UTILS_PATH in profile.local.ps1
## (loaded before this file - see README) if you cloned it somewhere other than the default below.
$private:PowershellUtilsPath = $PowershellUtilsPath ?? $env:POWERSHELL_UTILS_PATH ?? "$Home\src\Powershell"

## controls for outdated (winget) package checks
$private:outedDatedLastCheckFile = $outedDatedLastCheckFile ?? "$Home\.outdatedLastCheck"
$private:outedDatedLastCheckDateFormat = $outedDatedLastCheckDateFormat ?? 'dd-MM-yyyy'
$private:outedDatedLastCheckPeriodInDays = $outedDatedLastCheckPeriodInDays ?? 21

# controls for (optional) check for NVidia drivers - the values below are just an example from
# the author's machine; override them (and $ImportNvidiaDrivercheck) in profile.local.ps1 if you
# want this check, rather than editing this tracked file.
$private:ImportNvidiaDrivercheck = $ImportNvidiaDrivercheck ?? $false
$private:ProductType = $ProductType ?? "GeForce"
$private:ProductSeries = $ProductSeries ?? "GeForce RTX 30 Series"
$private:Product = $Product ?? "GeForce RTX 3080"
$private:OperatingSystem = $OperatingSystem ?? "Windows 10 64-bit"
$private:DownloadType = $DownloadType ?? "Game Ready Driver (GRD)"
$private:Language = $Language ?? "English (US)"

