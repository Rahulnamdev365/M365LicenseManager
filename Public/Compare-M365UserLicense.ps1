<#
.SYNOPSIS
Compares Microsoft 365 license assignments between two users.

.DESCRIPTION
Compares the Microsoft 365 license assignments of two users and
identifies licenses that match, are missing, or are assigned only
to one of the users.

The cmdlet returns PowerShell objects that can be filtered,
sorted, exported, or further processed through the pipeline.

.PARAMETER ReferenceUser
Specifies the User Principal Name (UPN) of the reference user.

.PARAMETER DifferenceUser
Specifies the User Principal Name (UPN) of the user to compare
against the reference user.

.EXAMPLE
Compare-M365UserLicense `
    -ReferenceUser reference.user@contoso.com `
    -DifferenceUser difference.user@contoso.com

Compares the license assignments between two users.

.EXAMPLE
Compare-M365UserLicense `
    -ReferenceUser reference.user@contoso.com `
    -DifferenceUser difference.user@contoso.com |
    Where-Object Assignment -eq 'Missing'

Displays licenses that are assigned to the reference user but
missing from the comparison user.

.EXAMPLE
Compare-M365UserLicense `
    -ReferenceUser reference.user@contoso.com `
    -DifferenceUser difference.user@contoso.com |
    Where-Object Assignment -eq 'Extra'

Displays licenses assigned only to the comparison user.

.EXAMPLE
Compare-M365UserLicense `
    -ReferenceUser reference.user@contoso.com `
    -DifferenceUser difference.user@contoso.com |
    Export-Csv .\LicenseComparison.csv -NoTypeInformation

Exports the comparison results to a CSV file.

.INPUTS
None.

.OUTPUTS
System.Management.Automation.PSCustomObject

.NOTES
Author  : Rahul Namdev
Module  : M365LicenseManager
Version : 0.3.0

.LINK
https://github.com/Rahulnamdev365/M365LicenseManager
#>

function Compare-M365UserLicense {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [Alias('Reference')]
        [string]$ReferenceUser,

        [Parameter(Mandatory)]
        [Alias('Difference')]
        [string]$DifferenceUser

    )

    begin {

        Assert-GraphConnection

    }

    process {

        Write-Verbose "Resolving reference user..."
        $Reference = Resolve-M365User -Identity $ReferenceUser

        Write-Verbose "Resolving comparison user..."
        $Difference = Resolve-M365User -Identity $DifferenceUser

        Write-Verbose "Retrieving licenses..."

        $ReferenceLicenses = Get-M365UserLicense `
            -User $Reference.UserPrincipalName

        $DifferenceLicenses = Get-M365UserLicense `
            -User $Difference.UserPrincipalName

        $AllLicenses = @(
            $ReferenceLicenses.SkuPartNumber
            $DifferenceLicenses.SkuPartNumber
        ) | Sort-Object -Unique

        foreach ($Sku in $AllLicenses) {

            $ReferenceHas = $ReferenceLicenses.SkuPartNumber -contains $Sku
            $DifferenceHas = $DifferenceLicenses.SkuPartNumber -contains $Sku

            switch ("$ReferenceHas|$DifferenceHas") {

                "True|True"   { $Status = "Match" }
                "True|False"  { $Status = "Missing" }
                "False|True"  { $Status = "Extra" }

            }

            [PSCustomObject]@{

            ReferenceUser       = $Reference.UserPrincipalName
            DifferenceUser      = $Difference.UserPrincipalName

            License             = (Get-SkuInfo $Sku).DisplayName
            SkuPartNumber       = $Sku

            ReferenceAssigned   = $ReferenceHas
            DifferenceAssigned  = $DifferenceHas

            Assignment          = $Status

            }

        }

    }

}