function Get-M365LicenseSummary {

    [CmdletBinding()]
    param()

    $Inventory = Get-M365LicenseInventory

    foreach ($License in $Inventory) {

        #
        # Normalize values for comparison
        #

        $Sku  = $License.SkuPartNumber.ToUpper()
        $Name = $License.DisplayName.ToUpper()

        #
        # Default category
        # Most Microsoft subscriptions are treated as Add-ons unless
        # they match a Core User License.
        #

        $Category = 'AddOn'

        switch ($true) {
        
        #
        # ============================================================
        # Teams / Communication
        # ============================================================
        #

        {
            $Sku -match 'MCOP|PSTN|PHONE|AUDIOCONF|OPERATOR|ROOMS|TEAMS|MCO' -or
            $Sku -match 'MICROSOFT_TEAMS|OPERATOR_CONNECT' -or

            $Name -match 'TEAMS|ROOMS|CALLING|PHONE|COMMUNICATION|PSTN|OPERATOR CONNECT|AUDIO CONFERENCING|DOMESTIC CALLING|INTERNATIONAL CALLING|COMMUNICATIONS CREDITS'
        } {

            $Category = 'Communication'
            break

        }

        #
        # ============================================================
        # Core User Licenses
        # Microsoft 365 / Office 365 / Business / F-Series
        # ============================================================
        #

        {
            $Name -match '^MICROSOFT 365' -or
            $Name -match '^OFFICE 365' -or
            $Name -match '^EXCHANGE ONLINE' -or

            $Sku -match '^SPE_' -or
            $Sku -match '^ENTERPRISEPACK$' -or
            $Sku -match '^STANDARDPACK$' -or
            $Sku -match '^EXCHANGEENTERPRISE$' -or
            $Sku -match '^EXCHANGESTANDARD$' -or
            $Sku -match '^BUSINESS'
        } {

            $Category = 'Core'
            break

        }

            #
            # ============================================================
            # Trial Licenses
            # ============================================================
            #

            {
                $Sku -match 'TRIAL|VTRIAL|VIRAL'
            } {

                $Category = 'Trial'
                break

            }

            #
            # ============================================================
            # Free Licenses
            # ============================================================
            #

            {
                $Sku -match 'FREE|EXPLORATORY|POWERAPPS_DEV|POWERAPPS_INDIVIDUAL_USER' -or
                $Name -match '\(FREE\)|FREE|EXPLORATORY|DEVELOPER'
            } {

                $Category = 'Free'
                break

            }

            #
            # ============================================================
            # Capacity / Storage Licenses
            # ============================================================
            #

            {
                $Sku -match 'CAPACITY|STORAGE|CDS_|DATAVERSE|DB_|FILE_|LOG_'
            } {

                $Category = 'Capacity'
                break

            }
            

            #
            # ============================================================
            # Paid Add-ons
            # ============================================================
            #

            {
                $Sku -match 'COPILOT|VISIO|PROJECT|POWERBI|PBI_|EMS|POWERAUTOMATE|POWERAPPS|DYN365|RIGHTSMANAGEMENT|WIN_DEF|REMOTE_ASSIST|FORMS'
            } {

                $Category = 'AddOn'
                break

            }

        }

        [PSCustomObject]@{

            #
            # License Information
            #

            License       = $License.DisplayName

            SkuPartNumber = $License.SkuPartNumber

            Category      = $Category

            #
            # Category Flags
            #

            IsCore        = ($Category -eq 'Core')

            IsTrial       = ($Category -eq 'Trial')

            IsFree        = ($Category -eq 'Free')

            IsCapacity    = ($Category -eq 'Capacity')

            IsAddOn       = ($Category -eq 'AddOn')

            #
            # Consumption
            #

            Assigned      = $License.Consumed

            Available     = $License.Available

            Total         = $License.Purchased

        }

    }

}