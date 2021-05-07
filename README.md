# My PowerShell profile

Relies on a few modules - can be gotten with PowerShellGet. If PowerShellGet is not already on your system, see [Installing PSGet](https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget?view=powershell-7.1)

## Dependencies 

### Modules and scripts
* [PSReadLine](https://github.com/PowerShell/PSReadLine)
* [Get-ChildItemColor](https://github.com/joonro/Get-ChildItemColor)
* [Posh-Git](https://github.com/dahlbyk/posh-git)
* [Oh-My-Posh](https://ohmyposh.dev/)
  * Remember to install a Nerd Font and use it your shell (I like Windows Terminal), see https://ohmyposh.dev/docs/fonts
  * For the font, I like "FuraCode Nerd Font Mono", because it has nordic characters; get it (or other Nerd Fonts) here: <https://www.nerdfonts.com/font-downloads>
* [A few of my own PowerShell utils](https://github.com/dontrolle/Powershell)

### Other

* Loads a [Chocolatey](https://chocolatey.org/) profile.

## Usage

Either 

* clone directly into your PowerShell profile directory, or,
* clone in another directory, and setup a symlink to the path where PowerShell looks for your profile. I.e., from the cloned directory, do something like:

```powershell
New-Item -Path $PROFILE -ItemType SymbolicLink -Value (Get-Item .\Microsoft.PowerShell_profile.ps1).FullName
```
