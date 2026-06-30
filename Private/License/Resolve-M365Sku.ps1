function Resolve-M365Sku {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Identity
    )

    $Skus = Get-MgSubscribedSku

    # Match by Part Number
    $Match = $Skus | Where-Object SkuPartNumber -eq $Identity

    if ($Match) {
        return $Match
    }

    # Match by GUID
    $Match = $Skus | Where-Object SkuId -eq $Identity

    if ($Match) {
        return $Match
    }

    # Match by friendly name
    foreach ($Sku in $Skus) {

        $Info = Get-SkuInfo -SkuPartNumber $Sku.SkuPartNumber

        if ($Info.DisplayName -eq $Identity) {
            return $Sku
        }

    }

    throw "License '$Identity' was not found."
}