import SourceryRuntime
import Foundation

struct InjectAnnotation {
    let scope: String?
    let name: String?
    let type: String?

    init(scope: String?, name: String?, type: String?) {
        self.scope = scope
        self.name = name
        self.type = type
    }

    init(attributes: [String: Any]) {
        self.init(scope: attributes["scope"] as? String,
                name: attributes["name"] as? String,
                type: attributes["type"] as? String)
    }
}