import Foundation

public enum FutureResult<T> {
    case success(T)
    case failure(Error)
}

public struct FutureChain {
    public static func create() -> Future<()> {
        return Future<()> { comp in
            comp(FutureResult.success(()))
        }
    }
}

public struct Future<T> {
    public typealias ResultType = FutureResult<T>
    public typealias Completion = (ResultType) -> ()
    public typealias Operation = (@escaping Completion) -> ()
    
    fileprivate let operation: Operation
    
    public init(_ operation: @escaping Operation) {
        self.operation = operation
    }
    
    public func done(_ completion: @escaping Completion) {
        start(completion)
    }
    
    fileprivate func start(_ completion: @escaping Completion) {
        operation { (result) in
            completion(result)
        }
    }
}

public extension Future {
    func then<U>(_ f: @escaping (T) -> Future<U>) -> Future<U> {
        return Future<U> { completion in
            self.start { (result) in
                switch result {
                case .success(let value):
                    f(value).start(completion)
                case .failure(let reason):
                    completion(FutureResult.failure(reason))
                }
            }
        }
    }
    
    func then<U>(_ f: @escaping (T) -> U) -> Future<U> {
        return Future<U> { completion in
            self.start { (result) in
                switch result {
                case .success(let value):
                    completion(FutureResult.success(f(value)))
                case .failure(let reason):
                    completion(FutureResult.failure(reason))
                }
            }
        }
    }
    
//    func wait<U>(timeout: TimeInterval) -> Future<U> {
//        return Future<U> { completion in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                completion(FutureResult.success(f))
//            }
//        }
//    }
}
