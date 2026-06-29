function Test-PowerShellVersion {

    [CmdletBinding()]
    param()

    $MinimumVersion = [Version]'7.2.0'
    $CurrentVersion = $PSVersionTable.PSVersion

    if ($CurrentVersion -ge $MinimumVersion) {

        return New-CheckResult `
            -Check "PowerShell Version" `
            -Status PASS `
            -Category "Environment" `
            -Severity "Low" `
            -Details "PowerShell $CurrentVersion detected."

    }

    return New-CheckResult `
        -Check "PowerShell Version" `
        -Status FAIL `
        -Category "Environment" `
        -Severity "Critical" `
        -Details "PowerShell $CurrentVersion detected." `
        -Recommendation "Install PowerShell $MinimumVersion or later."

}