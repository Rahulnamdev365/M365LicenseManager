@{

    MinimumPowerShellVersion = '7.2'

    RequiredGraphModules = @(
        'Microsoft.Graph.Authentication'
        'Microsoft.Graph.Users'
        'Microsoft.Graph.Groups'
        'Microsoft.Graph.Identity.DirectoryManagement'
    )

    RequiredGraphScopes = @(
        'User.Read.All'
        'Directory.Read.All'
        'Directory.ReadWrite.All'
        'Group.ReadWrite.All'
        'Organization.Read.All'
    )

    LogFolder = 'Logs'

    ReportFolder = 'Reports'

}