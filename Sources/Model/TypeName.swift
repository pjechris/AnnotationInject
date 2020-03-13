import Foundation

/// Represent a swift type. Similar to `Sourcery.TypeName`.
struct TypeName: ExpressibleByStringLiteral {
    static let void = TypeName("Void")

    typealias StringLiteralType = String

    let name: String
    let isOptional: Bool
    let isImplicitlyUnwrappedOptional: Bool

    init(stringLiteral value: Self.StringLiteralType) {
        self.init(value)
    }

    init(_ value: String) {
        let genericCharacters = CharacterSet().inserting(charactersIn: "<>")
        let components = value.components(separatedBy: genericCharacters)

        self.name = components.first != "Optional" ? components.first! : components[1]
        self.isOptional = components.last == "?" || components.first == "Optional"
        self.isImplicitlyUnwrappedOptional = components.last == "!"
    }
}

private extension CharacterSet {
    func inserting(charactersIn string: String) -> CharacterSet {
        var set = self
        set.insert(charactersIn: string)
        return set
    }
}
