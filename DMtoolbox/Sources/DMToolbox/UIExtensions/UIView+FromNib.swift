//
//  Copyright © 2016, Connected Travel, LLC – All Rights Reserved. 
//
//  All information contained herein is property of Connected Travel, LLC including, but 
//  not limited to, technical and intellectual concepts which may be embodied within. 
//
//  Dissemination or reproduction of this material is strictly forbidden unless prior written
//  permission, via license, is obtained from Connected Travel, LLC.   If permission is obtained,
//  this notice, and any other such legal notices, must remain unaltered.  
//

import UIKit

protocol UIViewFromNib: UIView {
    static func createFromNib() -> Self
}

extension UIViewFromNib {
    static func createFromNib() -> Self {
        let nibName = String(describing: Self.self)
        let nib = UINib(nibName: nibName, bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil).first as! Self

        return view
   }
}
