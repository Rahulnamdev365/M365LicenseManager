function Get-M365LicenseStatistics {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [object[]]$LicenseSummary,

        [Parameter(Mandatory)]
        [object[]]$UserData

    )

    # License Totals

    $TotalPurchased = ($LicenseSummary |
        Measure-Object -Property Total -Sum).Sum

    $TotalAssigned = ($LicenseSummary |
        Measure-Object -Property Assigned -Sum).Sum

    $TotalAvailable = ($LicenseSummary |
        Measure-Object -Property Available -Sum).Sum

    # User Totals

    $TotalUsers = $UserData.Count

    $InternalUsers = ($UserData |
        Where-Object { $_.IsInternal }).Count

    $GuestUsers = ($UserData |
        Where-Object { $_.IsGuest }).Count

    $LicensedUsers = ($UserData |
        Where-Object {
            $_.IsInternal -and $_.Licensed
        }).Count

    $UnlicensedUsers = ($UserData |
        Where-Object {
            $_.IsInternal -and -not $_.Licensed
        }).Count

    # License Utilization

    if ($TotalPurchased -gt 0) {

        $LicenseUtilizationPercent = [math]::Round(
            ($TotalAssigned / $TotalPurchased) * 100,
            2
        )

    }
    else {

        $LicenseUtilizationPercent = 0

    }

    # Statistics Object

    [PSCustomObject]@{

        TotalLicenseTypes          = $LicenseSummary.Count

        TotalPurchased             = $TotalPurchased

        TotalAssigned              = $TotalAssigned

        TotalAvailable             = $TotalAvailable

        TotalUsers                 = $TotalUsers

        InternalUsers              = $InternalUsers

        GuestUsers                 = $GuestUsers

        LicensedUsers              = $LicensedUsers

        UnlicensedUsers            = $UnlicensedUsers

        LicenseUtilizationPercent  = $LicenseUtilizationPercent

    }

}