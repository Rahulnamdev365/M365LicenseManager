function Connect-M365License {

    [CmdletBinding()]
    param(
        [switch]$ForceReconnect
    )

    Write-Verbose "Running prerequisite checks..."

    $Prerequisites = Test-M365Prerequisites

    if ($Prerequisites.Status -contains 'FAIL') {
        throw "Prerequisite checks failed. Run Test-M365Prerequisites for details."
    }

    $Context = Get-MgContext

    if ($Context -and -not $ForceReconnect) {

        Write-Verbose "Already connected."

        return $Context

    }

    $Config = Get-ModuleConfig

    Write-Verbose "Connecting to Microsoft Graph..."

    Connect-MgGraph -Scopes $Config.RequiredGraphScopes

    $Context = Get-MgContext

    if ($null -eq $Context) {
        throw "Unable to establish Microsoft Graph connection."
    }

    return $Context

}