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

        Write-Verbose "Already connected to Microsoft Graph."

        return

    }

    if ($ForceReconnect -and $Context) {

        Write-Verbose "Disconnecting existing Microsoft Graph session..."

        Disconnect-MgGraph

    }

    $Config = Get-ModuleConfig

    Write-Verbose "Connecting to Microsoft Graph..."

    try {

        $null = Connect-MgGraph `
            -Scopes $Config.RequiredGraphScopes `
            -ErrorAction Stop

    }
    catch {

        throw "Failed to connect to Microsoft Graph. $($_.Exception.Message)"

    }

    $Context = Get-MgContext

    if (-not $Context) {
        throw "Unable to establish Microsoft Graph connection."
    }

    Write-Verbose "Connected as $($Context.Account)"

}