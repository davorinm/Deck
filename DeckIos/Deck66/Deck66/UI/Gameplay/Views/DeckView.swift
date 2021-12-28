//
//  DeckView.swift
//  TestApp
//
//  Created by Davorin on 20/08/16.
//  Copyright © 2016 Davorin Mađarić. All rights reserved.
//

import UIKit

@IBDesignable class DeckView: UIView {    
    private var cardsView: UIView!
    private var stashView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // TODO make placeholder for cards stack and trump card
        // Update layout from Deck
        
        backgroundColor = UIColor.red.withAlphaComponent(0.5)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        backgroundColor = UIColor.blue
    }
    
    // MARK: - DeckProtocol
    
    func create(_ numberOfCards: Int, completion: @escaping (() -> Void)) {
        if numberOfCards >= 1 {
            let cardView = PlayingCardView()
            cardView.mode = .back
            cardView.height = UIScreen.main.bounds.height * 3/10
            cardView.frame.origin = CGPoint(x: 0, y: 0)
            
            addSubview(cardView)
        }
        
        if numberOfCards >= 2 {
            let cardView = PlayingCardView()
            cardView.mode = .back
            cardView.height = UIScreen.main.bounds.height * 3/10
            cardView.frame.origin = CGPoint(x: -2, y: -2)
            
            addSubview(cardView)
        }
        
        if numberOfCards >= 3 {
            let cardView = PlayingCardView()
            cardView.mode = .back
            cardView.height = UIScreen.main.bounds.height * 3/10
            cardView.frame.origin = CGPoint(x: -4, y: -4)
            
            addSubview(cardView)
        }
        
        if numberOfCards >= 5 {
            let cardView = PlayingCardView()
            cardView.mode = .back
            cardView.height = UIScreen.main.bounds.height * 3/10
            cardView.frame.origin = CGPoint(x: -6, y: -6)
            
            addSubview(cardView)
        }
        
        if numberOfCards >= 11 {
            let cardView = PlayingCardView()
            cardView.mode = .back
            cardView.height = UIScreen.main.bounds.height * 3/10
            cardView.frame.origin = CGPoint(x: -8, y: -8)
            
            addSubview(cardView)
        }
        
        completion()
    }
    
    func create(_ card: PlayingCard) {
        let cardView = PlayingCardView()
        cardView.playingCard = card
        cardView.mode = .back
        cardView.height = UIScreen.main.bounds.height * 3/10
        cardView.frame.origin = CGPoint(x: -4, y: -4)
        
        cardView.addDropShadow()
        // TODO: Check
        card.view = cardView
        addSubview(cardView)
        
        self.layoutIfNeeded()
    }
    
    func update(_ numberOfCards: Int) {
        // Remove card
        if numberOfCards == 5 {
            subviews.last?.removeFromSuperview()
            return
        } else if numberOfCards == 4 {
            subviews.last?.removeFromSuperview()
            return
        } else if numberOfCards == 3 {
            subviews.last?.removeFromSuperview()
            return
        } else if numberOfCards == 2 {
            subviews.last?.removeFromSuperview()
            return
        } else if numberOfCards == 1 {
            subviews.last?.removeFromSuperview()
            return
        }
    }
    
    func placeTrumpCard(_ cardView: PlayingCardView, completion: @escaping (() -> Void)) {
        if cardView.superview! != self {
            let fram = cardView.superview!.convert(cardView.center, to: self)
            self.addSubview(cardView)
            cardView.center = fram
            
            cardView.transform = CGAffineTransform.identity
        }
        
        let origSize = cardView.frame.size
        let origOrigin = CGPoint.zero
        
        UIView.animate(withDuration: 0.25, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            // Rotate first half
            cardView.frame = CGRect(x: cardView.frame.origin.x + origSize.width + 10, y: origOrigin.y, width: 0, height: origSize.height)
            
        }, completion: { (finished: Bool) in
                
            self.sendSubviewToBack(cardView)
            cardView.mode = .front
        
            UIView.animate(withDuration: 0.25, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                // Rotate second half
                cardView.frame = CGRect(x: cardView.frame.origin.x + 10, y: origOrigin.y, width: origSize.width, height: origSize.height)

            }, completion: { (finished: Bool) in
                
                UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
                    //Rotate flat
                    cardView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
                    
                }, completion: { (finished: Bool) in
                
                    UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
                        //Push back
                        // TODO push back
                        cardView.frame = cardView.frame.offsetBy(dx: -cardView.frame.width+40, dy: 0)
                        
                    }, completion: { (finished: Bool) in
                        self.sendSubviewToBack(cardView)
                        
                        completion()
                    })
                })
            })
        })
    }
}
