//
//  Table.swift
//  CardGame
//
//  Created by Davorin on 25/08/16.
//  Copyright © 2016 DavorinMadaric. All rights reserved.
//

import Foundation
import DeckCommon

class Table {
    let tableView: TableView
        
    private var firstCard: PlayingCard?
    private var secondCard: PlayingCard?
    
    init(view: TableView) {
        tableView = view
    }
    
    func addCard(_ card: PlayingCard, player: Player, completion: @escaping (() -> Void)) {
        if firstCard == nil {
            firstCard = card
        } else if secondCard == nil {
            secondCard = card
        } else {
            assert(true, "Third Card added to Table")
        }
        
        tableView.addCard(card.view!, player.position, completion: completion)
    }
    
    func numberOfCards() -> Int {
        var number = 0
        
        if firstCard != nil {
            number += 1
        }
        
        if secondCard != nil {
            number += 1
        }
        
        return number
    }
    
    func playingCards() -> [PlayingCard] {
        let pCards = [firstCard!, secondCard!]
        
        firstCard = nil
        secondCard = nil

        return pCards
    }
}
