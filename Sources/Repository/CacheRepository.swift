
typealias CacheRepository = CacheStore<SourceryCacheKeys>

enum SourceryCacheKeys: Hashable {
    case service
    case factory
}

/// a very basic cache system
class CacheStore<Key: Hashable> {
    typealias Cache = Dictionary<Key, Any>

    private var store: Cache = [:]

    func find<T>(_ key: Key, default: () -> T) -> T {
        guard let value = store[key] as? T else {
            let value = `default`()

            store[key] = value

            return value
        }

        return value
    }
}
