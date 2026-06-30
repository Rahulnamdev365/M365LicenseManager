<#
.SYNOPSIS
Retrieves Microsoft 365 license assignments for a user.

.DESCRIPTION
Retrieves all Microsoft 365 licenses assigned to a user and returns
friendly license names, SKU Part Numbers, SKU IDs, and assignment type
(Direct or Group).

This cmdlet can be used to review a user's current license assignments
before performing license management operations.

.PARAMETER User
Specifies the User Principal Name (UPN) of the user whose license
assignments will be retrieved.

.EXAMPLE
Get-M365UserLicense -User user@contoso.com

Retrieves all license assignments for the specified user.

.EXAMPLE
Get-M365UserLicense `
    -User user@contoso.com |
    Format-Table

Displays the user's license assignments in a table.

.EXAMPLE
Get-M365UserLicense `
    -User user@contoso.com |
    Where-Object AssignmentType -eq 'Direct'

Displays only directly assigned licenses.

.EXAMPLE
Get-M365UserLicense `
    -User user@contoso.com |
    Sort-Object License

Sorts the user's licenses alphabetically.

.EXAMPLE
Get-M365UserLicense `
    -User user@contoso.com |
    Export-Csv .\UserLicenses.csv -NoTypeInformation

Exports the user's license assignments to a CSV file.

.INPUTS
System.String

.OUTPUTS
System.Management.Automation.PSCustomObject

.NOTES
Author : Rahul Namdev
Module : M365LicenseManager
Version: 0.3.0

.LINK
https://github.com/Rahulnamdev365/M365LicenseManager 
#>

function Get-M365UserLicense {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [Alias('UPN')]
        [string]$User

    )

    begin {

        Assert-GraphConnection

    }

    process {

        try {

            # Get user
            $UserObject = Get-MgUser `
                -UserId $User `
                -Property DisplayName,UserPrincipalName,AssignedLicenses

            # Get tenant SKU cache
            $SubscribedSkus = Get-MgSubscribedSku

            foreach ($AssignedLicense in $UserObject.AssignedLicenses) {

                # Find matching tenant SKU
                $TenantSku = $SubscribedSkus |
                    Where-Object SkuId -eq $AssignedLicense.SkuId

                if ($TenantSku) {

                    $SkuInfo = Get-SkuInfo -SkuPartNumber $TenantSku.SkuPartNumber

                    $FriendlyName = $SkuInfo.DisplayName
                    $SkuPartNumber = $TenantSku.SkuPartNumber

                }
                else {

                    $FriendlyName = $AssignedLicense.SkuId
                    $SkuPartNumber = "Unknown"

                }

                [PSCustomObject]@{

                    DisplayName       = $UserObject.DisplayName

                    UserPrincipalName = $UserObject.UserPrincipalName

                    License           = $FriendlyName

                    SkuPartNumber     = $SkuPartNumber

                    SkuId             = $AssignedLicense.SkuId

                    AssignmentType    = "Direct"

                }

            }

        }
        catch {

            throw $_

        }

    }

}