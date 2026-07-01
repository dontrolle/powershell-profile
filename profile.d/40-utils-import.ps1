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
