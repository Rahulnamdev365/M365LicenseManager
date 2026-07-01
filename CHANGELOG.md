# Changelog

All notable changes to this project will be documented in this file.

This project follows [Semantic Versioning](https://semver.org/).

---

## [0.4.0] - 2026-07-01

### Added
- Added New-M365LicenseReport cmdlet.
- Added Get-M365LicenseSummary helper.
- Added Get-M365LicenseStatistics helper.
- Added Get-M365LicenseUserData helper.
- Added Get-M365UnlicensedUsers helper.
- Added license utilization statistics.
- Added user and guest statistics.
- Added report metadata including module version and environment.

## [0.3.0] - 2026-06-30

### Added

#### Connectivity

- Added `Connect-M365License`
- Added `Test-M365Prerequisites`

#### License Inventory

- Added `Get-M365LicenseInventory`
- Added `Get-M365UserLicense`

#### License Management

- Added `Set-M365UserLicense`
- Added `Remove-M365UserLicense`
- Added `Copy-M365UserLicense`
- Added `Compare-M365UserLicense`

#### Features

- Microsoft Graph authentication
- Microsoft Graph prerequisite validation
- Friendly SKU catalog
- SKU resolution helper
- User resolution helper
- Direct and Group license detection
- Safe license assignment
- Duplicate license detection
- `-WhatIf` support
- `-Verbose` support
- `-Confirm` support
- `-PassThru` support
- Comment-based help for all public cmdlets

#### Documentation

- Professional README
- Updated module manifest
- Added comment-based help for all public cmdlets