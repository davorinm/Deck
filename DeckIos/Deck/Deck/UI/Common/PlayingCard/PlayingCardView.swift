//
//  PlayingCardView.swift
//  TestApp
//
//  Created by Davorin on 20/08/16.
//  Copyright © 2016 Davorin Mađarić. All rights reserved.
//

import UIKit

class PlayingCardView: UIImageView {
    enum Mode {
        case back
        case front
        case frontDisabled
        
        mutating func toggle() {
            switch self {
            case .back:
                self = .front
            case .front, .frontDisabled:
                self = .back
            }
        }
    }
    
    var playingCard: PlayingCard!
    var mode: Mode = .back {
        didSet {
            updateMode()
        }
    }
    var height: CGFloat = 0 {
        didSet {
            let widith: CGFloat = height / 1.4
            frame.size = CGSize(width: widith, height: height)
        }
    }    
    var selectionEnabled = true {
        didSet {
            if selectionEnabled {
                if mode == .frontDisabled {
                    mode = .front
                }
            } else {
                if mode == .front {
                    mode = .frontDisabled
                }
            }
        }
    }
    var marrige: Bool = false
    
    private func updateMode() {
        switch mode {
        case .back:
            isUserInteractionEnabled = false
            image = UIImage(named: "CardBack")
            alpha = 1
        case .front:
            isUserInteractionEnabled = true
            image = UIImage(named: playingCard!.image)
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 1
            })
        case .frontDisabled:
            isUserInteractionEnabled = false
            image = UIImage(named: playingCard!.image)
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0.3
            })
        }
    }
    
    func rotate() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: {
            
            self.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi / 2), 0.0, 1.0, 0.0);
            
        }) { (end) in
            
            self.mode.toggle()
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: {
                
                self.layer.transform = CATransform3DMakeRotation(0, 0.0, 1.0, 0.0);
                
            }) { (end) in
                
                print("AnimationEND")
                
            }
        }
    }
}
