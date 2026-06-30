function Get-LicenseSummary {

    [CmdletBinding()]
    param()

    $Inventory = Get-M365LicenseInventory

    foreach ($License in $Inventory) {

        [PSCustomObject]@{

            License       = $License.License
            SkuPartNumber = $License.SkuPartNumber
            Assigned      = $License.ConsumedUnits
            Available     = $License.AvailableUnits
            Total         = $License.TotalUnits

        }

    }

}