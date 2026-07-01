@{
    # Settings for PSScriptAnalyzer, used by the CI workflow (see .github/workflows/psscriptanalyzer.yml)
    # and optionally locally via: Invoke-ScriptAnalyzer -Path . -Settings .\PSScriptAnalyzerSettings.psd1 -Recurse

    ExcludeRules = @(
        # This is an interactive shell profile, not a reusable module - Write-Host for
        # human-facing banners and Invoke-Expression for prompt/theme init are expected here.
        'PSAvoidUsingWriteHost',
        'PSAvoidUsingInvokeExpression'
    )
}
