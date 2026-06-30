function Resolve-M365Sku {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$Identity

    )

    $SubscribedSkus = Get-MgSubscribedSku

    # Match by SKU Part Number
    $Sku = $SubscribedSkus |
        Where-Object SkuPartNumber -eq $Identity

    if ($Sku) {
        return $Sku
    }

    # Match by GUID
    $Sku = $SubscribedSkus |
        Where-Object SkuId -eq $Identity

    if ($Sku) {
        return $Sku
    }

    # Match by Friendly Name
    foreach ($Item in $SubscribedSkus) {

        $Info = Get-SkuInfo -SkuPartNumber $Item.SkuPartNumber

        if ($Info.DisplayName -eq $Identity) {
            return $Item
        }

    }

    throw "License '$Identity' was not found."

}