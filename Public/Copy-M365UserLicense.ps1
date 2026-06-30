<#
.SYNOPSIS
Copies directly assigned Microsoft 365 licenses from one user to another.

.DESCRIPTION
Retrieves all directly assigned Microsoft 365 licenses from a source user
and assigns them to a target user.

Group-based license assignments are not copied because they are managed
through Microsoft Entra ID group membership.

The cmdlet supports WhatIf, Confirm, Verbose, and PassThru.

.PARAMETER SourceUser
Specifies the User Principal Name (UPN) of the user whose directly
assigned licenses will be copied.

.PARAMETER TargetUser
Specifies the User Principal Name (UPN) of the user who will receive
the copied licenses.

.PARAMETER PassThru
Returns the updated license assignments for the target user after the
operation completes.

.EXAMPLE
Copy-M365UserLicense `
    -SourceUser source.user@contoso.com `
    -TargetUser target.user@contoso.com

Copies all directly assigned licenses from the source user to the target user.

.EXAMPLE
Copy-M365UserLicense `
    -SourceUser source.user@contoso.com `
    -TargetUser target.user@contoso.com `
    -WhatIf

Shows what would happen without making any changes.

.EXAMPLE
Copy-M365UserLicense `
    -SourceUser source.user@contoso.com `
    -TargetUser target.user@contoso.com `
    -Verbose

Displays detailed information during the copy operation.

.EXAMPLE
Copy-M365UserLicense `
    -SourceUser source.user@contoso.com `
    -TargetUser target.user@contoso.com `
    -PassThru

Copies the licenses and returns the target user's updated license assignments.

.INPUTS
None.

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

function Copy-M365UserLicense {

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param(

        [Parameter(Mandatory)]
        [Alias('Source')]
        [string]$SourceUser,

        [Parameter(Mandatory)]
        [Alias('Target')]
        [string]$TargetUser,

        [switch]$PassThru

    )

    begin {

        Assert-GraphConnection

    }

    process {

        Write-Verbose "Resolving source user..."
        $Source = Resolve-M365User -Identity $SourceUser

        Write-Verbose "Resolving target user..."
        $Target = Resolve-M365User -Identity $TargetUser

        Write-Verbose "Retrieving licenses from '$($Source.UserPrincipalName)'..."

        $SourceLicenses = Get-M365UserLicense `
            -User $Source.UserPrincipalName

        if (-not $SourceLicenses) {

            Write-Warning "Source user has no assigned licenses."

            return

        }

        # Copy only directly assigned licenses
        $DirectLicenses = $SourceLicenses |
            Where-Object { $_.AssignmentType -eq 'Direct' }

        $GroupLicenses = $SourceLicenses |
            Where-Object { $_.AssignmentType -eq 'Group' }

        if ($GroupLicenses.Count -gt 0) {

            Write-Verbose "Skipping $($GroupLicenses.Count) group-assigned license(s)."

        }

        if (-not $DirectLicenses) {

            Write-Warning "Source user has no directly assigned licenses to copy."

            return

        }

        $SkuPartNumbers = $DirectLicenses.SkuPartNumber

        Write-Verbose "Found $($SkuPartNumbers.Count) directly assigned license(s) to copy."

        Set-M365UserLicense `
            -User $Target.UserPrincipalName `
            -AddLicense $SkuPartNumbers `
            -PassThru:$PassThru `
            -Verbose:$VerbosePreference `
            -WhatIf:$WhatIfPreference

            Write-Verbose "Finished copying licenses from '$($Source.UserPrincipalName)' to '$($Target.UserPrincipalName)'."

    }

}