import SourceryRuntime

struct Service {
    let factory: Method
    let resolvedTypeName: String
    let parameters: [MethodParameter: Any]
    let scope: String?
    /// name of the service, if any
    let name: String?
}