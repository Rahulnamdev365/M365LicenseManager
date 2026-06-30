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