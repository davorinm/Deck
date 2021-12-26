import Foundation

protocol AnyKeyAccessible {
    subscript (anyKeyPath keyPath: PartialKeyPath<Self>) -> Any? { get set }
}

extension AnyKeyAccessible {
    subscript (anyKeyPath keyPath: PartialKeyPath<Self>) -> Any? {
        get {
            switch keyPath {
            case let keyPath as KeyPath<Self, String>:
                return self[keyPath: keyPath]
            case let keyPath as KeyPath<Self, Double>:
                return self[keyPath: keyPath]
            case let keyPath as KeyPath<Self, Int>:
                return self[keyPath: keyPath]
            // More cases may be needed...
            default:
                return nil
            }
        }
        set {
            switch keyPath {
            case let keyPath as ReferenceWritableKeyPath<Self, String>:
                self[keyPath: keyPath] = newValue as! String
            case let keyPath as ReferenceWritableKeyPath<Self, Double>:
                self[keyPath: keyPath] = newValue as! Double
            case let keyPath as ReferenceWritableKeyPath<Self, Int>:
                self[keyPath: keyPath] = newValue as! Int
            // More cases may be needed...
            default:
                break
            }
        }
    }
}
