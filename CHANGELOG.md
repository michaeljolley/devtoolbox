# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

---

## [1.0.0]

### Updated

- Changed the `gh` command to `github` in order to avoid conflicts with the GitHub CLI
- Moved CI/CD process to GitHub Actions
- Cleaned up repo to reflect updates in Code of Conduct, Contributing, etc.

### Deleted

- Removed the reload environment `reload` command
- Removed the `IsAdmin` command

## [0.6.2]

### Added

- Updated README to provide installation instructions from the repository
- Added GitHub Actions to provide maintenance of the repository

## [0.6.0]

### Fixed

- Fixed issue that prevented Docker & Docker-Compose commands from not being exported by the module

## [0.5.0]

### Changed

- Incrementing version

## [0.0.5]

### Changed

- Modified versioning schema

## [0.0.4]

### Added

- Converted repo into a PowerShell Module and renamed to devtoolbox
- Added `dc` alias for docker-compose functionality
- New `gh` command that launches browser to GitHub repo if the directory is a GitHub repo
- Tons :)

[Unreleased]: https://github.com/builders-club/devtools/compare/[1.0.0]...HEAD
[0.6.2]: https://github.com/builders-club/devtools/compare/[0.6.2]...[1.0.0]
[0.6.2]: https://github.com/builders-club/devtools/compare/[0.6.0]...[0.6.2]
[0.6.0]: https://github.com/builders-club/devtools/compare/[0.5.0]...[0.6.0]
[0.5.0]: https://github.com/builders-club/devtools/compare/[0.0.4]...[0.5.0]
[0.0.5]: https://github.com/builders-club/devtools/compare/[0.0.5]...[0.0.5]
[0.0.4]: https://github.com/builders-club/devtools/compare/4a9f707...[0.0.4]
