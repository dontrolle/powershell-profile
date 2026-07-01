## Load various utils by me - see https://github.com/dontrolle/Powershell

$private:UtilsOutClipPath = "$PowershellUtilsPath\out-clip.ps1"
if (_Test-DotSourceTarget $UtilsOutClipPath) { . $UtilsOutClipPath }

$private:UtilsGetFileDefiningFunctionPath = "$PowershellUtilsPath\Get-FileDefiningFunction.ps1"
if (_Test-DotSourceTarget $UtilsGetFileDefiningFunctionPath) { . $UtilsGetFileDefiningFunctionPath }

$private:UtilsUpdateFilePath = "$PowershellUtilsPath\Update-File.ps1"
if (_Test-DotSourceTarget $UtilsUpdateFilePath) { . $UtilsUpdateFilePath }
