//
//  GameEngineNetwork.swift
//  CardGame
//
//  Created by Davorin Madaric on 17/04/2018.
//  Copyright © 2018 Davorin Madaric. All rights reserved.
//

import Foundation
import DMToolbox
import DeckCommon

class GameEngineNetwork: GameEngine {
    let state: ObservableProperty<GamePlayingState?> = ObservableProperty<GamePlayingState?>(value: nil)

    private(set) var trumpColor: Card.Color? = nil
    
    let gameType: GameType
    let players: [Player]
    
    private let socket: WebSocket
    
    init(gameId: String) {
        gameType = .twoPlayers
        players = [PlayerHuman(playerPosition: .first), PlayerComputer(playerPosition: .second)]
        
        socket = WebSocket(url: URL(string: "ws://localhost:8080/cardgame/game/\(gameId)")!)
        socket.didReceiveMessage = websocketDidReceiveMessage
    }
    
    func registerPlayer(name: String) {
        socket.connect() {
           socket.write(string: "HELLO")
        }
    }
    
    func startGame() {
        
    }
    
    func placeOnTable(_ player: Player, _ card: Card) {
        
    }
    
    func exchangeTrumpCard(_ player: Player, _ card: Card) {
        
    }
    
    // MARK: - WebSocket
        
    private func websocketDidReceiveMessage(text: String) {
        print("websocketDidReceiveMessage \(text)")
        
        guard let gameMessage = GameMessage(json: text) else {
            assertionFailure("Game message error")
            return
        }
        
        switch gameMessage.type {
        case .initialized:
            state.value = nil
        case .waitingForPlayers:
//            state.value = .waitingForPlayers(true)
            assertionFailure()
        case .createDeck:
//            if let count = gameMessage.count {
//                state.value = .createDeck(count: count, completion: { [unowned self] in
//                    self.socket.write(string: "deckcreated")
//                })
//            }
            
            
            assertionFailure()
        case .addCard:
            assertionFailure()
        case .placeTrumpCard:
            assertionFailure()
        case .playerOnMove:
            assertionFailure()
        case .playerMove:
            assertionFailure()
        case .playerCloseDeck:
            assertionFailure()
        case .playerExchangeTrumpCard:
            assertionFailure()
        case .stashTableCards:
            assertionFailure()
        case .gameEnd:
            assertionFailure()
        }
    }
}
