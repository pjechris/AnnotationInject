import SourceryRuntime

class ServiceProvider {
    private let types: Types

    init(types: Types) {
        self.types = types
    }

    /// Find and return all services annotated with `inject` annotation
    func findAnnotatedServices() -> [Service] {
        return types.all
        .filter(annotated: "inject")
        .map { service in
            guard let initializer = service.initializers.filter(annotated: "inject").first ?? service.initializers.first else {
                fatalError("No init method found on `\(service.name)`. You need to declare one.")    
            }
            let annotation = InjectAnnotation(attributes: service.annotations["inject"] as? [String: Any] ?? [:])
            
            return Service(factory: initializer,
                            resolvedTypeName: annotation.type ?? initializer.returnTypeName.name,
                            parameters: [:],
                            scope: annotation.scope,
                            name: annotation.name)

                
        }
    }

    /// return all services found into annotated factories
    func findFactoryServices() -> [Service] {
        return types.all
        .filter(annotated: "provider")
        .flatMap { provider in provider.staticMethods }
        .filter { method in method.callName == "instantiate" }
        .map {
            Service(factory: $0,
                    resolvedTypeName: $0.returnTypeName.name,
                    parameters: [:],
                    scope: nil,
                    name: nil)
        }
    }
}