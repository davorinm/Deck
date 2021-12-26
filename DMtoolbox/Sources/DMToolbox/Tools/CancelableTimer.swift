import Foundation

final class CancelableTimer {
    private var timer: Timer?
    
    public init(timeInterval: TimeInterval, repeats: Bool = false, callback: @escaping (() -> Void)) {
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: repeats) { (timer) in
            callback()
        }
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}
