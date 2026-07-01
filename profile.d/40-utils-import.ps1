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

$private:UtilsOutClipPath = "$PowershellUtilsPath\out-clip.ps1"
if (_Test-DotSourceTarget $UtilsOutClipPath) { . $UtilsOutClipPath }

$private:UtilsGetFileDefiningFunctionPath = "$PowershellUtilsPath\Get-FileDefiningFunction.ps1"
if (_Test-DotSourceTarget $UtilsGetFileDefiningFunctionPath) { . $UtilsGetFileDefiningFunctionPath }

$private:UtilsCloseVsHandlesPath = "$PowershellUtilsPath\close-vshandles.ps1"
if (_Test-DotSourceTarget $UtilsCloseVsHandlesPath) { . $UtilsCloseVsHandlesPath }

$private:UtilsUpdateFilePath = "$PowershellUtilsPath\Update-File.ps1"
if (_Test-DotSourceTarget $UtilsUpdateFilePath) { . $UtilsUpdateFilePath }
