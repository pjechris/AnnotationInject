import SourceryRuntime

/// Information related to a service
struct Service {
    let factory: SourceryRuntime.Method
    /// type returned by the resolving method. Might be the same than `registerTypeName`
    let resolvedTypeName: String
    let scope: String?
    /// name of the service
    let name: String?

    /// type to use when registering the service
    var registerTypeName: String { factory.returnTypeName.name }

    /// name of the compile-time function returning this service
    var functionName: String {
        name.map { "serviceNamed\($0.capitalized)" }
        ?? "registeredService"
    }

    init(factory: SourceryRuntime.Method,
         resolvedTypeName: String? = nil,
         scope: String? = nil,
         name: String?) {
        self.factory = factory
        self.resolvedTypeName = resolvedTypeName ?? factory.returnTypeName.name
        self.name = name
        self.scope = scope
    }
}
