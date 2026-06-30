function Test-M365Prerequisites {

    [CmdletBinding()]
    param(
        [switch]$Repair
    )

    $Results = @()

    $Results += Test-PowerShellVersion
    $Results += Test-GraphModules
    $Results += Test-GraphConnection

    return $Results

}