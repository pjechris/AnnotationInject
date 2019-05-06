import SourceryRuntime

extension Array where Element: Annotated {
    func filter(annotated annotation: String) -> [Element] {
        return filter { $0.annotations[annotation] != nil }
    }
}