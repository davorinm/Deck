import Foundation

final class WatchdogTimer {    
    private var pingTimer: Timer?
    private let threshold: TimeInterval
    private let watchdogFiredCallback: (() -> Void)
    
    public init(threshold: TimeInterval, callback: @escaping (() -> Void)) {
        self.threshold = threshold
        self.watchdogFiredCallback = callback
    }
    
    deinit {
        stop()
    }
    
    func reset() {
        pingTimer?.invalidate()
        pingTimer = nil
        pingTimer = Timer.scheduledTimer(withTimeInterval: threshold, repeats: false) { [unowned self] (timer) in            
            self.watchdogFiredCallback()
        }
    }
    
    private func stop() {
        pingTimer?.invalidate()
        pingTimer = nil
    }
}
