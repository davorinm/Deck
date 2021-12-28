//
//  GameEngine.swift
//  CardGame
//
//  Created by Davorin Madaric on 29/11/2021.
//  Copyright © 2021 Davorin Madaric. All rights reserved.
//

import Foundation
import DeckCommon
import DMToolbox

protocol GameEngine {
    var state: ObservableProperty<GamePlayingState?> { get }
    
    var gameType: GameType { get }
    var players: [Player] { get }
    
    func registerPlayer(name: String)
    func startGame()
    
    func placeOnTable(_ player: Player, _ card: Card)
    func exchangeTrumpCard(_ player: Player, _ card: Card)
}
