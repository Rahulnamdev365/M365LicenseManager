<#
.SYNOPSIS
Connects to Microsoft Graph for the M365LicenseManager module.

.DESCRIPTION
Establishes an authenticated Microsoft Graph session using the
permissions required by M365LicenseManager.

Before connecting, the cmdlet validates the local environment by
checking the required Microsoft Graph PowerShell modules and
PowerShell version. Existing connections are reused unless
-ForceReconnect is specified.

.PARAMETER ForceReconnect
Disconnects the current Microsoft Graph session and establishes
a new connection.

.EXAMPLE
Connect-M365License

Connects to Microsoft Graph using the required permissions.

.EXAMPLE
Connect-M365License -Verbose

Displays detailed information during the connection process.

.EXAMPLE
Connect-M365License -ForceReconnect

Disconnects the existing Microsoft Graph session and creates a
new authenticated session.

.INPUTS
None.

.OUTPUTS
None.

.NOTES
Author : Rahul Namdev
Module : M365LicenseManager
Version: 0.3.0

.LINK
https://github.com/Rahulnamdev365/M365LicenseManager 
#>

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