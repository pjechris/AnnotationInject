import SourceryRuntime
import Foundation

class ServiceProvider {
    /// FIXME Remove state from provider class
    private let types: Types
    var annotationServices: [Service] = []
    var factoryServices: [Service] = []
    private var services: [Service] {
        return annotationServices + factoryServices
    }

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
                               resolvedTypeName: annotation.type,
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
                        scope: nil,
                        name: nil)
        }

        return factoryServices
    }

    /// Return service init parameter values
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

    /// Return services that need to be served (injected) to `service` variables/attributes
    func findInjectedServiceAttributes(for service: Service) throws -> [(variable: Variable, service: Service)] {
        let variables = service.factory.definedInType!.instanceVariables.filter(annotated: "inject")

        return try variables.map { variable in
            guard variable.isMutable else {
                throw NSError(domain: "'\(variable.name)' needs to be mutable to be injected", code: 0, userInfo: nil)
            }

            guard let service = services.first(where: { $0.registerTypeName == variable.typeName.name || $0.registerTypeName == variable.typeName.unwrappedTypeName }) else {
                throw NSError(domain: "No service found matching '\(variable.typeName.name)' type" , code: 0, userInfo: nil)
            }

            return (variable: variable, service: service)
        }
    }
}
