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