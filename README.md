# AnnotationInject
Generate your dependency injections. Aimed for safety.

|                     | AnnotationInject
|---------------------|--------
| :statue_of_liberty: | Free you from manually registering your dependencies.
| ⚡                   | Spend **less time to configure** and more time to code!
| 🛡                  | **No more runtime crash** because dependency is not up-to-date. Everything is checked at **compile-time**.
| 👐                  | Based on open source tools you like as [Sourcery](https://github.com/krzysztofzablocki/Sourcery) and [Swinject](https://github.com/Swinject/Swinject).
| :book:              | 100% open source under the MIT license


# Why?
### Without annotations
Using a dependency injection library (say, Swinject) you need to **remember** to register your dependencies:

```swift
container.register(CoffeeMaker.self) { r in return CoffeeMaker(heater: r.resolve()!) }

/// later in your code
let coffeeMaker = container.resolve(CoffeeMaker.self) // trouble ahead!
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

This time we'll get a compile time error because we forgot to declare a Heater injection. Houray!

# Installation
> Note: AnnotationInject depends/relies on Sourcery for annotations declaration, and Swinject as dependency injecter.

- CocoaPods

TODO

- Manually

Just copy-paste templates inside a directory and a new `Build phases` inside your project:
```shell
sourcery --templates <path to copied templates> --sources <path to your sources> --output <path to output generated code>
```

# Usage / Annotations

## `inject`
Register a class into the dependency container.

```swift
/// sourcery: inject
class CoffeeMaker { }
```

```swift
/// Generated code (simplified)
container.register(CoffeeMaker) {
  return CoffeeMaker()
}

extension SafeDependencyResolver {
  func registeredService() -> CoffeeMaker {
    return resolve(CoffeeMaker.self)!
  }
}
```

<details>
  <summary>Options</summary>
  <p>
    <dl>
        <dt>scope</dt>
        <dd>See <a href="https://github.com/Swinject/Swinject/blob/master/Documentation/ObjectScopes.md">Swinject Object Scopes</a>
        </dd>
    </dl>

  </p>

  ```swift
  /// sourcery:inject: scope = "weak"
  class CoffeeMaker { }
  ```
</details>

## `inject` (init)
Registers a specific init for injection. When annotation is not provided, first found is used.


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

```swift
/// Generated code (simplified)
container.register(CoffeeMaker) {
  return CoffeeMaker()
}

extension SafeDependencyResolver {
  func registeredService() -> CoffeeMaker {
    return resolve(CoffeeMaker.self)!
  }
}
```

## `provider`
Uses a custom function to register your dependency. It is the same as implementing `container.register` manually while keeping safety.
Note that provided method **must** be called `instantiate`.

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

```swift
/// Generated code (simplified)
container.register(CoffeeMaker, factory: AppProvider.instantiate(resolver:))

extension SafeDependencyResolver {
  func registeredService() -> CoffeeMaker {
    return resolve(CoffeeMaker.self)!
  }
}

```

# License
This project is released under the MIT License. Please see the LICENSE file for details.
