# Changelog

## master

## 0.6.0

### Added
- Support for Swift Package Manager

## 0.5.0
### Added
- Pass default value parameters to `registeredService` method definition.
- Added `name` injection option to services. Generated method will be named `serviceNamed{Name}` instead of `registeredService`.

### Removed
- `provided` annotation is not needed anymore. AnnotationInject will lookup for services.
- Along with `provided` AnnotationInject no longer generate an error if a parameter service is not registered. It will be considered as a de-facto resolving parameter.

## 0.4.2
### Fixed
- Fixed compilation issues when using Cocoapods.
- Fixed a regression generating `#error` for registered services.
- Fixed a regression preventing code from compiling when `#error` messages were present.

## 0.4.1
### Fixed
- Fixed compilation error in `ServiceProvider`.

## 0.4.0
### Breaking changes
- Templates (register and resolver) are now written in Swift. Require Sourcery 0.16+.

### Changed
- Annotation `sourcery: provider` in `init` is not needed anymore.

### Fixed
- Fixed service resolving crash when using `type` inject option.

## 0.3.3
### Fixed
- Fixed issue with generic parameters not defined in register and registered. Note: This works only for providers.
- Fixed `import` when importing multiple dependencies

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
