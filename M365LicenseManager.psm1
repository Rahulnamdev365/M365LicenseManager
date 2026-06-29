<#
.SYNOPSIS
    M365LicenseManager Module Loader
#>

# Import Private Functions
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

# Import Public Functions
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

Export-ModuleMember -Function $PublicFunctions.BaseName