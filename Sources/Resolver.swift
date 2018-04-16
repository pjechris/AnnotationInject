/// This protocol defines methods to load dependencies unsafely (no guarantee it's been actually registered)
public protocol UnsafeDependencyResolver {
  func resolve<T, U>(_ serviceType: T.Type, arguments: U) -> T
}

/// This protocol will gain (through source code generation) methods to access registered dependencies
public protocol SafeDependencyResolver: UnsafeDependencyResolver { }
