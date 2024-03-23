import Foundation

extension Array where Element: Hashable {
    public func unique<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return self.filter { element in
            let value = element[keyPath: keyPath]
            guard !seen.contains(value) else { return false }
            seen.insert(value)
            return true
        }
    }
}
