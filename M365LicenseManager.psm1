<#
.SYNOPSIS
    M365LicenseManager Module Loader

.DESCRIPTION
    Loads all private and public functions contained within the module
    and exports all public functions.

.NOTES
    Author  : Rahul Namdev
    Version : 0.7.0
#>

# ============================================================
# Import Private Functions
# ============================================================

$PrivateFunctions = Get-ChildItem `
    -Path "$PSScriptRoot\Private" `
    -Filter *.ps1 `
    -Recurse `
    -ErrorAction Stop |
    Sort-Object FullName

foreach ($Function in $PrivateFunctions) {

    Write-Verbose "Loading Private Function: $($Function.Name)"

    . $Function.FullName

}

# ============================================================
# Import Public Functions
# ============================================================

$PublicFunctions = Get-ChildItem `
    -Path "$PSScriptRoot\Public" `
    -Filter *.ps1 `
    -Recurse `
    -ErrorAction Stop |
    Sort-Object FullName

foreach ($Function in $PublicFunctions) {

    Write-Verbose "Loading Public Function: $($Function.Name)"

    . $Function.FullName

}

# ============================================================
# Export Public Functions
# ============================================================

Export-ModuleMember -Function $PublicFunctions.BaseName