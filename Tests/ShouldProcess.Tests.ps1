BeforeAll {

    $ModuleRoot = Split-Path $PSScriptRoot -Parent

    Import-Module "$ModuleRoot\M365LicenseManager.psd1" -Force

    $WriteCmdlets = @(
        'Set-M365UserLicense',
        'Remove-M365UserLicense',
        'Copy-M365UserLicense'
    )

}

Describe "SupportsShouldProcess" {

    It "<_> supports -WhatIf" -ForEach $WriteCmdlets {

        $Command = Get-Command $_

        $Command.Parameters.ContainsKey('WhatIf') |
            Should -BeTrue

    }

    It "<_> supports -Confirm" -ForEach $WriteCmdlets {

        $Command = Get-Command $_

        $Command.Parameters.ContainsKey('Confirm') |
            Should -BeTrue

    }

}