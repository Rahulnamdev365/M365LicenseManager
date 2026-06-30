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