function Get-SkuInfo {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$SkuPartNumber
    )

    $Catalog = Get-SkuCatalog

    if ($Catalog.ContainsKey($SkuPartNumber)) {
        return [PSCustomObject]$Catalog[$SkuPartNumber]
    }

    Write-Verbose "SKU '$SkuPartNumber' not found in catalog."

    return [PSCustomObject]@{
        DisplayName = $SkuPartNumber
        Known       = $false
    }

}