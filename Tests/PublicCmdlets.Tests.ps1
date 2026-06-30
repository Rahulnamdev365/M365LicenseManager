BeforeAll {

    $ModuleRoot = Split-Path $PSScriptRoot -Parent

    Import-Module "$ModuleRoot\M365LicenseManager.psd1" -Force

    $PublicCmdlets = @(
        'Connect-M365License',
        'Test-M365Prerequisites',
        'Get-M365LicenseInventory',
        'Get-M365UserLicense',
        'Set-M365UserLicense',
        'Remove-M365UserLicense',
        'Copy-M365UserLicense',
        'Compare-M365UserLicense'
    )

}

Describe "Public Cmdlets" {

    Context "Cmdlet Naming" {

        It "<_> uses an approved PowerShell verb" -ForEach $PublicCmdlets {

            $Verb = ($_ -split '-')[0]

            $Verb |
                Should -BeIn (Get-Verb).Verb

        }

    }

    Context "Comment-Based Help" {

        It "<_> has help documentation" -ForEach $PublicCmdlets {

            $Help = Get-Help $_ -ErrorAction SilentlyContinue

            $Help |
                Should -Not -BeNullOrEmpty

        }

    }

    Context "Cmdlet Export" {

        It "<_> is exported by the module" -ForEach $PublicCmdlets {

            Get-Command $_ |
                Should -Not -BeNullOrEmpty

        }

    }

}