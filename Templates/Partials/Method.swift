<%

func concat(_ labelAndValue: [(label: String, value: String)]) -> String {
  return labelAndValue
  .map { "\($0.label): \($0.value)" }
  .joined(separator: ", ")
}

-%>
