# My PowerShell profile

Relies on a few modules - can be gotten with PowerShellGet. If PowerShellGet is not already on your system, see [Installing PSGet](https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget?view=powershell-7.1)

## Dependencies 

### Modules and scripts
* [PSReadLine](https://github.com/PowerShell/PSReadLine)
* [AngleParse](https://www.powershellgallery.com/packages/AngleParse)
* [Get-ChildItemColor](https://github.com/joonro/Get-ChildItemColor)
* [Oh-My-Posh](https://ohmyposh.dev/) (supersedes Posh-Git; no need to also install Posh-Git)
  * Remember to install a [Nerd Font](https://github.com/ryanoasis/nerd-fonts/) and use it your shell (I like Windows Terminal), see https://ohmyposh.dev/docs/fonts.
  * For the font, I like "FuraCode Nerd Font Mono" (in the bundle "FiraCode Nerd Font"), because it has nordic characters; get it (or other Nerd Fonts) here: <https://www.nerdfonts.com/font-downloads>
* [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/) - used for autocomplete and a periodic "upgradeable packages" reminder.
* [A few of my own PowerShell utils](https://github.com/dontrolle/Powershell) - which may have evolved to have their own dependencies. Please check notes on usage [in that repo](https://github.com/dontrolle/Powershell/).

None of these are hard requirements: each module/tool is imported defensively, so if something isn't installed, the profile prints a warning for that piece and keeps loading the rest.

## Usage

Either 

* clone directly into your PowerShell profile directory, or,
* clone in another directory, and setup a symlink to the path where PowerShell looks for your profile. I.e., in an elevated shell, from the cloned directory, do something like:

```powershell
New-Item -Path $PROFILE -ItemType SymbolicLink -Value (Get-Item .\Microsoft.PowerShell_profile.ps1).FullName
```

## Structure

`Microsoft.PowerShell_profile.ps1` itself is just a small loader. The actual logic lives in `profile.d/`, loaded in filename order, one concern per file:

| File | Purpose |
| --- | --- |
| `00-helpers.ps1` | Shared helper functions (safe module import/dot-source, `Test-IsElevated`, etc.) |
| `10-options.ps1` | Config variables - utils path, outdated-check settings, NVIDIA driver-check example |
| `20-modules.ps1` | PSReadLine / AngleParse |
| `30-aliases-and-tools.ps1` | `s`, `vs`/`OpenWithVisualStudio`, `rider`/`OpenWithRider`, `winutil` |
| `40-utils-import.ps1` | Loads scripts from the [dontrolle/Powershell](https://github.com/dontrolle/Powershell) utils repo |
| `50-prompt-and-git.ps1` | Get-ChildItemColor, `l`/`ls` aliases, oh-my-posh prompt |
| `60-winget.ps1` | winget tab-completion |
| `70-banner-and-checks.ps1` | Startup reminders banner + periodic winget upgradeable check |
| `90-personal.ps1.example` | Example personal touch (starting directory) - not loaded automatically |

Feel free to add, remove, reorder, or split these files further to fit your own setup.

## Customization

* **Utils path**: by default the profile looks for the [dontrolle/Powershell](https://github.com/dontrolle/Powershell) utils repo at `$Home\src\Powershell`. Override this by setting `$env:POWERSHELL_UTILS_PATH` before the profile loads, or in `profile.local.ps1` (see below).
* **`profile.local.ps1`**: an optional, gitignored file in the repo root. If present, it is dot-sourced last, after everything in `profile.d/`. Use it for anything specific to you or your machine - a starting directory (see `profile.d/90-personal.ps1.example`), your NVIDIA GPU model for the driver check, a custom utils path, etc. - without editing tracked files.
* **NVIDIA driver check**: off by default (`$ImportNvidiaDrivercheck = $false` in `10-options.ps1`). The GPU model values there are just the author's example; override them (and flip the flag on) in `profile.local.ps1` if you want this check.

## Linting

A [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) GitHub Actions workflow runs on every push/PR. Run it locally with:

```powershell
Install-Module -Name PSScriptAnalyzer -Scope CurrentUser
Invoke-ScriptAnalyzer -Path . -Settings .\PSScriptAnalyzerSettings.psd1 -Recurse
```

