function Test-GraphModules {

    [CmdletBinding()]
    param()

    $Config = Get-ModuleConfig

    foreach ($Module in $Config.RequiredGraphModules) {

        $InstalledModule = Get-Module `
            -ListAvailable `
            -Name $Module |
            Sort-Object Version -Descending |
            Select-Object -First 1

        if ($InstalledModule) {

            New-CheckResult `
                -Check $Module `
                -Status PASS `
                -Category Graph `
                -Severity Low `
                -Details "Version $($InstalledModule.Version) installed."

        }
        else {

            New-CheckResult `
                -Check $Module `
                -Status FAIL `
                -Category Graph `
                -Severity High `
                -Details "Module not installed." `
                -Recommendation "Install-Module $Module"

        }

    }

}