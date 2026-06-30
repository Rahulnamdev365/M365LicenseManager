function Get-GraphSkuCache {

    [CmdletBinding()]
    param()

    # Return cached data if available
    if ($script:GraphSkuCache) {
        return $script:GraphSkuCache
    }

    Assert-GraphConnection

    $Lookup = @{}

    foreach ($Sku in Get-MgSubscribedSku) {

        $Lookup[$Sku.SkuId.Guid] = [PSCustomObject]@{

            SkuId          = $Sku.SkuId.Guid
            SkuPartNumber  = $Sku.SkuPartNumber
            DisplayName    = $Sku.SkuPartNumber

            Purchased      = $Sku.PrepaidUnits.Enabled
            Consumed       = $Sku.ConsumedUnits

        }

    }

    $script:GraphSkuCache = $Lookup

    return $Lookup

}