function ConvertTo-ExecutiveInsights {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [psobject]$Statistics

    )

    $Insights = @()

    #
    # Core License Utilization
    #

    if ($Statistics.LicenseUtilizationPercent -ge 95) {

        $Insights += "🟢 Core license utilization is $($Statistics.LicenseUtilizationPercent)%."

    }
    elseif ($Statistics.LicenseUtilizationPercent -ge 80) {

        $Insights += "🟡 Core license utilization is $($Statistics.LicenseUtilizationPercent)%. Consider reviewing available licenses."

    }
    else {

        $Insights += "🔵 Core license utilization is $($Statistics.LicenseUtilizationPercent)%."

    }

    #
    # Trial Licenses
    #

    if ($Statistics.TrialLicenseTypes -gt 0) {

        $Insights += "🟠 $($Statistics.TrialLicenseTypes) trial subscription(s) detected."

    }

    #
    # Add-ons
    #

    if ($Statistics.AddOnLicenseTypes -gt 0) {

        $Insights += "🟣 $($Statistics.AddOnLicenseTypes) paid add-on subscription(s) detected."

    }

    #
    # Capacity
    #

    if ($Statistics.CapacityLicenseTypes -gt 0) {

        $Insights += "🔷 Capacity subscriptions detected and excluded from Core License calculations."

    }

    #
    # Guests
    #

    if ($Statistics.GuestUsers -gt 0) {

        $Insights += "👥 $($Statistics.GuestUsers) guest user(s) excluded from licensing statistics."

    }

    #
    # Internal Unlicensed Users
    #

    if ($Statistics.UnlicensedUsers -gt 0) {

        $Insights += "⚠ $($Statistics.UnlicensedUsers) internal user(s) currently do not have a license."

    }

    #
    # HTML
    #

    $Html = "<ul>"

    foreach ($Item in $Insights) {

        $Html += "<li>$Item</li>"

    }

    $Html += "</ul>"

    return $Html

}