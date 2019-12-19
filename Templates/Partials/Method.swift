<%

/// - Returns: a String of method parameters with their values.
func parametersWithValue(_ params: [ServiceParameterValue]) -> [(label: String, value: String)] {

  return params.map {
    switch $0.value {
    case .runtime:
      return (label: $0.name, value: $0.name)  
    case .service(let service):
      return (label: $0.name, value: "resolver.\(service.functionName)()")
    }
  }
}

func concat(_ labelAndValue: [(label: String, value: String)]) -> String {
  return labelAndValue
  .map { "\($0.label): \($0.value)" }
  .joined(separator: ",")
}

-%>
