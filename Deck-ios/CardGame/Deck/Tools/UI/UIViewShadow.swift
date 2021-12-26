//
//  UIViewShadow.swift
//  CardGame
//
//  Created by Davorin on 25/08/16.
//  Copyright © 2016 DavorinMadaric. All rights reserved.
//

import UIKit

extension UIView {
    
    func addDropShadow() {
        layer.masksToBounds =  false
        layer.shadowColor = UIColor.darkGray.cgColor;
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowOpacity = 1.0
        
        // TODO: Optimize https://stackoverflow.com/a/64359313
//        layer.shadowPath = UIBezierPath(rect: bounds).CGPath
        
//        layer.shouldRasterize = true
//        
//        layer.masksToBounds = false
    }
    
    func liftShadow() {
        if layer.shadowOpacity > 0 {
            layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        }
    }
    
    func resetShadow() {
        if layer.shadowOpacity > 0 {
            layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        }
    }
}
