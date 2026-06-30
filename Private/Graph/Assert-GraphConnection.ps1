function Assert-GraphConnection {

    $Context = Get-MgContext

    if (-not $Context) {
        throw "Not connected to Microsoft Graph. Run Connect-M365License."
    }

    return $Context
}