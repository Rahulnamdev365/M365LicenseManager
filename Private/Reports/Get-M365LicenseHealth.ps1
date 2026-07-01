function Get-M365LicenseHealth {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [psobject]$Statistics

    )

    $Health = [ordered]@{}

    #
    # Core Utilization
    #

    if ($Statistics.LicenseUtilizationPercent -ge 95) {

        $Health.CoreLicenses = "Critical"

    }
    elseif ($Statistics.LicenseUtilizationPercent -ge 80) {

        $Health.CoreLicenses = "Warning"

    }
    else {

        $Health.CoreLicenses = "Healthy"

    }

    #
    # Trial
    #

    if ($Statistics.TrialLicenseTypes -gt 0) {

        $Health.Trials = "Warning"

    }
    else {

        $Health.Trials = "Healthy"

    }

    #
    # Unlicensed Users
    #

    if ($Statistics.UnlicensedUsers -gt 0) {

        $Health.UnlicensedUsers = "Warning"

    }
    else {

        $Health.UnlicensedUsers = "Healthy"

    }

    #
    # Capacity
    #

    if ($Statistics.CapacityLicenseTypes -gt 0) {

        $Health.Capacity = "Information"

    }

    #
    # Overall
    #

    if ($Health.Values -contains "Critical") {

        $Health.Overall = "Critical"

    }
    elseif ($Health.Values -contains "Warning") {

        $Health.Overall = "Warning"

    }
    else {

        $Health.Overall = "Healthy"

    }

    return [PSCustomObject]$Health

}