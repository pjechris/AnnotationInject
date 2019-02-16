<%

func serviceScope(_ service: Type) -> String? {
  guard let injectAnnotation = service.annotations["inject"] as? [String: String] else {
    return nil
  }

  return injectAnnotation["scope"]
}

func attributesAnnotatedInject(_ service: Type) -> ([Variable], [String]) {
  let annotatedAttributes = service.instanceVariables.filter { has($0, annotation: "inject") }
  var attributes: [Variable] = []
  var errors: [String] = []

  for attribute in annotatedAttributes {
    guard attribute.typeName.isOptional else {
        errors.append("'\(attribute.name)' needs to be optional to be injected")
        continue
    }

    guard attribute.isMutable else {
      errors.append("'\(attribute.name)' needs to be mutable to be injected")
      continue
    }

    attributes.append(attribute)
  }

  return (attributes, errors)
}

-%>
