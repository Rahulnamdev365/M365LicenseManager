function New-M365LicenseReport {

    [CmdletBinding()]
    param(

        [ValidateSet('Object', 'Html')]
        [string]$OutputType = 'Object',

        [string]$OutputPath = (Get-Location)

    )

    begin {

        Assert-GraphConnection

    }

    process {

        Write-Verbose "Collecting license summary..."

        $Summary = Get-LicenseSummary

        Write-Verbose "Calculating report statistics..."

        $Statistics = Get-LicenseStatistics `
            -LicenseSummary $Summary

        Write-Verbose "Building report object..."

        $Context = Get-MgContext

        $Report = [PSCustomObject]@{

            ReportName       = "Microsoft 365 License Report"

            TenantName       = $Context.Account

            TenantId         = $Context.TenantId

            GeneratedOn      = Get-Date

            PowerShellVersion = $PSVersionTable.PSVersion.ToString()

            Summary          = $Summary

            Statistics       = $Statistics

        }

        switch ($OutputType) {

            'Object' {

                return $Report

            }

            'Html' {

                Write-Verbose "Generating HTML report..."

                $Html = ConvertTo-LicenseHtml -Report $Report

                $ReportFile = Join-Path $OutputPath "LicenseReport.html"

                $Html | Out-File `
                    -FilePath $ReportFile `
                    -Encoding UTF8

                Write-Verbose "Report saved to '$ReportFile'."

                Get-Item $ReportFile

            }

        }

    }

}