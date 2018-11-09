# AnnotationInject
Generate your dependency injections. Aimed for safety.

|                     | AnnotationInject
|---------------------|--------
| :statue_of_liberty: | Free you from manually registering your dependencies.
| ⚡                   | Spend **less time to configure** and more time to code!
| 🛡                  | **No more runtime crash** because dependency is not up-to-date. Everything is checked at **compile-time**.
| 👐                  | Based on open source tools you like as [Sourcery](https://github.com/krzysztofzablocki/Sourcery) and [Swinject](https://github.com/Swinject/Swinject).
| :book:              | 100% open source under the MIT license


## Why?
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

## Installation
> Note: AnnotationInject depends/relies on Sourcery for annotations declaration, and Swinject as dependency injecter.

- CocoaPods

Add `pod AnnotationInject` to your `Podfile` and a new `Build phases` to your project:
```shell
"$(PODS_ROOT)"/AnnotationInject/Scripts/annotationinject --sources <path to your sources> --output <path to output generated code>
```

> Note: You can pass all `sourcery` command line options to `annotationinject` script.

- Manually

 1. Install [Swinject](https://github.com/Swinject/Swinject) and [Sourcery](https://github.com/krzysztofzablocki/Sourcery).

 2. Copy-paste templates inside a directory and add a new `Build phases` to your project:
```shell
sourcery --templates <path to copied templates> --sources <path to your sources> --output <path to output generated code>
```

## Usage / Annotations

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
        <dt>scope</dt>
        <dd>See <a href="https://github.com/Swinject/Swinject/blob/master/Documentation/ObjectScopes.md">Swinject Object Scopes</a>
        </dd>
        <dt>type</dt>
        <dd>Defines the type on which the class is registered. Use it when you want to resolve against a protocol.
        </dd>
    </dl>

  </p>

  ```swift
  /// sourcery:inject: scope = "weak", type = "Maker"
  class CoffeeMaker: Maker { }
  ```
</details>

### `inject` (init)
Registers a specific init for injection. If annotation is not provided, first found is used.

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

## License
This project is released under the MIT License. Please see the LICENSE file for details.
