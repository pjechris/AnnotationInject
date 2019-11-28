import SourceryRuntime

extension Array where Element: Annotated {
    func filter(annotated annotation: String) -> [Element] {
        return filter { $0.hasAnnotation(annotation) }
    }
}

extension Annotated {
    func hasAnnotation(_ annotation: String) -> Bool {
        return annotations[annotation] != nil
    }
}