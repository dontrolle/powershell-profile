BeforeAll {
    . (Join-Path $PSScriptRoot '..\profile.d\30-aliases-and-tools.ps1')
}

Describe 'OpenWithVisualStudio' {
    Context 'when a path is given explicitly' {
        It 'opens that path directly without looking for .sln files' {
            Mock Start-Process { }
            Mock Get-ChildItem { }

            OpenWithVisualStudio -path 'MySolution.sln'

            Should -Invoke Start-Process -ParameterFilter { $FilePath -eq 'devenv' -and $ArgumentList -eq 'MySolution.sln' } -Times 1
            Should -Invoke Get-ChildItem -Times 0
        }
    }

    Context 'when no path is given' {
        It 'opens the single .sln file found in the current directory' {
            Mock Start-Process { }
            Mock Get-ChildItem { @([System.IO.FileInfo]::new('OnlyOne.sln')) }

            OpenWithVisualStudio

            Should -Invoke Start-Process -ParameterFilter { $ArgumentList -match 'OnlyOne\.sln$' } -Times 1
        }

        It 'opens devenv without a path when no .sln file is found' {
            Mock Start-Process { }
            Mock Get-ChildItem { @() }

            { OpenWithVisualStudio } | Should -Not -Throw
            Should -Invoke Start-Process -ParameterFilter { [string]::IsNullOrEmpty($ArgumentList) } -Times 1
        }

        It 'throws when several .sln files are found' {
            Mock Start-Process { }
            Mock Get-ChildItem { @([pscustomobject]@{ Name = 'One.sln' }, [pscustomobject]@{ Name = 'Two.sln' }) }

            { OpenWithVisualStudio } | Should -Throw '*several*'
            Should -Invoke Start-Process -Times 0
        }
    }
}
