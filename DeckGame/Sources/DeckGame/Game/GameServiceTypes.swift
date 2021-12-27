//
//  GameType.swift
//  CardGame
//
//  Created by Davorin Madaric on 03/11/2021.
//  Copyright © 2021 Davorin Madaric. All rights reserved.
//

import Foundation
import DeckCommon

// TODO: Move to common, or not...

public enum GameType: Int, Codable {
    case twoPlayers = 0
    case threePlayers
    case fourPlayers
}

public enum GameMode {
    case quick(gameType: GameType)
    case network
}

typealias Completion = (() -> Void)

enum GameState {
    case initialized
    case assembling(gameMode: GameMode)
    // TODO: Consider canceled state
    case playing(gameType: GameType)
    case gameEnd
}

enum GamePlayingState {
    case playersRegistered(players: [Player], gameType: GameType)
    case createDeck(count: Int, completion: Completion)
    case addCard(player: Player, card: Card, deckCardsCount: Int, completion: Completion)
    case placeTrumpCard(card: Card, completion: Completion)
    case playerOnMove(playerPosition: PlayerPosition?, players: [Player], completion: Completion)
    case playerMove(player: Player, card: Card, completion: Completion)
    case playerExchangeTrumpCard(player: Player, card: Card, completion: Completion)
    case stashTableCards(player: Player, completion: Completion)
    case gameEnd(winner: PlayerPosition)
}

enum GameServiceError: Error {
    case resolvingFailed
}
