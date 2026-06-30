function Get-LicenseStatistics {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [object[]]$LicenseSummary

    )

    [PSCustomObject]@{

        TotalLicenseTypes = $LicenseSummary.Count

        TotalAssigned = ($LicenseSummary |
            Measure-Object Assigned -Sum).Sum

        TotalAvailable = ($LicenseSummary |
            Measure-Object Available -Sum).Sum

        TotalPurchased = ($LicenseSummary |
            Measure-Object Total -Sum).Sum

    }

}