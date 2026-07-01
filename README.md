# My PowerShell profile

[![PSScriptAnalyzer](https://github.com/dontrolle/powershell-profile/actions/workflows/psscriptanalyzer.yml/badge.svg)](https://github.com/dontrolle/powershell-profile/actions/workflows/psscriptanalyzer.yml)

My personal PowerShell profile, shared in case it's useful to others.

## Contents

* [Prerequisites](#prerequisites)
* [Dependencies](#dependencies)
* [Usage](#usage)
* [Updating](#updating)
* [Structure](#structure)
* [Customization](#customization)
* [Linting](#linting)
* [License](#license)

## Prerequisites

* **Windows only.** The profile assumes Windows paths (`C:\...`) and Windows-specific tools (`devenv`, `rider64.exe`, `winget`, Windows Terminal). It will not work as-is on macOS/Linux.
* **PowerShell 7.1 or later** (i.e. `pwsh`, not Windows PowerShell 5.1). The profile uses the `??` null-coalescing operator and the `.LinkTarget` property on symlinks, neither of which exist in Windows PowerShell 5.1.
* If you download the repo as a zip instead of `git clone`-ing it, Windows may block the `.ps1` files as coming from the internet - run `Get-ChildItem -Recurse *.ps1 | Unblock-File` in the repo folder, and make sure your [execution policy](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy) allows running local scripts (e.g. `RemoteSigned`).

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

## Updating

Since it's just a git repo, pull the latest changes from wherever you cloned it:

```powershell
git pull
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
* **`profile.local.ps1`**: an optional, gitignored file in the repo root. If present, it is dot-sourced *first*, before anything in `profile.d/`, so it can pre-set any option variable used in `profile.d/10-options.ps1` (e.g. `$PowershellUtilsPath`, NVIDIA GPU model) as well as run arbitrary personal tweaks (e.g. a starting directory - see `profile.d/90-personal.ps1.example`) - all without editing tracked files.
* **NVIDIA driver check**: off by default (`$ImportNvidiaDrivercheck = $false` in `10-options.ps1`). The GPU model values there are just the author's example; override them (and flip the flag on) in `profile.local.ps1` if you want this check.

## Linting

A [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) GitHub Actions workflow runs on every push/PR. Run it locally with:

```powershell
Install-Module -Name PSScriptAnalyzer -Scope CurrentUser
Invoke-ScriptAnalyzer -Path . -Settings .\PSScriptAnalyzerSettings.psd1 -Recurse
```

## License

See [LICENSE](LICENSE).


