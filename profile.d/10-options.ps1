# Various options - tweak these to customize behavior.

## path to the dontrolle/Powershell utils repo (https://github.com/dontrolle/Powershell)
## override by setting $env:POWERSHELL_UTILS_PATH before this profile loads, e.g. in your own
## profile.local.ps1 (see README), if you cloned it somewhere other than the default below.
$private:PowershellUtilsPath = if ($env:POWERSHELL_UTILS_PATH) { $env:POWERSHELL_UTILS_PATH } else { "$Home\src\Powershell" }

## controls for outdated (winget) package checks
$private:outedDatedLastCheckFile = "$Home\.outdatedLastCheck"
$private:outedDatedLastCheckDateFormat = 'dd-MM-yyyy'
$private:outedDatedLastCheckPeriodInDays = 21

# controls for (optional) check for NVidia drivers - the values below are just an example from
# the author's machine; override them (and $ImportNvidiaDrivercheck) in profile.local.ps1 if you
# want this check, rather than editing this tracked file.
$private:ImportNvidiaDrivercheck = $false
$private:ProductType = "GeForce"
$private:ProductSeries = "GeForce RTX 30 Series"
$private:Product = "GeForce RTX 3080"
$private:OperatingSystem = "Windows 10 64-bit"
$private:DownloadType = "Game Ready Driver (GRD)"
$private:Language = "English (US)"
