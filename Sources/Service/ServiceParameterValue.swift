import SourceryRuntime

/// method parameter along its "value"
@dynamicMemberLookup
struct ServiceParameterValue {
    enum Value {
        /// parameter that need to be provided
        case runtime
        /// parameter whose value can be resolved using a service
        case service(Service)
    }

    let methodParameter: MethodParameter
    let value: Value

    var isRuntime: Bool {
        switch value {
            case .runtime:
                return true
            default:
                return false
        }
    }

    init(_ methodParameter: MethodParameter, value: Value) {
        self.methodParameter = methodParameter
        self.value = value
    }

    subscript<T>(dynamicMember keyPath: KeyPath<MethodParameter, T>) -> T {
        methodParameter[keyPath: keyPath]
    }
}

extension Array where Element == ServiceParameterValue {
    func runtimeParameters() -> [MethodParameter] {
        return filter { $0.isRuntime }.map { $0.methodParameter }
    }
}