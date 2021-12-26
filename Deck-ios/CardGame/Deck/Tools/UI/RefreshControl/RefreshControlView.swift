import UIKit

class RefreshControlView: UIView {
    
    var progress: CGFloat = 0.0 {
        didSet {
            if progress < 0.0 {
                progress = 0.0
            }
            if progress > 1.0 {
                progress = 1.0
            }
            
            self.setNeedsDisplay()
        }
    }
}
