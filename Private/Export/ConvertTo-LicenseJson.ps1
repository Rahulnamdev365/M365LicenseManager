function ConvertTo-LicenseJson {

    <#
    .SYNOPSIS
        Converts a Microsoft 365 License Report to JSON.

    .DESCRIPTION
        Serializes the report object into formatted JSON for
        automation, APIs, Power BI, archival, or integration.

    .PARAMETER Report
        Report object returned by New-M365LicenseReport.

    .OUTPUTS
        System.String

    .NOTES
        Author  : Rahul Namdev
        Version : 0.7.0
    #>

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [psobject]$Report

    )

    return (
        $Report |
        ConvertTo-Json `
            -Depth 20 `
            -Compress:$false `
            -EnumsAsStrings
    )

}