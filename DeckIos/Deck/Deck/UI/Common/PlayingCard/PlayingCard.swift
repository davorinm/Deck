//
//  PlayingCard.swift
//  TestApp
//
//  Created by Davorin on 16/08/16.
//  Copyright © 2016 Davorin Mađarić. All rights reserved.
//

import Foundation
import DeckCommon

class PlayingCard {
    let card: Card
    let image: String
    
    var value: Int {
        get {
            return card.value
        }
    }
    var view: PlayingCardView?
    
    var selectionEnabled: Bool = true {
        didSet {
            view!.selectionEnabled = selectionEnabled
        }
    }
    
    init(_ card: Card) {
        self.card = card
        
        switch (self.card.color, self.card.face) {
        case (.hearts, .ace):
            image = "HeartsAce"
        case (.hearts, .ten):
            image = "HeartsTen"
        case (.hearts, .king):
            image = "HeartsKing"
        case (.hearts, .queen):
            image = "HeartsQueen"
        case (.hearts, .jack):
            image = "HeartsJack"
            
        case (.diamonds, .ace):
            image = "DiamondsAce"
        case (.diamonds, .ten):
            image = "DiamondsTen"
        case (.diamonds, .king):
            image = "DiamondsKing"
        case (.diamonds, .queen):
            image = "DiamondsQueen"
        case (.diamonds, .jack):
            image = "DiamondsJack"
            
        case (.spades, .ace):
            image = "SpadesAce"
        case (.spades, .ten):
            image = "SpadesTen"
        case (.spades, .king):
            image = "SpadesKing"
        case (.spades, .jack):
            image = "SpadesJack"
        case (.spades, .queen):
            image = "SpadesQueen"
            
        case (.clubs, .ace):
            image = "ClubsAce"
        case (.clubs, .ten):
            image = "ClubsTen"
        case (.clubs, .king):
            image = "ClubsKing"
        case (.clubs, .queen):
            image = "ClubsQueen"
        case (.clubs, .jack):
            image = "ClubsJack"
        }
    }
}
