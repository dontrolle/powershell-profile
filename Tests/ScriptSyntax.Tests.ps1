BeforeDiscovery {
    $script:AllScripts = Get-ChildItem -Path (Join-Path $PSScriptRoot '..') -Filter '*.ps1' -Recurse |
        Where-Object { $_.FullName -notlike (Join-Path $PSScriptRoot '*') }
}

Describe 'Script syntax' {
    It 'parses <_.Name> without errors' -ForEach $AllScripts {
        $errors = $null
        [System.Management.Automation.Language.Parser]::ParseFile($_.FullName, [ref]$null, [ref]$errors) | Out-Null
        $errors | Should -BeNullOrEmpty
    }
}
