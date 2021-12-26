import UIKit

extension UIView {
    
    public func instantiateFromNib() {
        let view: UIView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first! as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        let views = ["view" : view]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: views))
    }
    
    public func expandToParent() {
        if let superview = self.superview {
            self.translatesAutoresizingMaskIntoConstraints = false
            let views = ["view" : self]
            superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: views))
            superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: views))
        }
    }
}
