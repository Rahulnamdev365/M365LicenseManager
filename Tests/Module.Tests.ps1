BeforeAll {

    $ModuleRoot = Split-Path $PSScriptRoot -Parent

    Import-Module "$ModuleRoot\M365LicenseManager.psd1" -Force

}

Describe "M365LicenseManager Module" {

    It "Imports successfully" {

        Get-Module M365LicenseManager | Should -Not -BeNullOrEmpty

    }

    It "Has the correct version" {

        (Get-Module M365LicenseManager).Version.ToString() |
            Should -Be '0.3.0'

    }

    It "Exports Connect-M365License" {

        Get-Command Connect-M365License |
            Should -Not -BeNullOrEmpty

    }

    It "Exports Test-M365Prerequisites" {

        Get-Command Test-M365Prerequisites |
            Should -Not -BeNullOrEmpty

    }

    It "Exports Get-M365LicenseInventory" {

        Get-Command Get-M365LicenseInventory |
            Should -Not -BeNullOrEmpty

    }

    It "Exports Get-M365UserLicense" {

        Get-Command Get-M365UserLicense |
            Should -Not -BeNullOrEmpty

    }

    It "Exports Set-M365UserLicense" {

        Get-Command Set-M365UserLicense |
            Should -Not -BeNullOrEmpty

    }

    It "Exports Remove-M365UserLicense" {

        Get-Command Remove-M365UserLicense |
            Should -Not -BeNullOrEmpty

    }

    It "Exports Copy-M365UserLicense" {

        Get-Command Copy-M365UserLicense |
            Should -Not -BeNullOrEmpty

    }

    It "Exports Compare-M365UserLicense" {

        Get-Command Compare-M365UserLicense |
            Should -Not -BeNullOrEmpty

    }

}