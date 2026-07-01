function Get-M365UnlicensedUsers {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [object[]]$UserData

    )

    Write-Verbose "Identifying unlicensed users..."

    $UserData |
    Where-Object {
        $_.IsInternal -and
        -not $_.Licensed
    }

}