function Set-M365UserLicense {

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

        [string[]]$AddLicense,

        [string[]]$RemoveLicense,

        [switch]$PassThru

    )

    begin {

        Assert-GraphConnection

    }

    process {

        # Resolve the user
        $ResolvedUser = Resolve-M365User -Identity $User
        Write-Verbose "Resolved user '$($ResolvedUser.UserPrincipalName)'."

        if (-not $AddLicense -and -not $RemoveLicense) {
            throw "Specify at least one of -AddLicense or -RemoveLicense."
        }

        # Get the user's current licenses
        Write-Verbose "Retrieving current license assignments..."
        $CurrentLicenses = Get-M365UserLicense -User $ResolvedUser.UserPrincipalName

        # Build licenses to add
        $AddLicenses = @()

        foreach ($License in $AddLicense) {

            $Sku = Resolve-M365Sku -Identity $License

            $AlreadyAssigned = $CurrentLicenses |
                Where-Object { $_.SkuPartNumber -eq $Sku.SkuPartNumber }

            if ($null -ne $AlreadyAssigned) {

                Write-Verbose "License '$($Sku.SkuPartNumber)' is already assigned. Skipping."

                continue

            }

            Write-Verbose "Queueing license '$($Sku.SkuPartNumber)' for assignment."

            $AddLicenses += @{
                SkuId = $Sku.SkuId
            }

        }

        # Build licenses to remove
        $RemoveLicenses = @()

        foreach ($License in $RemoveLicense) {

            $Sku = Resolve-M365Sku -Identity $License

            $AssignedLicense = $CurrentLicenses |
                Where-Object { $_.SkuPartNumber -eq $Sku.SkuPartNumber }

            if ($null -eq $AssignedLicense) {

                Write-Verbose "License '$($Sku.SkuPartNumber)' is not assigned. Skipping."

                continue

            }

            Write-Verbose "Queueing license '$($Sku.SkuPartNumber)' for removal."

            $RemoveLicenses += $Sku.SkuId

        }

        # Exit if there are no changes to make
        if (($AddLicenses.Count -eq 0) -and ($RemoveLicenses.Count -eq 0)) {

            Write-Verbose "No license changes are required. The user's assigned licenses already match the requested state."

            return

        }

        Write-Verbose "Prepared to add $($AddLicenses.Count) license(s) and remove $($RemoveLicenses.Count) license(s)."

        if ($PSCmdlet.ShouldProcess($ResolvedUser.UserPrincipalName, "Modify Microsoft 365 Licenses")) {

            Set-MgUserLicense `
                -UserId $ResolvedUser.Id `
                -AddLicenses $AddLicenses `
                -RemoveLicenses $RemoveLicenses `
                -ErrorAction Stop

            Write-Verbose "Successfully updated licenses for '$($ResolvedUser.UserPrincipalName)'."

            if ($PassThru) {

                Get-M365UserLicense -User $ResolvedUser.UserPrincipalName

            }

        }

    }

}