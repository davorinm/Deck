import UIKit

extension UIView {
    
    class func createFromNib(nibName: String, owner: Any, addTo: UIView) {
        let nib = UINib.init(nibName: nibName, bundle: nil)
        let view = nib.instantiate(withOwner: owner, options: nil).first as! UIView
        
        addTo.addSubview(view)
        view.pinTo(addTo)
    }
    
    func pinTo(_ view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0).isActive = true
    }
    
    func setRoundedClip() {
        let radius = min(frame.width, frame.height) / 2
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func findFirstResponder() -> UIView? {
        return UIView.findFirstResponderOfView(aView: self)
    }
    
    class func findFirstResponderOfView(aView: UIView) -> UIView? {
        if aView.isFirstResponder {
            return aView
        }
        else {
            for subView in aView.subviews {
                if let foundFirstResponder = findFirstResponderOfView(aView: subView) {
                    return foundFirstResponder
                }
            }
        }
        
        return nil
    }
}
