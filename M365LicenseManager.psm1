Write-Host "=== Loading M365LicenseManager ===" -ForegroundColor Cyan

# Import Private Functions
Get-ChildItem "$PSScriptRoot\Private" -Filter *.ps1 | ForEach-Object {

    Write-Host "Loading Private: $($_.Name)" -ForegroundColor Yellow

    try {
        . $_.FullName
        Write-Host "  SUCCESS" -ForegroundColor Green
    }
    catch {
        Write-Host "  FAILED: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Import Public Functions
Get-ChildItem "$PSScriptRoot\Public" -Filter *.ps1 | ForEach-Object {

    Write-Host "Loading Public: $($_.Name)" -ForegroundColor Cyan

    try {
        . $_.FullName
        Write-Host "  SUCCESS" -ForegroundColor Green
    }
    catch {
        Write-Host "  FAILED: $($_.Exception.Message)" -ForegroundColor Red
    }
}

$Functions = Get-ChildItem "$PSScriptRoot\Public" -Filter *.ps1 |
    Select-Object -ExpandProperty BaseName

Write-Host "Exporting:" -ForegroundColor Magenta
$Functions | ForEach-Object { Write-Host " - $_" }

Export-ModuleMember -Function $Functions