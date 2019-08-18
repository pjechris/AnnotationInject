<%

enum MethodParameterPrinting {
    case call
    case definition
}

func concatParamNames(of parameters: [MethodParameter]) -> String {
  return stringify(parameters: parameters, printing: .call)
}

func stringify(parameters: [MethodParameter], printing: MethodParameterPrinting) -> String {
    let mapping: (MethodParameter) -> String

    switch printing {
        case .call:
            mapping = { $0.name }
        case .definition:
            mapping = {
                "\($0.name): \($0.typeName)"
                + ($0.defaultValue.map { " = " + $0 } ?? "")
            }
    }

    return parameters
    .map(mapping)
    .joined(separator: ", ")
}

-%>
