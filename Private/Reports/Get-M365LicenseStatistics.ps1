function Get-M365LicenseStatistics {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [object[]]$LicenseSummary,

        [Parameter(Mandatory)]
        [object[]]$UserData

    )

    # ============================================================
    # License Categories
    # ============================================================

    $CoreLicenses = $LicenseSummary |
        Where-Object {
            $_.Category -eq 'Core' -and
            $_.Total -gt 0
        }

    $CommunicationLicenses = $LicenseSummary |
        Where-Object {
            $_.Category -eq 'Communication'
        }

    $AddOnLicenses = $LicenseSummary |
        Where-Object {
            $_.Category -eq 'AddOn'
        }

    $TrialLicenses = $LicenseSummary |
        Where-Object {
            $_.Category -eq 'Trial'
        }

    $FreeLicenses = $LicenseSummary |
        Where-Object {
            $_.Category -eq 'Free'
        }

    $CapacityLicenses = $LicenseSummary |
        Where-Object {
            $_.Category -eq 'Capacity'
        }

    # ============================================================
    # Core License Statistics
    # ============================================================

    $TotalPurchased = ($CoreLicenses |
        Measure-Object -Property Total -Sum).Sum

    $TotalAssigned = ($CoreLicenses |
        Measure-Object -Property Assigned -Sum).Sum

    $TotalAvailable = ($CoreLicenses |
        Measure-Object -Property Available -Sum).Sum

    # ============================================================
    # Category Statistics
    # ============================================================

    $CoreLicenseTypes = $CoreLicenses.Count

    $CommunicationLicenseTypes = $CommunicationLicenses.Count

    $AddOnLicenseTypes = $AddOnLicenses.Count

    $TrialLicenseTypes = $TrialLicenses.Count

    $FreeLicenseTypes = $FreeLicenses.Count

    $CapacityLicenseTypes = $CapacityLicenses.Count

    $CommunicationPurchased = ($CommunicationLicenses |
        Measure-Object -Property Total -Sum).Sum

    $AddOnPurchased = ($AddOnLicenses |
        Measure-Object -Property Total -Sum).Sum

    $TrialPurchased = ($TrialLicenses |
        Measure-Object -Property Total -Sum).Sum

    $FreePurchased = ($FreeLicenses |
        Measure-Object -Property Total -Sum).Sum

    $CapacityPurchased = ($CapacityLicenses |
        Measure-Object -Property Total -Sum).Sum

    # ============================================================
    # User Statistics
    # ============================================================

    $TotalUsers = $UserData.Count

    $InternalUsers = ($UserData |
        Where-Object IsInternal).Count

    $GuestUsers = ($UserData |
        Where-Object IsGuest).Count

    $LicensedUsers = ($UserData |
        Where-Object {
            $_.IsInternal -and $_.Licensed
        }).Count

    $UnlicensedUsers = ($UserData |
        Where-Object {
            $_.IsInternal -and -not $_.Licensed
        }).Count

    # ============================================================
    # License Utilization
    # (Core Licenses Only)
    # ============================================================

    if ($TotalPurchased -gt 0) {

        $LicenseUtilizationPercent = [math]::Round(
            ($TotalAssigned / $TotalPurchased) * 100,
            2
        )

    }
    else {

        $LicenseUtilizationPercent = 0

    }

    # ============================================================
    # Report Statistics
    # ============================================================

    [PSCustomObject]@{

        #
        # Overall
        #

        TotalLicenseTypes          = $LicenseSummary.Count

        #
        # Core
        #

        CoreLicenseTypes           = $CoreLicenseTypes

        TotalPurchased             = $TotalPurchased

        TotalAssigned              = $TotalAssigned

        TotalAvailable             = $TotalAvailable

        LicenseUtilizationPercent  = $LicenseUtilizationPercent

        #
        # Teams & Communication
        #

        CommunicationLicenseTypes  = $CommunicationLicenseTypes

        CommunicationPurchased     = $CommunicationPurchased

        #
        # Other Add-ons
        #

        AddOnLicenseTypes          = $AddOnLicenseTypes

        AddOnPurchased             = $AddOnPurchased

        #
        # Trial
        #

        TrialLicenseTypes          = $TrialLicenseTypes

        TrialPurchased             = $TrialPurchased

        #
        # Free
        #

        FreeLicenseTypes           = $FreeLicenseTypes

        FreePurchased              = $FreePurchased

        #
        # Capacity
        #

        CapacityLicenseTypes       = $CapacityLicenseTypes

        CapacityPurchased          = $CapacityPurchased

        #
        # Users
        #

        TotalUsers                 = $TotalUsers

        InternalUsers              = $InternalUsers

        GuestUsers                 = $GuestUsers

        LicensedUsers              = $LicensedUsers

        UnlicensedUsers            = $UnlicensedUsers

    }

}