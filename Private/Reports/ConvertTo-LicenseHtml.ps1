function ConvertTo-LicenseHtml {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [psobject]$Report

    )

    # ============================================================
    # Load Template
    # ============================================================

    $TemplatePath = Join-Path `
        -Path $PSScriptRoot `
        -ChildPath "..\..\Templates\LicenseReport.html"

    if (-not (Test-Path $TemplatePath)) {

        throw "HTML template not found: $TemplatePath"

    }

    # ============================================================
    # Load CSS
    # ============================================================

    $CssPath = Join-Path `
        -Path $PSScriptRoot `
        -ChildPath "..\..\Styles\Report.css"

    if (-not (Test-Path $CssPath)) {

        throw "CSS file not found: $CssPath"

    }

    $Html = Get-Content `
        -Path $TemplatePath `
        -Raw

    $Css = Get-Content `
        -Path $CssPath `
        -Raw

    # ============================================================
    # Embed CSS
    # ============================================================

    $Html = $Html.Replace(
        "{{CSS}}",
        $Css
    )

    # ============================================================
    # Tenant Information
    # ============================================================

    $Html = $Html.Replace(
        "{{GeneratedOn}}",
        $Report.GeneratedOn.ToString("yyyy-MM-dd HH:mm:ss")
    )

    $Html = $Html.Replace(
        "{{Account}}",
        $Report.Account
    )

    $Html = $Html.Replace(
        "{{TenantId}}",
        $Report.TenantId
    )

    $Html = $Html.Replace(
        "{{Environment}}",
        $Report.Environment
    )

    $Html = $Html.Replace(
        "{{ModuleVersion}}",
        $Report.ModuleVersion
    )

    # ============================================================
    # Executive Summary
    # ============================================================

    $Html = $Html.Replace(
        "{{TotalPurchased}}",
        "{0:N0}" -f $Report.Statistics.TotalPurchased
    )

    $Html = $Html.Replace(
        "{{AddOnPurchased}}",
        "{0:N0}" -f $Report.Statistics.AddOnPurchased
    )

    $Html = $Html.Replace(
        "{{TrialPurchased}}",
        "{0:N0}" -f $Report.Statistics.TrialPurchased
    )

    $Html = $Html.Replace(
        "{{FreePurchased}}",
        "{0:N0}" -f $Report.Statistics.FreePurchased
    )

    $Html = $Html.Replace(
        "{{CapacityPurchased}}",
        "{0:N0}" -f $Report.Statistics.CapacityPurchased
    )

    $Html = $Html.Replace(
        "{{LicenseUtilizationPercent}}",
        ("{0:N2}%" -f $Report.Statistics.LicenseUtilizationPercent)
    )

    # ============================================================
    # User Statistics
    # ============================================================

    $Html = $Html.Replace(
        "{{TotalUsers}}",
        "{0:N0}" -f $Report.Statistics.TotalUsers
    )

    $Html = $Html.Replace(
        "{{InternalUsers}}",
        "{0:N0}" -f $Report.Statistics.InternalUsers
    )

    $Html = $Html.Replace(
        "{{GuestUsers}}",
        "{0:N0}" -f $Report.Statistics.GuestUsers
    )

    $Html = $Html.Replace(
        "{{LicensedUsers}}",
        "{0:N0}" -f $Report.Statistics.LicensedUsers
    )

    $Html = $Html.Replace(
        "{{UnlicensedUsers}}",
        "{0:N0}" -f $Report.Statistics.UnlicensedUsers
    )

    $Html = $Html.Replace(
    "{{CommunicationPurchased}}",
    "{0:N0}" -f $Report.Statistics.CommunicationPurchased
    )

    # ============================================================
    # Executive Insights
    # (Placeholder for Phase 0.6)
    # ============================================================

    $Insights = ConvertTo-ExecutiveInsights `
    -Statistics $Report.Statistics

    $Html = $Html.Replace(
    "{{ExecutiveInsights}}",
    $Insights
    )

    # ============================================================
    # License Inventory
    # ============================================================

    $InventoryTable = ConvertTo-LicenseInventoryTable `
        -LicenseSummary $Report.Summary

    $Html = $Html.Replace(
        "{{LicenseInventoryTable}}",
        $InventoryTable
    )

    # ============================================================
    # Finished HTML
    # ============================================================

    return $Html

}