function New-M365LicenseReport {

    <#
    .SYNOPSIS
        Generates a Microsoft 365 License Report.

    .DESCRIPTION
        Collects Microsoft 365 licensing information and returns a report object
        containing tenant information, license inventory, statistics,
        user information, and unlicensed users.

        HTML report generation is supported through the Html output type.

    .PARAMETER OutputType
        Specifies the report output format.

        Object - Returns a PowerShell object.
        Html   - Generates an HTML report.

    .PARAMETER OutputPath
        Destination folder for the HTML report.

    .EXAMPLE
        New-M365LicenseReport

    .EXAMPLE
        New-M365LicenseReport `
            -OutputType Html `
            -OutputPath C:\Reports

    .NOTES
        Author  : Rahul Namdev
        Version : 0.4.0
    #>

    [CmdletBinding()]
    param(

        [Parameter()]
        [ValidateSet('Object','Html')]
        [string]$OutputType = 'Object',

        [Parameter()]
        [string]$OutputPath = (Get-Location)

    )

    begin {

        Assert-GraphConnection

    }

    process {

        Write-Verbose "Collecting license summary..."

        $Summary = Get-M365LicenseSummary

        Write-Verbose "Collecting user information..."

        $UserData = Get-M365LicenseUserData

        Write-Verbose "Calculating license statistics..."

        $Statistics = Get-M365LicenseStatistics `
            -LicenseSummary $Summary `
            -UserData $UserData

        Write-Verbose "Identifying unlicensed users..."

        $UnlicensedUsers = Get-M365UnlicensedUsers `
            -UserData $UserData

        Write-Verbose "Building report object..."

        $Context = Get-MgContext

        $Report = [PSCustomObject]@{

            ReportName        = 'Microsoft 365 License Report'

            ModuleVersion     = (Get-Module M365LicenseManager).Version.ToString()

            Account           = $Context.Account

            TenantId          = $Context.TenantId

            Environment       = $Context.Environment

            GeneratedOn       = Get-Date

            PowerShellVersion = $PSVersionTable.PSVersion.ToString()

            Statistics        = $Statistics

            Summary           = $Summary

            Users             = $UserData

            UnlicensedUsers   = $UnlicensedUsers

        }

        switch ($OutputType) {

            'Object' {

                return $Report

            }

            'Html' {

                Write-Verbose "Generating HTML report..."

                if (-not (Test-Path $OutputPath)) {

                    New-Item `
                        -ItemType Directory `
                        -Path $OutputPath `
                        -Force | Out-Null

                }

                $Html = ConvertTo-LicenseHtml `
                    -Report $Report

                $ReportFile = Join-Path `
                    -Path $OutputPath `
                    -ChildPath 'LicenseReport.html'

                $Html | Out-File `
                    -FilePath $ReportFile `
                    -Encoding UTF8

                Write-Verbose "Report saved to '$ReportFile'."

                Get-Item $ReportFile

            }

        }

    }

}