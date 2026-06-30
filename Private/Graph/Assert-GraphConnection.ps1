function Assert-GraphConnection {

    [CmdletBinding()]
    param()

    $Context = Get-MgContext

    if (-not $Context) {
        throw "Not connected to Microsoft Graph. Run Connect-M365License."
    }

}