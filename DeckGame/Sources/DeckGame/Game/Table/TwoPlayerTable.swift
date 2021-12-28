//
//  TableResolvingResult.swift
//  CardGame
//
//  Created by Davorin Madaric on 04/05/2018.
//  Copyright © 2018 Davorin Madaric. All rights reserved.
//

import Foundation
import DeckCommon

class TwoPlayerTable: Table {
    private var firstCard: Card?
    private var secondCard: Card?
    
    var trumpColor: (() -> Card.Color?)?
    
    func addCard(_ card: Card, by playerPosition: PlayerPosition) -> TableResult? {
        switch playerPosition {
        case .first:
            self.firstCard = card
        case .second:
            self.secondCard = card
        case .third:
            assertionFailure("Wrong")
        case .fourth:
            assertionFailure("Wrong")
        }
        
        guard let firstCard = firstCard, let secondCard = secondCard else {
            return nil
        }
        
        let winerPlayerPosition: PlayerPosition
        let trumpColor = self.trumpColor!()
        
        if firstCard.color == trumpColor && secondCard.color == trumpColor {
            
            if firstCard.value > secondCard.value {
                winerPlayerPosition = PlayerPosition.first
            } else {
                winerPlayerPosition = PlayerPosition.second
            }
            
        } else if firstCard.color == trumpColor && secondCard.color != trumpColor {
            
            winerPlayerPosition = PlayerPosition.first
            
        } else if firstCard.color != trumpColor && secondCard.color == trumpColor {
            
            winerPlayerPosition = PlayerPosition.second
            
        } else if firstCard.color == secondCard.color {
            
            if firstCard.value > secondCard.value {
                winerPlayerPosition = PlayerPosition.first
            } else {
                winerPlayerPosition = PlayerPosition.second
            }
            
        } else {
            
            winerPlayerPosition = PlayerPosition.first
            
        }
        
        let result = TableResult(playerPosition: winerPlayerPosition, cards: [firstCard, secondCard])
        
        // Cleanup
        self.firstCard = nil
        self.secondCard = nil
        
        return result
    }
}
