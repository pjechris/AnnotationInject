# AnnotationInject
[![Build Status](https://app.bitrise.io/app/155e5b7a217bcedf/status.svg?token=_RO05oFS4f8CgnilnIf9kg&branch=master)](https://app.bitrise.io/app/155e5b7a217bcedf)
![Cocoapods](https://img.shields.io/static/v1?label=cocoapods&message=%E2%9C%93&color=24C28A&labelColor=444444)

Generate your dependency injections. Aimed for safety.

|                     | AnnotationInject
|---------------------|--------
| :statue_of_liberty: | Free you from manually registering your dependencies.
| ⚡                   | Spend **less time to configure** and more time to code!
| 🛡                  | **No more runtime crash** because dependency is not up-to-date. Everything is checked at **compile-time**.
| 👐                  | Based on open source tools you like as [Sourcery](https://github.com/krzysztofzablocki/Sourcery) and [Swinject](https://github.com/Swinject/Swinject).
| :book:              | 100% open source under the MIT license

- [What's the issue with injection?](#whats-the-issue-with-injection)
- [Usage](#usage)
- [Available annotations](#available-annotations)
- [Caveats](#caveats)

> Documentation for a specific release might slightly differ. If you have troubles please check the release doc first (by selecting the release in Github switch branches/tags).

## What's the issue with injection?
### Without annotations
Using a dependency injection library (say, Swinject) you need to **remember** to register your dependencies:

```swift
container.register(CoffeeMaker.self) { r in
  return CoffeeMaker(heater: r.resolve()!) // Trouble ahead, not sure Heater is in fact registered!
}

/// later in your code
let coffeeMaker = container.resolve(CoffeeMaker.self) // crash, missing Heater dependency!
```

Running this code we'll get a crash **at runtime**: we didn't register any `heater`, resulting in CoffeeMaker resolver to crash.

### With annotations

Annotations will generate your dependencies and make sure everything resolves at **compile time**.

```swift
/// sourcery: inject
class CoffeeMaker {
    init(heater: Heater) {

    }
}
```

This time we'll get a compile time error because we forgot to declare a `Heater` dependency. Houray!

## Usage

### 1. Annotate your dependencies
```
/// sourcery: inject
class CoffeeMaker {
  init(heater: Heater) { }
}

/// sourcery: inject
class Heater {
    init() { }
}
```

### 2. Add a build phase to generate dependencies
See [Installation](#installation) for more details.

If not all dependencies can be resolved, the build phase will fail, preventing your code from compiling succesfully.

### 3. Add generated files and use generated code

```
let resolver = Assembler([AnnotationAssembly()]).resolver

// `registeredService` is generated code. It is completely safe at compile time.
let coffeeMaker = resolver.registeredService() as CoffeeMaker
let heater = resolver.registeredService() as Heater
```

## Installation
> Note: AnnotationInject depends/relies on Sourcery for annotations declaration, and Swinject as dependency injecter.

- CocoaPods

Add `pod AnnotationInject` to your `Podfile` and a new `Build phases` to your project:
```shell
"$(PODS_ROOT)"/AnnotationInject/Scripts/annotationinject --sources <path to your sources> --output <path to output generated code> (--args imports=<MyLib1> -args imports=<MyLib2>>)
```

> Note: You can pass all `sourcery` command line options to `annotationinject` script.

- Manually

 1. Install [Swinject](https://github.com/Swinject/Swinject) and [Sourcery](https://github.com/krzysztofzablocki/Sourcery).

 2. Copy-paste Sources and Templates folders inside and add a new `Build phases` to your project:
```shell
sourcery --templates <path to copied templates> --sources <path to your sources> --output <path to output generated code> (--args imports=<MyLib1> -args imports=<MyLib2>>)
```

- Swift Package Manager

We do not officially support Swift Package Manager as it does not have resources handling yet.

## Available annotations

### `inject`
Registers a class into the dependency container.

```swift
/// sourcery: inject
class CoffeeMaker { }
```

<details>
  <summary>Generated code</summary>
  <p>

  ```swift
  container.register(CoffeeMaker.self) {
    return CoffeeMaker()
  }

  extension SafeDependencyResolver {
    func registeredService() -> CoffeeMaker {
      return resolve(CoffeeMaker.self)!
    }
  }
  ```

  </p>
</details>

<details>
  <summary>Options</summary>
  <p>
    <dl>
        <dt>name</dt>
        <dd>Define a name for the service. Generated method will use that name.</dd>
        <dt>scope</dt>
        <dd>See <a href="https://github.com/Swinject/Swinject/blob/master/Documentation/ObjectScopes.md">Swinject Object Scopes</a>
        </dd>
        <dt>type</dt>
        <dd>Defines the type on which the class is registered. Use it when you want to resolve against a protocol.
        </dd>
    </dl>

  </p>

  ```swift
  /// sourcery:inject: scope = "weak", type = "Maker", name = "Arabica"
  class CoffeeMaker: Maker { }
  ```
</details>

### `inject` (init)
Registers a specific init for injection. If annotation is not provided, first found is used.

> Note: Class still needs to be `inject` annotated.

```swift
// sourcery: inject
class CoffeeMaker {
  init(heater: Heater) { }

  // sourcery: inject
  convenience init() {
    self.init(heater: CoffeHeater())
  }
}
```

<details>
  <summary>Generated code</summary>
  <p>

  ```swift
  container.register(CoffeeMaker.self) {
    return CoffeeMaker()
  }

  extension SafeDependencyResolver {
    func registeredService() -> CoffeeMaker {
      return resolve(CoffeeMaker.self)!
    }
  }
  ```

  </p>
</details>

### `inject` (attribute)
Injects an attribute after init. Attribute requires to be marked as Optional (`?` or `!`).

 > Note: Class still needs to be `inject` annotated.

```swift
// sourcery: inject
class CoffeeMaker {
  /// sourcery: inject
  var heater: Heater!

  init() { }
}
```

<details>
  <summary>Generated code</summary>
  <p>

  ```swift
  container.register(CoffeeMaker.self) {
    return CoffeeMaker()
  }
  .initCompleted { service, resolver in
    service.heater = resolver.registeredService()
  }
  ```

  </p>
</details>

### `provider`
Uses a custom function to register your dependency. It is the same as implementing `container.register` manually while keeping safety.
Note that provided method **must** be called `instantiate`.

> Note: If you're providing 3rd party libraries (coming from Cocoapods for example), you will need to pass those imports to AnnotationInject using `args.imports MyLib,MyLib2,...` command line argument.

```swift
class CoffeeMaker {
  init(heater: Heater) { }
}

// sourcery: provider
class AppProvider {
  static func instantiate(resolver: SafeDependencyResolver) -> CoffeeMaker {
    return CoffeeMaker(heater: CoffeHeater())
  }
}
```

<details>
  <summary>Generated code</summary>
  <p>

  ```swift
  container.register(CoffeeMaker, factory: AppProvider.instantiate(resolver:))

  extension SafeDependencyResolver {
    func registeredService() -> CoffeeMaker {
      return resolve(CoffeeMaker.self)!
    }
  }
  ```

  </p>
</details>

### `provided` (no longer needed with 0.5.0)
Declares a parameter as argument to define into the resolver method. Work on init and provider methods.


## Caveats
_**Generated code does not compile because of missing imports**_

Set `--args imports=<MyLib1> -args imports=<MyLib2>>` so that generated code includes 3rd party libraries.

_**Foundation types (URLSession, NSNotificationCenter, ...) are empty (.self) in generated code**_

Sourcery is not yet able to find those types. As such they are seen as non existent. Workaround: Define the surrounded type inside a Provider and give it foundation types.

_**Pods/Sourcery/bin/Sourcery.app/Contents/MacOS/Sourcery: No such file or directory**_

You're probably using Sourcery as a Cocoapods dependency which unfortunately doesn't always work well. Workaround: Install Sourcery using Homebrew then add to the build step `SOURCERY_BINPATH=sourcery` as environment variable.

## License
This project is released under the MIT License. Please see the LICENSE file for details.
