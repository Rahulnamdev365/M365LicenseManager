function Test-GraphConnection {

    [CmdletBinding()]
    param()

    try {

        $Context = Get-MgContext

        if ($null -eq $Context) {
            return New-CheckResult `
                -Check "Graph Connection" `
                -Status WARNING `
                -Category "Graph" `
                -Severity Medium `
                -Details "Not connected to Microsoft Graph." `
                -Recommendation "Run Connect-M365License"
        }

        return New-CheckResult `
            -Check "Graph Connection" `
            -Status PASS `
            -Category "Graph" `
            -Severity Low `
            -Details "Connected as $($Context.Account)"

    }
    catch {

        return New-CheckResult `
            -Check "Graph Connection" `
            -Status FAIL `
            -Category "Graph" `
            -Severity High `
            -Details $_.Exception.Message
    }
}