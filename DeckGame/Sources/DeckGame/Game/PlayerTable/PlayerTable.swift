//
//  PlayerTable.swift
//  CardGame
//
//  Created by Davorin Madaric on 05/11/2021.
//  Copyright © 2021 Davorin Madaric. All rights reserved.
//

import Foundation
import DeckCommon

protocol PlayerTable {
    var trumpColor: (() -> Card.Color?)? { get set }
    
    func addCard(_ card: Card, by playerPosition: PlayerPosition) -> TableResolvingResult?
}

struct TableResolvingResult {
    let playerPosition: PlayerPosition
    let cards: [Card]
}
