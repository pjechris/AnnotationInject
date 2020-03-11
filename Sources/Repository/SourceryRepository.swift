import SourceryRuntime

class SourceryRepository {
    private let sourcery: Types

    init(types: Types) {
        self.sourcery = types
    }

    func findInjectServices() -> [Service] {
        sourcery.all
            .filter(annotated: "inject")
            .map { service in
                guard let initializer = service.initializers.filter(annotated: "inject").first ?? service.initializers.first else {
                    fatalError("No init method found on `\(service.name)`. You need to declare one.")
                }
                let annotation = InjectAnnotation(attributes: service.annotations["inject"] as? [String: Any] ?? [:])

                return Service(factory: initializer,
                               resolvedTypeName: annotation.type,
                               scope: annotation.scope,
                               name: annotation.name)
        }
    }

    func findFactoryServices() -> [Service] {
        sourcery.all
            .filter(annotated: "provider")
            .flatMap { provider in provider.staticMethods }
            .filter { method in method.callName == "instantiate" }
            .map {
                Service(factory: $0,
                        resolvedTypeName: $0.returnTypeName.name,
                        scope: nil,
                        name: nil)
        }
    }

    func findServiceAttributes(for service: Service) -> [Variable] {
        service.factory.definedInType!.instanceVariables.filter(annotated: "inject")
    }
}
