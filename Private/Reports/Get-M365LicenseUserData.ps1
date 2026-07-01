function Get-M365LicenseUserData {

    [CmdletBinding()]
    param()

    Write-Verbose "Retrieving Microsoft 365 users..."

    $Users = Get-MgUser `
        -All `
        -Property DisplayName,UserPrincipalName,AssignedLicenses,Department,AccountEnabled,UserType

    Write-Host "Users returned by Graph: $($Users.Count)" -ForegroundColor Cyan

    foreach ($User in $Users) {

        Write-Host "Processing $($User.UserPrincipalName)" -ForegroundColor Yellow

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