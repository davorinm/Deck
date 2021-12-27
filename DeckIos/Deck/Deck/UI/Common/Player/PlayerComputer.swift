//
//  PlayerComputer.swift
//  CardGame
//
//  Created by Davorin Madaric on 17/06/2018.
//  Copyright © 2018 Davorin Madaric. All rights reserved.
//

import Foundation
import CardGameCommon

class PlayerComputer: Player {
    private weak var playerView: PlayerView! // TODO: Remove

    private(set) var position: PlayerPosition
    private(set) var playersCards: [PlayingCard] = []
    private var stashedCards: [PlayingCard] = []
    
    var trumpColor: (() -> Card.Color?)?
    
    var placeOnTable: ((_ card: Card) -> ())?
    var exchangeTrumpCard: ((_ card: Card) -> ())?
    
    init(playerPosition: PlayerPosition) {
        self.position = playerPosition
    }
    
    func connectPlayerView(playerView: PlayerView) {
        self.playerView = playerView
        // TODO: Remove, make connection different
        self.playerView.setPlayer(self)
    }
    
    func addCard(_ card: PlayingCard, completion: @escaping (() -> Void)) {
        // Check for marrige
        if let marrigeCard = checkForMarrige(card), let index = playersCards.firstIndex(where: { (sCard: PlayingCard) -> Bool in
            return sCard === marrigeCard
        }) {
            
            // Mark marrige
            marrigeCard.view!.marrige = true
            card.view!.marrige = true
            
            playersCards.insert(card, at: index + 1)
        } else {
            playersCards.append(card)
        }
        
        playerView.addCard(completion)
    }
    
    /// CardColor and TrumpColor limits selection to those colors => when deck is depleted
    func markOnMove(_ onMove: Bool, cardColor: Card.Color? = nil, trumpColor: Card.Color? = nil) {
        playerView.markOnMove(onMove)
        
        if onMove {
            makeMove()
        }
    }
    
    func playWithCardInternal(_ card: Card) {
        assertionFailure("Computer player")
    }
    
    func exchangeTrumpCardInternal(_ card: Card) {
        assertionFailure("Computer player")
    }
    
    func stashCards(_ cards: [PlayingCard], completion: @escaping (() -> Void)) {
        stashedCards.append(contentsOf: cards)
        playerView.moveCardsToStash(cards.map{$0.view!}, completion: {
            
            // Update count
            var score = 0
            for card in self.stashedCards {
                score += card.value
            }
            self.playerView.updateScore(score)
            
            completion()
        })
    }
    
    func isEmpty() -> Bool {
        return playersCards.isEmpty
    }
    
    func playingCard(_ card: Card) -> PlayingCard {
        let index = playersCards.firstIndex { (cardT: PlayingCard) -> Bool in
            return card == cardT.card
        }
        
        let removedCard = playersCards.remove(at: index!)
        if removedCard.card != card {
            assertionFailure("Wrong card")
        }
        
//        playerView.animateLayoutCardsIfNeeded()
        
        return removedCard
    }
    
    // MARK: - Helpers
    
    private func checkForMarrige(_ card: PlayingCard) -> PlayingCard? {
        if card.card.face == .king || card.card.face == .queen {
            
            let cards = playersCards.filter({ (sCard: PlayingCard) -> Bool in
                if card.card.color == sCard.card.color {
                    if card.card.face == .king && sCard.card.face == .queen {
                        return true
                    }
                    
                    if card.card.face == .queen && sCard.card.face == .king {
                        return true
                    }
                }
                
                return false
            })
            
            if cards.count > 1 {
                assertionFailure("COUNT!!!!")
            }
            
            return cards.first
        }
        
        return nil
    }
    
    private func makeMove() {
        // Computer player logic
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let card = self.playersCards.randomElement()!.card
            self.placeOnTable?(card)
        })
    }
}
