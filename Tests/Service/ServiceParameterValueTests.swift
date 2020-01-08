import XCTest
import SourceryRuntime
import Quick
import Nimble
@testable import AnnotationInject

class ServiceParamaterValueTests: QuickSpec {
    override func spec() {
        describe(".parametersWithValue") {
            let methodParam = MethodParameter(argumentLabel: nil,
                                              name: "param",
                                              typeName: TypeName("String"))
            
            context("parameter is .runtime") {
                it("value is param name") {
                    expect(parametersWithValue([.init(methodParam, value: .runtime)])
                        .first?.value) == "param"
                }
            }

            context("parameter is .service") {
                let service = Service(factory: Method(name: "init"),
                                      resolvedTypeName: "Foo",
                                      parameters: [:],
                                      scope: nil,
                                      name: nil)

                it("value is service") {
                    expect(parametersWithValue([.init(methodParam, value: .service(service))])
                        .first?.value) == "resolver.registeredService()"
                }
            }
        }
    }
}
