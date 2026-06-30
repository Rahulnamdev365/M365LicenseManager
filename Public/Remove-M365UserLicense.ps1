<#
.SYNOPSIS
Removes one or more Microsoft 365 licenses from a user.

.DESCRIPTION
Removes one or more directly assigned Microsoft 365 licenses from a user.

This cmdlet is a wrapper around Set-M365UserLicense and supports
WhatIf, Confirm, Verbose, and PassThru.

.PARAMETER User
Specifies the User Principal Name (UPN) of the user.

.PARAMETER License
Specifies one or more Microsoft 365 SKU Part Numbers to remove.

.PARAMETER PassThru
Returns the updated license assignments after the operation completes.

.EXAMPLE
Remove-M365UserLicense `
    -User user@contoso.com `
    -License FLOW_FREE

Removes the Microsoft Flow Free license from the user.

.EXAMPLE
Remove-M365UserLicense `
    -User user@contoso.com `
    -License SPE_E5 `
    -WhatIf

Shows what would happen without making any changes.

.EXAMPLE
Remove-M365UserLicense `
    -User user@contoso.com `
    -License FLOW_FREE `
    -PassThru

Removes the license and returns the updated license assignments.

.INPUTS
System.String

.OUTPUTS
By default, this cmdlet does not return any output.

When -PassThru is specified, it returns the updated license assignments.

.NOTES
Author  : Rahul Namdev
Module  : M365LicenseManager
Version : 0.3.0

.LINK
https://github.com/Rahulnamdev365/M365LicenseManager
#>

function Remove-M365UserLicense {

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param(

        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('UserPrincipalName','UPN','Identity')]
        [string]$User,

        [Parameter(Mandatory)]
        [string[]]$License,

        [switch]$PassThru

    )

    process {

        Set-M365UserLicense `
            -User $User `
            -RemoveLicense $License `
            -PassThru:$PassThru `
            -WhatIf:$WhatIfPreference `
            -Confirm:$false `
            -Verbose:$VerbosePreference

    }

}