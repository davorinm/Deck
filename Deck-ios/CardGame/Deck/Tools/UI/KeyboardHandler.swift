import UIKit

class KeyboardHandler : NSObject, UIGestureRecognizerDelegate {
    
    var automaticallyDismissKeyboard: Bool = false  // If YES, keyboard is dismissed when background (scrollView) is tapped. Default value is NO.
    
    private let scrollView: UIScrollView
    
    private var dismissRecognizer: UITapGestureRecognizer!
    
    /**
     Initializes the object with default values.
     - parameter scrollView: scrollView The scroll view that holds the responders. This will be used to adjust positions when keyboard appears.
     */
    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
        
        self.dismissRecognizer = UITapGestureRecognizer()
        self.dismissRecognizer.cancelsTouchesInView = true
        
        super.init()
        
        self.dismissRecognizer.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        scrollView.removeGestureRecognizer(dismissRecognizer)
    }
    
    @objc private func onKeyboardWillShow(_ notification: Notification) {
        var keyboardHeight: CGFloat = 0
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardFrame.size.height
        }
        
        let animationDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
        
        if let responder = scrollView.findFirstResponder() {
            var contentInset = self.scrollView.contentInset
            contentInset.bottom = keyboardHeight
            
            let scrollViewContentHeight = scrollView.contentSize.height - keyboardHeight
            let verticalContentOffset = responder.frame.origin.y - scrollViewContentHeight
            
            UIView.animate(withDuration: animationDuration, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                self.scrollView.contentOffset.y = verticalContentOffset
                self.scrollView.contentInset = contentInset
            })
        }
        
        if automaticallyDismissKeyboard {
            scrollView.addGestureRecognizer(dismissRecognizer)
        }
    }
    
    @objc private func onKeyboardWillHide(_ notification: Notification) {
        let animationDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
        
        scrollView.removeGestureRecognizer(dismissRecognizer)
        
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = 0
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
            self.scrollView.contentInset = contentInset
        })
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        dismissKeyboard()
        return false // return false so touch is not handled by gesture recognizer and table view scrolling begins with this touch.
    }
    
    @objc func dismissKeyboard() {
        scrollView.superview?.endEditing(true)
    }
}
