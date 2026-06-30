function Get-ModuleConfig {

    [CmdletBinding()]
    param()

    $ConfigPath = Join-Path $PSScriptRoot 'ModuleConfig.psd1'

    if (-not (Test-Path $ConfigPath)) {
        throw "Module configuration file not found: $ConfigPath"
    }

    Import-PowerShellDataFile -Path $ConfigPath
}