//
//  PlayerView.swift
//  TestApp
//
//  Created by Davorin on 20/08/16.
//  Copyright © 2016 Davorin Mađarić. All rights reserved.
//

import UIKit
import DMToolbox
import DeckCommon
import DeckGame

enum PlayerOrientation: Int {
    case top
    case bottom
    case left
    case right
    case topLeft
    case topRight
}

class PlayerView: UIView {
    private var cardsView: UIView!
    private var stashView: UIView!
    private var countLabel: UILabel?
    
    var orientation: PlayerOrientation = .bottom {
        didSet {
            switch orientation {
            case .bottom:
                transform = CGAffineTransform(rotationAngle: 0)
            case .left:
                transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
            case .top:
                transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            case .right:
                transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2 * 3))
            case .topLeft:
                transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi - (Double.pi / 5)))
            case .topRight:
                transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi + (Double.pi / 5)))
            }
        }
    }
    private var onMove: Bool = false
    
    private var marrigeButtons: [UIButton] = []
    private var playMarrigeSelected: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // TODO: Remove
        self.backgroundColor = .green.withAlphaComponent(0.3)

        cardsView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        var views: [String: AnyObject] = ["cardsView": cardsView]
        self.addSubview(cardsView)
        cardsView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cardsView]-0-|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[cardsView]-0-|", options: [], metrics: nil, views: views))
        
        stashView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        stashView.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        
        views = ["stashView": stashView]
        self.addSubview(stashView)
        stashView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[stashView]-(-20)-|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[stashView(50)]-0-|", options: [], metrics: nil, views: views))
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        backgroundColor = UIColor.red.withAlphaComponent(0.5)
    }
    
    // MARK: -
    
    private weak var player: Player!
    
    func setPlayer(_ player: Player) {
        // TODO: Remove, make connection different
        self.player = player
        setupPlayer()
    }
    
    private func setupPlayer() {
        if player != nil {
            let countLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            countLabel.text = "0"
            
            let views: [String: AnyObject] = ["countLabel": countLabel, "stashView": stashView]
            self.addSubview(countLabel)
            countLabel.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[countLabel(20)]-0-[stashView]", options: [], metrics: nil, views: views))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[countLabel(50)]-0-|", options: [], metrics: nil, views: views))
            
            self.countLabel = countLabel
        }
    }
    
    // MARK: - Add PlayingCard
    
    func addCard(_ completion: @escaping (() -> Void)) {
        let cardViews = player.playersCards.compactMap { (card: Card) -> PlayingCardView? in
            return card.view
        }
        
        let notAddedViews = cardViews.filter { (cardView: PlayingCardView) -> Bool in
            return cardView.superview != cardsView
        }
        
        let cardView = notAddedViews.first!
        
        if player != nil {
            cardView.mode = .front
        }
    
        let fram = cardView.superview!.convert(cardView.center, to: cardsView)
        cardsView.addSubview(cardView)
        cardView.center = fram
        
        // Sort card as are in player.playersCards
        for cardView in cardViews {
            cardsView.bringSubviewToFront(cardView)
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutCardsIfNeeded()
        }, completion: { (finish) in
            completion()
        })
    }
    
    func markOnMove(_ onMove: Bool) {
        self.onMove = onMove
        
        if onMove {
            backgroundColor = UIColor.red.withAlphaComponent(0.4)
        } else {
            backgroundColor = UIColor.clear
        }
        
        self.isUserInteractionEnabled = onMove
        
        removeMarrigeButtons()
        
        if onMove {
            
            // Marrige
            let cardViews = player.playersCards.compactMap { (card: PlayingCard) -> PlayingCardView? in
                return card.view
            }
            
            var marrigeFlag = false
            
            for (i, cardView) in cardViews.enumerated() {
                
                if cardView.marrige {
                    
                    if marrigeFlag {
                        marrigeFlag = false
                        
                        let previousCardMarrige = cardViews[i-1]
                        if previousCardMarrige.marrige == true {
                            
                            let firstCardCenter = previousCardMarrige.center
                            let secondCardCenter = cardView.center
                            
                            let xPos = secondCardCenter.x - (secondCardCenter.x - firstCardCenter.x) / 2
                            let yPos = self.frame.height / 2 + 10
                            
                            var marrigeBtnTitle = "20"                            
                            if cardView.playingCard.card.color == player.trumpColor?() {
                                marrigeBtnTitle = "40"
                            }
                            
                            let marrigeBtn = UIButton(frame: CGRect(x: xPos - 25, y: yPos - 25, width: 50, height: 50))
                            marrigeBtn.setRoundedClip()
                            marrigeBtn.setTitle(marrigeBtnTitle, for: UIControl.State.normal)
                            marrigeBtn.setTitleColor(UIColor(red:0.98, green:0.94, blue:0.27, alpha:1.0), for: .normal)
                            marrigeBtn.backgroundColor = UIColor(red:0.90, green:0.33, blue:0.33, alpha:1.0)
                            marrigeBtn.layer.borderColor = UIColor(red:0.84, green:0.21, blue:0.21, alpha:1.0).cgColor
                            
                            marrigeBtn.add(for: .touchUpInside) { [unowned self, unowned cardView, unowned previousCardMarrige] in
                                self.playMarrige(cards: [cardView, previousCardMarrige])
                            }
                            
                            self.addSubview(marrigeBtn)
                            marrigeButtons.append(marrigeBtn)
                        }
                    } else {
                        marrigeFlag = true
                    }
                }
            }
        }
        
//        animateLayoutCardsIfNeeded()
    }
    
    func playMarrige(cards: [PlayingCardView]) {
        // Disable others
        let cardViews = player.playersCards.compactMap { (card: PlayingCard) -> PlayingCardView? in
            return card.view
        }
        
        // Enable selected marrige cards
        for cardView in cardViews {
            if let cardIndex = cards.firstIndex(of: cardView), cardIndex >= 0 {
                cardView.selectionEnabled = true
            } else {
                cardView.selectionEnabled = false
            }
        }
        
        removeMarrigeButtons()
        
        playMarrigeSelected = true
    }
    
    private func removeMarrigeButtons() {
        // Remove all marrigeButtons
        marrigeButtons.forEach { (marrigeButton) in
            marrigeButton.removeFromSuperview()
        }
    }
    
    func cancelAction() {
        if onMove, playMarrigeSelected {
            // Enable cards
            let cardViews = player.playersCards.compactMap { (card: PlayingCard) -> PlayingCardView? in
                return card.view
            }
            
            for cardView in cardViews {
                cardView.selectionEnabled = true
            }
            
            playMarrigeSelected = false
            
            markOnMove(onMove)
        }
    }
    
    func animateLayoutCardsIfNeeded2() {
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutCardsIfNeeded()
        }, completion: { (finish) in
            //TODO completion()
        }) 
    }
    
    private func playWithCard(cardView: PlayingCardView) {
        if onMove, cardView.marrige, playMarrigeSelected {
            // TODO add points for marrige
            
            // Remove marrige flag for
            let cards = player.playersCards.filter({ (card: Card) -> Bool in
                return card.color == cardView.playingCard.color
            })
            
            // Remove marrige flag
            for card in cards {
                card.view!.marrige = false
            }
            
            playMarrigeSelected = false
        }
        
        removeMarrigeButtons()
        
        self.player.playWithCardInternal(cardView.playingCard!.card)
    }
    
    private func layoutCardsIfNeeded() {
        for (i, cardView) in cardsView.subviews.enumerated() {
            
            //Distribute cards evenly
            switch cardsView.subviews.count {
            case 1:
                placeRotateCard(cardView, rotation: 0)
            case 2:
                switch i {
                case 0:
                    placeRotateCard(cardView, rotation: -4)
                case 1:
                    placeRotateCard(cardView, rotation: 4)
                default:
                    assertionFailure("Check cards")
                }
            case 3:
                switch i {
                case 0:
                    placeRotateCard(cardView, rotation: -8)
                case 1:
                    placeRotateCard(cardView, rotation: 0)
                case 2:
                    placeRotateCard(cardView, rotation: 8)
                default:
                    assertionFailure("Check cards")
                }
            case 4:
                switch i {
                case 0:
                    placeRotateCard(cardView, rotation: -12)
                case 1:
                    placeRotateCard(cardView, rotation: -4)
                case 2:
                    placeRotateCard(cardView, rotation: 4)
                case 3:
                    placeRotateCard(cardView, rotation: 12)
                default:
                    assertionFailure("Check cards")
                }
            case 5:
                switch i {
                case 0:
                    placeRotateCard(cardView, rotation: -16)
                case 1:
                    placeRotateCard(cardView, rotation: -8)
                case 2:
                    placeRotateCard(cardView, rotation: 0)
                case 3:
                    placeRotateCard(cardView, rotation: 8)
                case 4:
                    placeRotateCard(cardView, rotation: 16)
                default:
                    assertionFailure("Check cards")
                }
            default:
                // More than 5 cards...?!?
                assertionFailure("Check cards")
            }
        }
    }
    
    private func placeRotateCard(_ view: UIView, rotation: CGFloat) {
        let radians = rotation.degreesToRadians
        
        // TODO: 350 constant?!?
        let x = sin(radians) * (view.superview!.frame.height + 350)
        let y = cos(radians) * (view.superview!.frame.height + 350) - (view.superview!.frame.height + 350)
        
        let vC = view.superview!.center
        
        view.center = CGPoint(x: vC.x + x, y: vC.y - y)
        view.layer.transform = CATransform3DMakeRotation(radians, 0, 0, 1)
        
        // TODO use card size
    }
    
    private func rotateCard(_ view: UIView) -> CGFloat {
        let xx = view.center.x - view.superview!.frame.width/2
        let yy = view.superview!.frame.height + 350
        
        return tan( xx / yy)
    }
    
    // MARK: - Stash PlayingCard
    
    func moveCardsToStash(_ cardViews: [PlayingCardView], completion: @escaping (() -> Void)) {
        for cardView in cardViews {            
            let fram = cardView.superview!.convert(cardView.center, to: stashView)
            stashView.addSubview(cardView)
            cardView.center = fram
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            for cardView in cardViews {
                cardView.mode = .back
                cardView.frame.origin = CGPoint(x: 0, y: 0) // TODO self.stashView.center
            }
        }) { (finish) in
            completion()
        }
    }
    
    func updateScore(_ score: Int) {
        countLabel?.text = String(score)
    }

    // MARK: - UIResponder

    private var beginCenterPoint: CGPoint?
    private var beginTransform: CATransform3D?
    private var beginIndex: Int?
    private var touchOffset: CGPoint?
    private var touchTimestamp: TimeInterval?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if let cardView = touch.view as? PlayingCardView {
                
                let suprView = cardView.superview!
                beginIndex = suprView.subviews.firstIndex(of: cardView)
                
                touchTimestamp = event?.timestamp
                
                suprView.bringSubviewToFront(cardView)
                
                cardView.liftShadow()
                let touchLocation = touch.location(in: cardView.superview!)
                // Calculate offset from center
                beginCenterPoint = cardView.center
                beginTransform = cardView.layer.transform
                touchOffset = CGPoint(x: cardView.center.x - touchLocation.x, y: cardView.center.y - touchLocation.y)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if let cardView = touch.view as? PlayingCardView {
                let suprView = cardView.superview!
                let touchLocation = touch.location(in: suprView)
                cardView.center.x = touchLocation.x + (touchOffset?.x ?? 0)
                cardView.center.y = touchLocation.y + (touchOffset?.y ?? 0)
                
                cardView.layer.transform = CATransform3DMakeRotation(rotateCard(cardView), 0, 0, 1)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if let cardView = touch.view as? PlayingCardView {
                cardView.resetShadow()
                
                // Detect tap
                if let time = touchTimestamp, let event = event, event.timestamp - time < 0.5 {
                    self.playWithCard(cardView: cardView)
                    return
                }
                
                let dropLocation = touch.location(in: window!)
                let dropView = window?.hitTest(dropLocation, with: event)
                
                // TODO detect real tableView
                
                if dropView is TableView {
                    self.playWithCard(cardView: cardView)
                    return
                }
                
                // TODO detect DeckView as droppable, combine both ifs
                
                if dropView is DeckView {
                    self.player.exchangeTrumpCardInternal(cardView.playingCard!.card)
                    return
                }
                
                if dropView?.superview is DeckView {
                    self.player.exchangeTrumpCardInternal(cardView.playingCard!.card)
                    return
                }
                
                // Return card to previous position
                UIView.animate(withDuration: 0.2, animations: {
                    cardView.center = self.beginCenterPoint!
                    cardView.layer.transform = self.beginTransform!
                }, completion: { (finish) in
                    let suprView = cardView.superview!
                    suprView.insertSubview(cardView, at: self.beginIndex!)
                }) 
            } else {
                self.cancelAction()
            }
        }
        
        touchOffset = nil
    }
}
