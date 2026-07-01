# A little header with some reminders, because I forget things

Write-Host "Installing stuff" -ForegroundColor DarkYellow 
_Write-HeaderInfo "  [powershell]`t`tInstall-Module"
 Write-Host "Other" -ForegroundColor DarkYellow

 if($ImportNvidiaDrivercheck) {
  _Write-HeaderInfo "  Check NVIDIA drivers`tTest-NvidiaDriver"
 }

 _Write-HeaderInfo "  Loaded PS Modules`tGet-Module -ListAvailable"
_Write-HeaderInfo ""

# check for outdated packages now and then
$private:outDatedCheckNecessary = $false

if(!(Test-Path -Path $outedDatedLastCheckFile)){
  # no date for last check recorded; we should check and create file
  $outDatedCheckNecessary = $true
}
else {
  # has relevant number of days gone by since last check?
  $lastCheckString = Get-Content -Path $outedDatedLastCheckFile  
  $lastCheck = [DateTime]::ParseExact($lastCheckString, $outedDatedLastCheckDateFormat, $null)
  $lastCheckAddDays = $lastCheck.AddDays($outedDatedLastCheckPeriodInDays)
  $today = Get-Date
  if($lastCheckAddDays -lt $today){
    $outDatedCheckNecessary = $true
  }
}

if($outDatedCheckNecessary -and (Get-Command -Name winget -ErrorAction SilentlyContinue)){
    # check for winget upgradeable
    _Write-HeaderInfo ""
    _Write-HeaderInfo "Winget upgradeable:"
    winget upgrade

    # Write current date to file, recording that we've performed the check today
    Get-Date -format $outedDatedLastCheckDateFormat | Out-File -FilePath $outedDatedLastCheckFile
}
