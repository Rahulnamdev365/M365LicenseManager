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