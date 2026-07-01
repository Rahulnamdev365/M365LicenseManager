function Get-M365LicenseUserData {

    [CmdletBinding()]
    param()

    Write-Verbose "Retrieving Microsoft 365 users..."

    $Users = Get-MgUser `
        -All `
        -Property DisplayName,UserPrincipalName,AssignedLicenses,Department,AccountEnabled,UserType

    
    foreach ($User in $Users) {

            [PSCustomObject]@{

            DisplayName       = $User.DisplayName
            UserPrincipalName = $User.UserPrincipalName
            Department        = $User.Department
            Enabled           = $User.AccountEnabled
            UserType          = $User.UserType
            IsGuest           = ($User.UserType -eq 'Guest')
            IsInternal        = ($User.UserType -eq 'Member')
            LicenseCount      = $User.AssignedLicenses.Count
            Licensed          = ($User.AssignedLicenses.Count -gt 0)

        }

    }

}