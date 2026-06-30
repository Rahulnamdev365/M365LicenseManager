function Get-ModuleConfig {

    [CmdletBinding()]
    param()

    if ($script:ModuleConfig) {
        return $script:ModuleConfig
    }

    $ConfigPath = Join-Path $PSScriptRoot 'ModuleConfig.psd1'

    if (-not (Test-Path $ConfigPath)) {
        throw "Configuration file not found: $ConfigPath"
    }

    $script:ModuleConfig = Import-PowerShellDataFile -Path $ConfigPath

    return $script:ModuleConfig
}