function Get-SkuCatalog {

    [CmdletBinding()]
    param(
        [switch]$Refresh
    )

    if (-not $Refresh -and $script:SkuCatalog) {
        return $script:SkuCatalog
    }

    $CatalogPath = Join-Path $PSScriptRoot 'SkuCatalog.psd1'

    if (-not (Test-Path $CatalogPath)) {
        throw "SKU catalog not found: $CatalogPath"
    }

    $script:SkuCatalog = Import-PowerShellDataFile -Path $CatalogPath

    return $script:SkuCatalog
}