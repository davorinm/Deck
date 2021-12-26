import UIKit

extension UITableView {    
    /// Registers cell nib with cell class
    func register<T: UITableViewCell>(cellType: T.Type) {
        let nibName = String(describing: cellType)
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forCellReuseIdentifier: nibName)
    }
    
    /// Dequeue cell with cell class
    func dequeueReusableCell<T: UITableViewCell>(cellType: T.Type, for indexPath: IndexPath) -> T {
        let nibName = String(describing: cellType)
        return self.dequeueReusableCell(withIdentifier: nibName, for: indexPath) as! T
    }
}
