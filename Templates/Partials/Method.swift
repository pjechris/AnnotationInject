<%

/// - Returns: a String of method parameters with their values.
/// Params value annotated "provided" is considered to be named as the param itself
func parametersWithValue(_ method: SourceryRuntime.Method) -> [(label: String, value: String)] {
  var paramsWithValue: [(label: String, value: String)] = []

  for param in method.parameters {
    let value = param.hasAnnotation("provided")
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
