import Foundation

public class SynchronizedOperation {    
    private var queue = OperationQueue()
    
    init() {
        self.queue.maxConcurrentOperationCount = 1
    }
    
    func synchronized(block: @escaping () -> Void) {
        let operation = BlockOperation(block: block)
        queue.addOperation(operation)
        operation.waitUntilFinished()
    }
}
