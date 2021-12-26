import UIKit

class RefreshControlLoadingView: RefreshControlView {
    
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
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 2.0
        animation.repeatCount = Float.infinity
        animation.fromValue = 0.0
        animation.toValue = Double.pi * 2
        animation.isRemovedOnCompletion = false
        
        self.layer.add(animation, forKey: "rotation")
    }

    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            loadingSpinner.drawRays(number: loadingSpinner.numberOfRays, withRect: rect, inContext: context)
        }
    }
}
