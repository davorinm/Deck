//
//  Player.swift
//  TestApp
//
//  Created by Davorin on 16/08/16.
//  Copyright © 2016 Davorin Mađarić. All rights reserved.
//

import Foundation
import DeckCommon

public enum PlayerPosition {
    case first
    case second
    case third
    case fourth
}

public protocol Player: AnyObject {
    var position: PlayerPosition { get }
    var playersCards: [Card] { get }
    
    var trumpColor: (() -> Card.Color?)? { get set }
    var placeOnTable: ((_ card: Card) -> ())? { get set }
    var exchangeTrumpCard: ((_ card: Card) -> ())? { get set }
    
    /// Add card from deck
    func addCard(_ card: Card)

    /// CardColor and TrumpColor limits selection to those colors => when deck is depleted
    func markOnMove(_ onMove: Bool, cardColor: Card.Color?, trumpColor: Card.Color?)
    
    // TODO: remove from public
    func playWithCardInternal(_ card: Card)
    
    // TODO: remove from public
    func exchangeTrumpCardInternal(_ card: Card)
    
    /// Stash table cards
    func stashCards(_ cards: [Card])
    
    /// Check if players hand is empty
    func isEmpty() -> Bool
}
