# Various alias's etc (assumes relevant exe's are in PATH)
function s { Set-Location .. }

function OpenWithVisualStudio ([string] $path) 
{ 
  if([string]::IsNullOrEmpty($path))
    {
      # is there a single .sln file in the directory(?) - then default to opening that one
      $slns = Get-ChildItem -filter *.sln
      if($slns.count -eq 1)
      {
        $path = $slns[0]
      }
      # on the off chance that there are several sln-files, let's signal this and make sure we open the right one
      elseif ($slns.count -gt 1){
        throw "No path given, and several .sln-files in current directory. Please specify which .sln-file to open."
      }
    }
  Start-Process devenv $path 
}

Set-Alias -Name vs -Value OpenWithVisualStudio

function OpenWithRider ([string] $path) { rider64.exe $path }

Set-Alias -Name rider -Value OpenWithRider

# Chris Titus' winutil: https://github.com/ChrisTitusTech/winutil/tree/main
# NOTE: this downloads and executes a remote script from christitus.com on every call - review
# https://github.com/ChrisTitusTech/winutil if you want to verify what it does before trusting it.
Function RunCTTWinUtil { Invoke-RestMethod "https://christitus.com/win" | Invoke-Expression }

Set-Alias -Name winutil -Value RunCTTWinUtil
