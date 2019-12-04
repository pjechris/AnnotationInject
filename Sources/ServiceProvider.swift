import SourceryRuntime

class ServiceProvider {
    private let types: Types
    private var annotationServices: [Service] = []
    private var factoryServices: [Service] = []

    init(types: Types) {
        self.types = types
    }

    /// Find and return all services annotated with `inject` annotation
    func findAnnotatedServices() -> [Service] {
        guard annotationServices.isEmpty else {
            return annotationServices
        }

        annotationServices = types.all
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

        return annotationServices
    }

    /// return all services found into annotated factories
    func findFactoryServices() -> [Service] {
        guard factoryServices.isEmpty else {
            return factoryServices
        }

        factoryServices = types.all
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

        return factoryServices
    }

    func findParameterValues(for service: Service) -> [ServiceParameterValue] {
        service.factory.parameters.map { param in
            if let service = annotationServices.first(where: { param.typeName.name == $0.resolvedTypeName }) {
                return .init(param, value: .service(service))
            }

            if let service = factoryServices.first(where: { param.typeName.name == $0.resolvedTypeName }) {
                return .init(param, value: .service(service))
            }

            return .init(param, value: .runtime)
        }
    }
}
