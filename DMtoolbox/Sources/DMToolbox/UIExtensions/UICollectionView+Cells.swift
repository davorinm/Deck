import UIKit

extension UICollectionView {    
    /// Registers cell nib with cell class
    func register<T: UICollectionViewCell>(cellType: T.Type) {
        let nibName = String(describing: cellType)
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: nibName)
    }
    
    /// Dequeue cell with cell class
    func dequeueReusableCell<T: UICollectionViewCell>(cellType: T.Type, for indexPath: IndexPath) -> T {
        let nibName = String(describing: cellType)
        return self.dequeueReusableCell(withReuseIdentifier: nibName, for: indexPath) as! T
    }
}
