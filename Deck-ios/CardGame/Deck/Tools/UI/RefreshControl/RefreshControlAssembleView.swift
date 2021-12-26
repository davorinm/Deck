import UIKit

class RefreshControlAssembleView: RefreshControlView {
    
    private let loadingSpinner = RefreshControlSpinner()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepare()
    }
    
    private func prepare() {
        backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            let raysCount = Int(progress / (1.0 / CGFloat(loadingSpinner.numberOfRays)))
            loadingSpinner.drawRays(number: raysCount, withRect: rect, inContext: context)
        }
    }
}
