<%

func prefixNonEmpty(_ str: String, with prefix: String) -> String {
  return str.isEmpty ? "" : prefix + str
}

func indent(_ str: String, by spaces: Int) -> String {
  return String(repeating: "  ", count: spaces) + str
}

-%>
