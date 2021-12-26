//
//  UIViewController+Embed.swift
//  CardGame
//
//  Created by Davorin Madaric on 22/11/2021.
//  Copyright © 2021 Davorin Madaric. All rights reserved.
//

import UIKit

extension UIViewController {

    func embed(container: UIView, child: UIViewController, removeChildren: Bool = true) {
        if removeChildren {
            for child in self.children {
                removeFromParent(vc: child)
            }
        }
        
        child.willMove(toParent: self)
        self.addChild(child)
        container.addSubview(child.view)
        child.didMove(toParent: self)
        let w = container.frame.size.width;
        let h = container.frame.size.height;
        child.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
    }

    func removeFromParent(vc: UIViewController) {
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
}
