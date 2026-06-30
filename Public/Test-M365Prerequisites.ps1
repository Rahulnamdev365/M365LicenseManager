<#
.SYNOPSIS
Validates the prerequisites required by M365LicenseManager.

.DESCRIPTION
Runs a series of checks to verify that the local environment is
ready to use M365LicenseManager.

The cmdlet validates the installed PowerShell version, required
Microsoft Graph PowerShell modules, and the current Microsoft
Graph connection status.

Use this cmdlet after installing the module or when troubleshooting
environment or connectivity issues.

.PARAMETER Repair
Reserved for future use.

.EXAMPLE
Test-M365Prerequisites

Runs all prerequisite checks.

.EXAMPLE
Test-M365Prerequisites |
    Format-Table

Displays the results in a table.

.EXAMPLE
Test-M365Prerequisites |
    Where-Object Status -eq 'FAIL'

Displays only failed prerequisite checks.

.EXAMPLE
Test-M365Prerequisites |
    Where-Object Status -ne 'PASS'

Displays all warnings and failed checks.

.INPUTS
None.

.OUTPUTS
System.Management.Automation.PSCustomObject

.NOTES
Author  : Rahul Namdev
Module  : M365LicenseManager
Version : 0.3.0

.LINK
https://github.com/Rahulnamdev365/M365LicenseManager
#>

function Test-M365Prerequisites {

    [CmdletBinding()]
    param(
        [switch]$Repair
    )

    $Results = @()

    $Results += Test-PowerShellVersion
    $Results += Test-GraphModules
    $Results += Test-GraphConnection

    return $Results

}