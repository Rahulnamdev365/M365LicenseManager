<#
.SYNOPSIS
Retrieves Microsoft 365 license inventory for the tenant.

.DESCRIPTION
Retrieves all Microsoft 365 licenses available in the tenant, including
the friendly license name, SKU Part Number, SKU ID, consumed units,
available units, and total purchased units.

This cmdlet is useful for monitoring license consumption and identifying
available licenses before assigning them to users.

.EXAMPLE
Get-M365LicenseInventory

Retrieves the complete Microsoft 365 license inventory.

.EXAMPLE
Get-M365LicenseInventory |
    Format-Table

Displays the license inventory in a table.

.EXAMPLE
Get-M365LicenseInventory |
    Sort-Object ConsumedUnits -Descending

Displays licenses sorted by the number of assigned licenses.

.EXAMPLE
Get-M365LicenseInventory |
    Export-Csv .\LicenseInventory.csv -NoTypeInformation

Exports the tenant license inventory to a CSV file.

.INPUTS
None.

.OUTPUTS
System.Management.Automation.PSCustomObject

.NOTES
Author : Rahul Namdev
Module : M365LicenseManager
Version: 0.3.0
.LINK
https://github.com/Rahulnamdev365/M365LicenseManager 
#>

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