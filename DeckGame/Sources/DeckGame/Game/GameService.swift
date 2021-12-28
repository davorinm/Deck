//
//  GameService.swift
//  CardGame
//
//  Created by Davorin Madaric on 06/02/2018.
//  Copyright © 2018 Davorin Madaric. All rights reserved.
//

import Foundation
import DMToolbox
import DeckCommon

public protocol GameService {
    var state: ObservableProperty<GameState> { get }
    
    // TODO: Chek if needed
//    var players: [Player] { get }
//    var table: Table { get }
//    var deck: Deck { get }
    // TODO: Chek if needed
    
    var trumpColor: Card.Color? { get }
    
    func prepareGame(gameMode: GameMode)
    func registerPlayer(name: String)
    func startGame()
    
    /// Playing user actions
    func placeOnTable(_ player: Player, _ card: Card)
    func exchangeTrumpCard(_ player: Player, _ card: Card)
    
    func disassembleGame()
}
