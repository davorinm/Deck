//
//  Deck.swift
//  TestApp
//
//  Created by Davorin on 16/08/16.
//  Copyright © 2016 Davorin Mađarić. All rights reserved.
//

import Foundation
import CardGameCommon

class Deck {
    let deckView: DeckView
    
    private var trumpCard: PlayingCard!
    
    init(view: DeckView) {
        deckView = view
    }
    
    func create(_ count: Int, completion: @escaping (() -> Void)) {
        deckView.create(count, completion: completion)
    }
    
    func update(_ count: Int) {        
        deckView.update(count)
    }
    
    func placeTrumpCard(_ card: PlayingCard, completion: @escaping (() -> Void)) {
        trumpCard = card
        
        // TODO implement layoutCards on deckView
        
        deckView.placeTrumpCard(card.view!, completion: completion)
    }
    
    func exchangeTrumpCard(_ card: PlayingCard, completion: @escaping ((_ trumpCard: PlayingCard) -> ())) {
        let tempTrumpCard = trumpCard
        trumpCard = card
        
        // TODO implement layoutCards on deckView
        
        deckView.placeTrumpCard(card.view!, completion: {
            completion(tempTrumpCard!)
        })
    }
    
    func createCard(_ card: Card) -> PlayingCard {
        if card == trumpCard?.card {
            return trumpCard
        }
        
        let playingCard = PlayingCard(card)
        deckView.create(playingCard)
        
        return playingCard
    }    
}
