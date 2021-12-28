//
//  Table.swift
//  CardGame
//
//  Created by Davorin Madaric on 05/11/2021.
//  Copyright © 2021 Davorin Madaric. All rights reserved.
//

import Foundation
import DeckCommon

protocol Table {
    var trumpColor: (() -> Card.Color?)? { get }
    
    func addCard(_ card: Card, by playerPosition: PlayerPosition) -> TableResult?
}

struct TableResult {
    let playerPosition: PlayerPosition
    let cards: [Card]
}
