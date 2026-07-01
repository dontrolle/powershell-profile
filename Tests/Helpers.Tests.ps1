BeforeAll {
    . (Join-Path $PSScriptRoot '..\profile.d\00-helpers.ps1')
}

Describe '_Test-DotSourceTarget' {
    It 'returns true when the path exists' {
        $existingFile = Join-Path $PSScriptRoot '..\profile.d\00-helpers.ps1'
        _Test-DotSourceTarget -Path $existingFile | Should -BeTrue
    }

    It 'returns false and writes a warning when the path does not exist' {
        $missingFile = Join-Path $PSScriptRoot 'does-not-exist.ps1'
        $output = _Test-DotSourceTarget -Path $missingFile 3>&1

        $warnings = $output | Where-Object { $_ -is [System.Management.Automation.WarningRecord] }
        $result = $output | Where-Object { $_ -is [bool] }

        $warnings | Should -Not -BeNullOrEmpty
        $result | Should -BeFalse
    }
}
