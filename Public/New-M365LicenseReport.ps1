function New-M365LicenseReport {

    <#
    .SYNOPSIS
        Generates a Microsoft 365 license report.

    .DESCRIPTION
        Collects Microsoft 365 licensing information and returns a report object
        containing tenant information, license inventory, statistics, user data,
        and unlicensed users.

        HTML export support will be available when the HTML renderer is completed.

    .PARAMETER OutputType
        Specifies the output format.

        Object - Returns a PowerShell object (Default)
        Html   - Generates an HTML report

    .PARAMETER OutputPath
        Folder where the HTML report will be saved.

    .EXAMPLE
        New-M365LicenseReport

    .EXAMPLE
        New-M365LicenseReport -OutputType Html -OutputPath C:\Reports

    .NOTES
        Author  : Rahul Namdev
        Version : 0.4.0
    #>

    [CmdletBinding()]
    param(

        [Parameter()]
        [ValidateSet('Object', 'Html')]
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

        Write-Verbose "Calculating license statistics..."

        $Statistics = Get-M365LicenseStatistics `
            -LicenseSummary $Summary

        Write-Verbose "Collecting user information..."

        $UserData = Get-M365LicenseUserData

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
                    $OutputPath `
                    "LicenseReport.html"

                $Html | Out-File `
                    -FilePath $ReportFile `
                    -Encoding UTF8

                Write-Verbose "Report saved to '$ReportFile'."

                Get-Item $ReportFile

            }

        }

    }

}