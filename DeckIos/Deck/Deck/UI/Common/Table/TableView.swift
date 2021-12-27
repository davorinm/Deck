//
//  TableView.swift
//  CardGame
//
//  Created by Davorin on 01/03/17.
//  Copyright © 2017 DavorinMadaric. All rights reserved.
//

import UIKit
import DeckCommon

class TableView: GradientView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        mode = .radial
        colors = [UIColor.white.withAlphaComponent(0.2), UIColor.white.withAlphaComponent(0)]
        
        backgroundColor = UIColor(patternImage: UIImage(named: "grass-free-texture")!)
    }
    
    func addCard(_ cardView: PlayingCardView, _ playerPosition: PlayerPosition, completion: @escaping (() -> Void)) {
        let fram = cardView.superview!.convert(cardView.center, to: self)
        self.addSubview(cardView)
        cardView.center = fram
        
        cardView.mode = .front
        
        let cardPlaceholder: CGPoint
        switch playerPosition {
        case .first:
            cardPlaceholder = CGPoint(x: self.center.x - 10, y: self.center.y + 30)
        case .second:
            cardPlaceholder = CGPoint(x: self.center.x + 10, y: self.center.y - 30)
        case .third:
            cardPlaceholder = CGPoint(x: self.center.x + 30, y: self.center.y + 10)
        case .fourth:
            cardPlaceholder = CGPoint(x: self.center.x - 30, y: self.center.y - 10)
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            cardView.center = cardPlaceholder
            cardView.transform = CGAffineTransform.identity
        }, completion: { (finish) in
            completion()
        }) 
    }
}
