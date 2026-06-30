function Get-M365LicenseInventory {

    [CmdletBinding()]
    param(

        [string]$Sku,

        [switch]$AvailableOnly

    )

    Assert-GraphConnection

    $Licenses = Get-MgSubscribedSku

    $Output = foreach ($License in $Licenses) {

        if ($Sku -and $License.SkuPartNumber -ne $Sku) {
            continue
        }

        $Purchased = $License.PrepaidUnits.Enabled
        $Consumed  = $License.ConsumedUnits
        $Available = $Purchased - $Consumed

        if ($AvailableOnly -and $Available -le 0) {
            continue
        }

        $SkuInfo = Get-SkuInfo -SkuPartNumber $License.SkuPartNumber

        [PSCustomObject]@{

            DisplayName   = $SkuInfo.DisplayName

            SkuPartNumber = $License.SkuPartNumber

            SkuId         = $License.SkuId

            Purchased     = $Purchased

            Consumed      = $Consumed

            Available     = $Available

            Warning       = $License.PrepaidUnits.Warning

            Suspended     = $License.PrepaidUnits.Suspended

        }

    }

    return $Output | Sort-Object DisplayName

}