<%

func providers() -> [SourceryRuntime.Method] {
    return types.all
    .filter { has($0, annotation: "provider") }
    .flatMap { provider in provider.staticMethods }
    .filter { method in method.callName == "instantiate" }
}

func provider(for service: MethodParameter) -> SourceryRuntime.Method? {
  return providers().first { $0.returnTypeName == service.typeName }
}

/// - Returns: a String of method parameters with their values.
/// Params value annotated "provided" is considered to be named as the param itself
func parametersWithValue(_ method: SourceryRuntime.Method) -> [(label: String, value: String)] {
  var paramsWithValue: [(label: String, value: String)] = []

  for param in method.parameters {
    let value = has(param, annotation: "provided")
    ? param.name
    : "resolver.registeredService()"

    paramsWithValue.append((
      label: param.argumentLabel ?? param.name,
      value: value
    ))
  }

  return paramsWithValue
}

func concat(_ labelAndValue: [(label: String, value: String)]) -> String {
  return labelAndValue
  .map { "\($0.label): \($0.value)" }
  .joined(separator: ",")
}

-%>
