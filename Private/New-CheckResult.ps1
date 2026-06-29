function New-CheckResult {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Check,

        [Parameter(Mandatory)]
        [ValidateSet('PASS','FAIL','WARNING','INFO')]
        [string]$Status,

        [Parameter(Mandatory)]
        [string]$Category,

        [ValidateSet('Low','Medium','High','Critical')]
        [string]$Severity = 'Low',

        [string]$Details,

        [string]$Recommendation
    )

    [PSCustomObject]@{
        Check          = $Check
        Status         = $Status
        Category       = $Category
        Severity       = $Severity
        Details        = $Details
        Recommendation = $Recommendation
        Timestamp      = Get-Date
    }
}