<%

func has(_ model: Annotated, annotation: String) -> Bool {
  return model.annotations[annotation] != nil
}

func providers() -> [SourceryRuntime.Method] {
    return types.all
    .filter { has($0, annotation: "provider") }
    .flatMap { provider in provider.staticMethods }
    .filter { method in method.callName == "instantiate" }
}

func provider(for typeName: TypeName) -> SourceryRuntime.Method? {
  return providers().first { $0.returnTypeName == typeName }
}

-%>
