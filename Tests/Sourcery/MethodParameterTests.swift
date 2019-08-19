import XCTest
import SourceryRuntime
import Quick
import Nimble
@testable import AnnotationInject

class MethodParameterTests: QuickSpec {
    override func spec() {
        describe("stringify") {
            context("printing == .definition") {
                
                context("parameter has default value") {
                    let parameters: [MethodParameter] = [
                        .init(argumentLabel: nil, name: "param", typeName: TypeName("String?"), defaultValue: #""Hello World""#)
                    ]

                    it("add default value in definition") {
                        expect(stringify(parameters: parameters, printing: .definition)) == #"param: String? = "Hello World""#
                    }
                }

                context("multiple parameters") {
                     let parameters: [MethodParameter] = [
                        .init(argumentLabel: nil, name: "param1", typeName: TypeName("String")),
                        .init(argumentLabel: nil, name: "param2", typeName: TypeName("Int"))
                    ]

                    it("concatenate parameters") {
                        expect(stringify(parameters: parameters, printing: .definition)) == "param1: String, param2: Int"
                    }
                }
            }
        }
    }
}