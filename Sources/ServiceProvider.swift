import SourceryRuntime
import Foundation

class ServiceProvider {
    private let sourcery: SourceryRepository
    private let cache: CacheRepository

    init(sourcery: SourceryRepository, cache: CacheRepository = CacheRepository()) {
        self.sourcery = sourcery
        self.cache = cache
    }

    /// Find and return all services annotated with `inject` annotation
    func findAnnotatedServices() -> [Service] {
        cache.find(.service, default: sourcery.findInjectServices)
            .map { $0.service }
    }

    /// return all services found into annotated factories
    func findFactoryServices() -> [Service] {
        cache.find(.factory, default: sourcery.findFactoryServices)
            .map { $0.service }
    }

    func findAllServices() -> [Service] {
        findAnnotatedServices() + findFactoryServices()
    }

    /// Return service init parameter values
    func findParameterValues(for service: Service) -> [ServiceParameterValue] {
        let services = findAllServices()

        return service.factory.parameters.map { param -> ServiceParameterValue in
            if let service = services.first(where: { param.typeName.name == $0.resolvedTypeName }) {
                return .init(param, value: .service(service))
            }

            return .init(param, value: .runtime)
        }
    }

    /// Return services that need to be served (injected) to `service` variables/attributes
    func findInjectedServiceAttributes(for service: Service) throws -> [(variable: Variable, service: Service)] {
        let services = findAllServices()
        let attributes = sourcery.findServiceAttributes(for: service)

        return try attributes.map { variable in
            guard let service = services.first(where: { $0.registerTypeName == variable.typeName.name || $0.registerTypeName == variable.typeName.unwrappedTypeName }) else {
                throw NSError(domain: "No service found matching '\(variable.typeName.name)' type" , code: 0, userInfo: nil)
            }

            return (variable: variable, service: service)
        }
    }
}
