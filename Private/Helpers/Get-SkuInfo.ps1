function Get-SkuInfo {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$SkuPartNumber

    )

    $Catalog = Get-SkuCatalog

    if ($Catalog.ContainsKey($SkuPartNumber)) {

        return $Catalog[$SkuPartNumber]

    }

    return [PSCustomObject]@{

        DisplayName = $SkuPartNumber

    }

}