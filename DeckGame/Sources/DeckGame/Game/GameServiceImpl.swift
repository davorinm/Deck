//
//  GameServiceImpl.swift
//  CardGame
//
//  Created by Davorin Madaric on 17/04/2018.
//  Copyright © 2018 Davorin Madaric. All rights reserved.
//

import Foundation
import DMToolbox
import DeckCommon

class GameServiceImpl: GameService {
    let state: ObservableProperty<GameState> = ObservableProperty<GameState>(value: .initialized)
    
    private(set) var trumpColor: Card.Color?
    
    private var gameEngine: GameEngine?
    
    init() {
        // TODO: check!!!
//        table.trumpColor = { [unowned self] in
//            return self.trumpColor
//        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) { [unowned self] in
//            self.state.value = .assembling(gameMode: .quick(gameType: self.gameType))
//        }
    }
    
    func prepareGame(gameMode: GameMode) {
        switch gameMode {
        case .quick(let gameType):
            self.gameEngine = GameEngineLocal(gameType: gameType)
        case .network:
            self.gameEngine = GameEngineNetwork(gameId: "")
        }
        
        self.gameEngine!.state.subscribe(self) { [unowned self] (gameState) in
            print(gameState)
            
            guard let gameState = gameState else {
                assertionFailure("Check!!!")
                return
            }
            
            self.state.value = .playing(playingState: gameState)
        }
        
        self.state.value = .assembling(gameMode: gameMode)
    }
    
    func registerPlayer(name: String) {
        self.state.value = .prepared(gameType: gameEngine!.gameType)
        self.gameEngine!.registerPlayer(name: name)
    }
    
    func startGame() {
        self.gameEngine!.startGame()
    }
    
    func placeOnTable(_ player: Player, _ card: Card) {
        gameEngine!.placeOnTable(player, card)
    }
    
    func exchangeTrumpCard(_ player: Player, _ card: Card) {
        gameEngine!.exchangeTrumpCard(player, card)
    }
    
    func disassembleGame() {
        gameEngine = nil
    }
}
