function Get-M365UserLicense {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$User
    )

    Assert-GraphConnection

    try {

        $UserObject = Get-MgUser `
            -UserId $User `
            -Property AssignedLicenses,DisplayName,UserPrincipalName

        foreach ($License in $UserObject.AssignedLicenses) {

            $SkuInfo = Get-SkuInfo -SkuPartNumber $License.SkuId

            [PSCustomObject]@{

                DisplayName      = $UserObject.DisplayName
                UserPrincipalName = $UserObject.UserPrincipalName
                SkuId            = $License.SkuId
                License          = $SkuInfo.DisplayName

            }

        }

    }
    catch {

        throw $_

    }

}