function Get-M365LicenseSummary {

    [CmdletBinding()]
    param()

    $Inventory = Get-M365LicenseInventory

    foreach ($License in $Inventory) {

        [PSCustomObject]@{

            License       = $License.DisplayName
            SkuPartNumber = $License.SkuPartNumber

            Assigned      = $License.Consumed
            Available     = $License.Available
            Total         = $License.Purchased

        }

    }

}