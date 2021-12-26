import Foundation
import UIKit

public protocol IServiceLocator {
    func get<T>(type: T.Type, name: String) -> T
}


public extension IServiceLocator {
    func get<T>() -> T {
        return get(type: T.self, name: "")
    }
    
    func get<T>(name: String) -> T {
        return get(type: T.self, name: name)
    }
}


public protocol ILifetimeManager {
    var value: Any? { get set }
}


public struct TransientLifetimeManager : ILifetimeManager {
    public init() { }
    
    public var value: Any? {
        get { return nil }
        set {}
    }
}


public struct ContainerLifetimeManager : ILifetimeManager {
    public init() { }
    public var value: Any?
}


public protocol IServiceContainer {
    func set<T>(type: T.Type, manager: ILifetimeManager, name: String, factory: @escaping () -> T)
}


public extension IServiceContainer {
    func set<T>(manager: ILifetimeManager, factory: @escaping () -> T) {
        set(type: T.self, manager: manager, name: "", factory: factory)
    }
    
    func set<T>(type: T.Type, manager: ILifetimeManager, factory: @escaping () -> T) {
        set(type: type, manager: manager, name: "", factory: factory)
    }
}


public class ServiceContainer : IServiceLocator, IServiceContainer {
    private var services: [Key : ServiceContainerDescriptor] = [:]
    
    public init() { }
    
    public func get<T>(type: T.Type, name: String) -> T {
        assert(Thread.isMainThread)
        
        let key = Key(name: name, identifier: ObjectIdentifier(type))
        let descriptor = services[key]!
        if let value = descriptor.manager.value {
            return value as! T
        }
        let value = descriptor.factory()
        descriptor.manager.value = value
        return value as! T
    }
    
    public func set<T>(type: T.Type, manager: ILifetimeManager, name: String, factory: @escaping () -> T) {
        assert(Thread.isMainThread)

        let key = Key(name: name, identifier: ObjectIdentifier(type))
        services[key] = ServiceContainerDescriptor(manager: manager, factory: factory)
    }
    
    private final class ServiceContainerDescriptor {
        var manager: ILifetimeManager
        let factory: () -> Any
        
        
        init(manager: ILifetimeManager, factory: @escaping () -> Any) {
            self.manager = manager
            self.factory = factory
        }
    }
    
    private struct Key : Hashable {
        let name: String
        let identifier: ObjectIdentifier
        
        static func ==(left: Key, right: Key) -> Bool {
            return left.identifier == right.identifier && left.name == right.name
        }
    }
}

public final class ServiceLocator {
    private static var containerFactory: () -> IServiceLocator = { return ServiceContainer() }

    public static private(set) var current: IServiceLocator = containerFactory()
    
    public static func setContainerFactory( factory: @autoclosure @escaping () -> IServiceLocator) {
        containerFactory = factory
    }
}
