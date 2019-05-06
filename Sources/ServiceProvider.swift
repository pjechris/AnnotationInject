import SourceryRuntime

class ServiceProvider {
    /// Find and return all services annotated with `inject` annotation
    func findInjectedServices() -> [Service] {
        return types.all
        .filter(annotated: "inject")
        .map { service in
            // FIXME if no initializer is found
            let initializer = service.initializers.filter(annotated: "inject").first ?? service.initializers.first!
            let annotation = InjectAnnotation(attributes: service.annotations["inject"] as? [String: Any] ?? [:])
            
            return Service(factory: initializer,
                            registerTypeName: annotation.type ?? initializer.returnTypeName.name,
                            parameters: [:],
                            scope: annotation.scope,
                            name: annotation.name)

                
        }
    }

    func findFactoryServices() -> [Service] {
        return types.all
        .filter(annotated: "provider")
        .flatMap { provider in provider.staticMethods }
        .filter { method in method.callName == "instantiate" }
        .map {
            Service(factory: $0,
                    registerTypeName: $0.returnTypeName.name,
                    parameters: [:],
                    scope: nil,
                    name: nil)
        }
    }
}