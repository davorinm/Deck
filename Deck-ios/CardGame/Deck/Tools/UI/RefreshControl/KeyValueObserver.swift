import Foundation

private var ObservingContext = 0

class KeyValueObserver: NSObject {
    
    /// Object whose key paths are being observed.
    let observedObject: NSObject
    
    private var observedKeyPaths = [String]()
    
    /// When a key path changes, this is called to notify any interested object about the change.
    var observeCallback: ((_ keyPath: String?, _ change: [NSKeyValueChangeKey: AnyObject]?) -> ())?
    
    init(object: NSObject) {
        self.observedObject = object
        super.init()
    }
    
    // Autocoding dependacy
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopObservingAllKeyPaths()
    }
    
    /// Starts observing specified key paths using the context provided at initialization.
    ///
    /// - parameter keyPaths: An array of key paths to observe.
    /// - parameter options: A combination of NSKeyValueObservingOptions values that specifies what is included in observation notifications.
    func observeKeyPaths(keyPaths: [String], options: NSKeyValueObservingOptions = NSKeyValueObservingOptions()) {
        for keyPath in keyPaths {
            if observedKeyPaths.firstIndex(of: keyPath) == nil {
                observedObject.addObserver(self, forKeyPath: keyPath, options: options, context: &ObservingContext)
                observedKeyPaths.append(keyPath)
            }
        }
    }
    
    /// Stops observing specified key paths.
    ///
    /// - parameter keyPaths: An array of key paths for which observing should stop.
    func stopObservingKeyPaths(keyPaths: [String]) {
        for keyPath in keyPaths {
            if let index = observedKeyPaths.firstIndex(of: keyPath) {
                observedObject.removeObserver(self, forKeyPath: keyPath)
                observedKeyPaths.remove(at: index)
            }
        }
    }
    
    /// Stops observing all currently observed key paths.
    func stopObservingAllKeyPaths() {
        stopObservingKeyPaths(keyPaths: observedKeyPaths)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.observeCallback?(keyPath,change as [NSKeyValueChangeKey : AnyObject]?)
    }
}


