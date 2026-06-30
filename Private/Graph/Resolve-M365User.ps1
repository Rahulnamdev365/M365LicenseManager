function Resolve-M365User {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$Identity

    )

    try {

        Get-MgUser `
            -UserId $Identity `
            -Property Id,DisplayName,UserPrincipalName `
            -ErrorAction Stop

    }
    catch {

        throw "User '$Identity' was not found."

    }

}