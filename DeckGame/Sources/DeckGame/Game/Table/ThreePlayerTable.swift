//
//  ThreePlayerTable.swift
//  CardGame
//
//  Created by Davorin Madaric on 05/11/2021.
//  Copyright © 2021 Davorin Madaric. All rights reserved.
//

import Foundation
import DeckCommon

class ThreePlayerTable: Table {
    private var firstCard: Card?
    private var secondCard: Card?
    private var thirdCard: Card?
    
    var trumpColor: (() -> Card.Color?)?
    
    func addCard(_ card: Card, by playerPosition: PlayerPosition) -> TableResult? {
        switch playerPosition {
        case .first:
            self.firstCard = card
        case .second:
            self.secondCard = card
        case .third:
            self.thirdCard = card
        case .fourth:
            assertionFailure("Wrong")
        }
        
        guard let firstCard = firstCard, let secondCard = secondCard, let thirdCard = thirdCard else {
            return nil
        }
        
        let result = TableResult(playerPosition: playerPosition, cards: [firstCard, secondCard, thirdCard])
        
        // Cleanup
        self.firstCard = nil
        self.secondCard = nil
        self.thirdCard = nil
        
        return result
    }
}
