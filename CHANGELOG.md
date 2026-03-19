# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-03-20

### Added
- **First-Name Handle**: Implemented intelligent name extraction in `HomeHeader` to handle long usernames gracefully and prevent layout overflow.
- **Custom Category Pre-filling**: Added support for pre-filling the category name when editing transactions, improving the UX for custom labels.
- **Consolidated Theme System**: Unified the theme architecture into a single `lib/core/themes/` directory for better maintainability.

### Improved
- **Real-Time Profile Sync**: Resolved a critical delay issue in `UserSettingsProvider`. Changes made in theSettings screen now reflect instantly on the Home screen without requiring a manual refresh.
- **Data Isolation Fixes**: Enhanced the `DatabaseService` to ensure clean state transitions when signing out and switching between different Firebase accounts.
- **Gradle Stability**: Upgraded Android Gradle Plugin (AGP) to 8.9.1 for modern build support and improved build performance.

### Fixed
- **Home UI Regression**: Restored the `HomeHeader` layout to its clean, intended design (Name + Greeting only).
- **Redundant Components**: Removed unused theme files and legacy analytics widgets (`analytics_breakdown.dart`) to keep the codebase lean.
- **Background Sizing**: Fixed sizing logic in `AppBackground` to ensure full-screen coverage on both small and large devices.

## [1.0.0] - 2026-02-27

### Added
- **AI Financial Mentor**: Integrated Google Generative AI for personalized spending insights.
- **Haptic Feedback**: Added physical feedback for negative balance warnings and transaction actions.
- **Interactive Analytics**: Added FL Chart integration for spending trends.
- **Secure Authentication**: Implemented Firebase Auth sign-in and sign-up flows.
- **Custom Theme**: Created a premium glassmorphic dark theme.

### Changed
- **Refactored Architecture**: Moved business logic from UI screens to dedicated Providers.
- **Enhanced Profile Management**: Implemented inline name editing and professional photo picking.
- **UI Optimization**: Improved `InfoBox` responsiveness to handle large numerical amounts gracefully.

### Fixed
- **DatePicker Typo**: Renamed `CustomeDatePicker` to `CustomDatePicker` and synchronized all references.
- **Overflow Issues**: Resolved UI clipping in the balance card and info tiles.

---
*Initial Release*
