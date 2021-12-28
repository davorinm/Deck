//
//  PlayerHuman.swift
//  CardGame
//
//  Created by Davorin Madaric on 17/06/2018.
//  Copyright © 2018 Davorin Madaric. All rights reserved.
//

import Foundation
import DeckCommon

class PlayerHuman: Player {
    private(set) var position: PlayerPosition
    private(set) var playersCards: [Card] = []
    private var stashedCards: [Card] = []
    
    var trumpColor: (() -> Card.Color?)? // For detecting 20 or 40; TODO: Remove
    
    var placeOnTable: ((_ card: Card) -> ())?
    var exchangeTrumpCard: ((_ card: Card) -> ())?
    
    init(playerPosition: PlayerPosition) {
        self.position = playerPosition
    }
    
    func addCard(_ card: Card) {
        // Check for marrige
        if let marrigeCard = checkForMarrige(card), let index = playersCards.firstIndex(where: { (sCard: Card) -> Bool in
            return sCard === marrigeCard
        }) {
            
            // Mark marrige
            marrigeCard.marrige = true
            card.marrige = true
            
            playersCards.insert(card, at: index + 1)
        } else {
            playersCards.append(card)
        }
    }
    
    /// CardColor and TrumpColor limits selection to those colors => when deck is depleted
    func markOnMove(_ onMove: Bool, cardColor: Card.Color? = nil, trumpColor: Card.Color? = nil) {
        if let cColor = cardColor, hasColor(cColor) {
            disableOtherColors(cColor)
        } else if let cColor = trumpColor, hasColor(cColor) {
            disableOtherColors(cColor)
        } else {
            enableAllColors()
        }
    }
    
    func playWithCardInternal(_ card: Card) {
        placeOnTable?(card)
    }
    
    func exchangeTrumpCardInternal(_ card: Card) {
        let index = playersCards.firstIndex { (cardT: Card) -> Bool in
            return card == cardT
        }
        
        let removedCard = playersCards[index!]
        if removedCard != card {
            assertionFailure("Wrong card")
        }
        
        exchangeTrumpCard?(removedCard)
    }
    
    func stashCards(_ cards: [Card]) {
        stashedCards.append(contentsOf: cards)
    }
    
    func isEmpty() -> Bool {
        return playersCards.isEmpty
    }
    
    // MARK: - Helpers
    
    private func hasColor(_ color: Card.Color) -> Bool {
        for card in playersCards {
            if card.color == color {
                return true
            }
        }
        
        return false
    }
    
    private func disableOtherColors(_ color: Card.Color) {
        for card in playersCards {
            card.selectionEnabled = card.color == color
        }
    }
    
    private func enableAllColors() {
        for card in playersCards {
            card.selectionEnabled = true
        }
    }
    
    private func checkForMarrige(_ card: Card) -> Card? {
        if card.face == .king || card.face == .queen {
            let cards = playersCards.filter({ (sCard: Card) -> Bool in
                if card.color == sCard.color {
                    if card.face == .king && sCard.face == .queen {
                        return true
                    }
                    
                    if card.face == .queen && sCard.face == .king {
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
}
