@{
    # Settings for PSScriptAnalyzer, used by the CI workflow (see .github/workflows/psscriptanalyzer.yml)
    # and optionally locally via: Invoke-ScriptAnalyzer -Path . -Settings .\PSScriptAnalyzerSettings.psd1 -Recurse

    ExcludeRules = @(
        # This is an interactive shell profile, not a reusable module - Write-Host for
        # human-facing banners and Invoke-Expression for prompt/theme init are expected here.
        'PSAvoidUsingWriteHost',
        'PSAvoidUsingInvokeExpression',
        # The profile is split into profile.d/*.ps1 files that are dot-sourced together and share
        # scope (e.g. options set in 10-options.ps1 are used by later files) - analyzed per-file,
        # this rule produces false positives for variables that are used from a different file.
        'PSUseDeclaredVarsMoreThanAssignments'
    )
}
