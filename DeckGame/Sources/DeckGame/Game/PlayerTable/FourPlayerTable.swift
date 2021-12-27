//
//  FourPlayerTable.swift
//  CardGame
//
//  Created by Davorin Madaric on 05/11/2021.
//  Copyright © 2021 Davorin Madaric. All rights reserved.
//

import Foundation
import CardGameCommon

class FourPlayerTable: PlayerTable {
    var trumpColor: (() -> Card.Color?)?
    
    func addCard(_ card: Card, by playerPosition: PlayerPosition) -> TableResolvingResult? {
        return nil
    }
}
