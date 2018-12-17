# Changelog

## 0.3.2
### Fixed
- Fixed generated code (for registering and resolving) when using `provider` annotation

### Added
- Added the ability to define imports using `args.imports`.

## 0.3.1
### Fixed
- Resolver not resolving to `type` option when defined.

## 0.3.0
### Added
- Register properties using `inject` annotation.
- Register specifying a type (like a protocol) than the class type using `type` option.
- Disable Swiftlint into generated files.
- Support for Cocoapods.
- Changelog file ;)

### Changed
- Collapse sections into README file to improve readability.

## 0.2
### Added
- `scope` option for `inject` annotation.
