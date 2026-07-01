### git stuff

# Ensure that Get-ChildItemColor is loaded
_Import-ModuleIfAvailable Get-ChildItemColor

# Set l and ls alias to use the new Get-ChildItemColor cmdlets
Set-Alias l Get-ChildItemColor -Option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope

# oh-my-posh load and set theme
# * Remember to install a nerd font and use it your shell (I like Terminal), see https://ohmyposh.dev/docs/fonts
# * For font, I like "FuraCode Nerd Font Mono", because it has nordic characters

# Set prompt theme
if (Get-Command -Name oh-my-posh -ErrorAction SilentlyContinue)
{
  oh-my-posh init pwsh --config "powerlevel10k_rainbow" | Invoke-Expression
}
else
{
  Write-Warning "oh-my-posh not found on PATH - skipping prompt theme. See https://ohmyposh.dev/docs/installation/windows"
}
