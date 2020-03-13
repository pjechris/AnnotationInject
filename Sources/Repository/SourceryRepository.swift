import SourceryRuntime

/// Work In Progress.
/// Abstract Sourcery API access.
class SourceryRepository {
    private let sourcery: Types

    init(types: Types) {
        self.sourcery = types
    }

    func findInjectServices() -> [(service: Service, initAttributes: [Attribute], attributes: [Attribute])] {
        sourcery.all
            .filter(annotated: "inject")
            .map { type in
                guard let initializer = type.initializers.filter(annotated: "inject").first ?? type.initializers.first else {
                    fatalError("No init method found on `\(type.name)`. You need to declare one.")
                }
                let annotation = InjectAnnotation(attributes: type.annotations["inject"] as? [String: Any] ?? [:])
                let initAttributes = initializer.parameters.map { $0.toAttribute() }
                let serviceAttributes = initializer.definedInType!.instanceVariables.filter(annotated: "inject").map { $0.toAttribute() }
                let service = Service(factory: initializer,
                                      resolvedTypeName: annotation.type,
                                      scope: annotation.scope,
                                      name: annotation.name)

                return (service: service, initAttributes: initAttributes, attributes: serviceAttributes)
        }
    }

    func findFactoryServices() -> [(service: Service, initAttributes: [Attribute], attributes: [Attribute])] {
        sourcery.all
            .filter(annotated: "provider")
            .flatMap { provider in provider.staticMethods }
            .filter { method in method.callName == "instantiate" }
            .map {
                let service = Service(factory: $0,
                        resolvedTypeName: $0.returnTypeName.name,
                        scope: nil,
                        name: nil)

                return (service: service,
                        initAttributes: $0.parameters.map { $0.toAttribute() },
                        attributes: [])
        }
    }

    func findServiceAttributes(for service: Service) -> [Variable] {
        service.factory.definedInType!.instanceVariables.filter(annotated: "inject")
    }
}
