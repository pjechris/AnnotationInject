import SourceryRuntime

struct Service {
    let factory: SourceryRuntime.Method
    /// type returned by the resolving method. Might be the same than `registerTypeName`
    let resolvedTypeName: String
    let parameters: [MethodParameter: Any]
    let scope: String?
    /// name of the service
    let name: String?

    /// type to use when registering the service
    var registerTypeName: String { factory.returnTypeName.name }

    /// name of the compile-time function returning this service
    var functionName: String {
        "service"
        + (name.map { "Named\($0.capitalized)" } ?? "")
    }
}