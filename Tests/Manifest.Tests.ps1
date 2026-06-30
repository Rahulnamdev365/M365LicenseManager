BeforeAll {

    $ModuleRoot = Split-Path $PSScriptRoot -Parent

    $Manifest = Test-ModuleManifest "$ModuleRoot\M365LicenseManager.psd1"

}

Describe "Module Manifest" {

    It "Manifest is valid" {

        $Manifest | Should -Not -BeNullOrEmpty

    }

    It "Version is 0.3.0" {

        $Manifest.Version.ToString() |
            Should -Be "0.3.0"

    }

    It "Author is Rahul Namdev" {

        $Manifest.Author |
            Should -Be "Rahul Namdev"

    }

    It "Root module is correct" {

        $Manifest.RootModule |
            Should -Be "M365LicenseManager.psm1"

    }

}