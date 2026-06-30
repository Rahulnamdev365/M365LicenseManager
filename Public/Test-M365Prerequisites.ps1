Write-Host "Inside Test-M365Prerequisites.ps1"
function Test-M365Prerequisites {

    [CmdletBinding()]
    param(
        [switch]$Repair
    )

    $Results = @()

    $Results += Test-PowerShellVersion
    $Results += Test-GraphModules

    return $Results

}