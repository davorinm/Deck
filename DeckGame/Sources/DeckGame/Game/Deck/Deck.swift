//
//  Deck.swift
//  TestApp
//
//  Created by Davorin on 16/08/16.
//  Copyright © 2016 Davorin Mađarić. All rights reserved.
//

import Foundation
import DeckCommon

public class Deck {
    // TODO: remove from public
    private (set) var deckCards: [Card] = []
    var trumpCard: Card?
    
    init() {
    }
    
    func prepare() {
        self.deckCards = Card.fakeDeck() // TODO: Deck
    }
    
    func takeNext() -> Card {
        if deckCards.isEmpty {
            let card = trumpCard!
            trumpCard = nil
            return card
        }
        
        return deckCards.removeFirst()
    }
    
    func placeTrumpCard(_ card: Card) {
        trumpCard = card
    }
    
    func exchangeTrumpCard(_ card: Card) -> Card? {
        guard card.color == trumpCard?.color && card.face == .jack else {
            assertionFailure()
            return nil
        }
        
        let exchangedCard = trumpCard!
        trumpCard = card
        
        return exchangedCard
    }   
}
