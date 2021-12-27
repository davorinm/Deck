//
//  GameViewModel.swift
//  CardGame
//
//  Created by Davorin on 23/08/16.
//  Copyright © 2016 DavorinMadaric. All rights reserved.
//

import Foundation
import DMToolbox
import DeckCommon

class GameViewModel {
    private let deck: Deck
    private let table: Table
    private let scoreboard: Scoreboard
    
    var playersRegistered: ((_ players: [Player], _ gameType: GameType) -> Void)!
    var gameEnd: (() -> Void)!
    
    // MARK: - Initialize
    
    init(gameMode: GameMode, deck: Deck, table: Table, scoreboard: Scoreboard) {
        self.deck = deck
        self.table = table
        self.scoreboard = scoreboard
        
        // GameService state
        let gameService: GameService = ServiceLocator.current.get()
        gameService.playingState.subscribe(self) { (playingState) in
            self.handleGamePlayingState(playingState)
        }
    }
    
    func startGame() {
        let gameService: GameService = ServiceLocator.current.get()
        gameService.startGame()
    }
    
    // MARK: - State
    
    private func handleGamePlayingState(_ gamePlayingState: GamePlayingState?) {
        guard let gamePlayingState = gamePlayingState else {
            assertionFailure("?!?!?!?!?")
            return
        }
        
        switch gamePlayingState {
        case .playersRegistered(let players, let gameType):
            // Register players actions
            for player in players {
                player.placeOnTable = { [unowned player] card in
                    let gameService: GameService = ServiceLocator.current.get()
                    gameService.placeOnTable(player, card)
                }
                
                player.trumpColor = {
                    let gameService: GameService = ServiceLocator.current.get()
                    return gameService.trumpColor
                }
                
                player.exchangeTrumpCard = { [unowned player] card in
                    let gameService: GameService = ServiceLocator.current.get()
                    return gameService.exchangeTrumpCard(player, card)
                }
            }
            
            self.playersRegistered(players, gameType)
        case .createDeck(let count, let completion):
            self.deck.create(count, completion: completion)
        case .addCard(let player, let card, let deckCardsCount, let completion):
            let playingCard = self.deck.createCard(card)
            player.addCard(playingCard, completion: completion)
            self.deck.update(deckCardsCount)
        case .placeTrumpCard(let card, let completion):
            let trumpCard = self.deck.createCard(card)
            self.deck.placeTrumpCard(trumpCard, completion: completion)
        case .playerOnMove(let playerPosition, let players, let completion):
            self.markPlayerOnMove(playerPosition, players: players)
            completion()
        case .playerMove(let player, let card, let completion):
            let playingCard = player.playingCard(card)
            self.table.addCard(playingCard, player: player, completion: completion)
        case.playerExchangeTrumpCard(let player, let card, let completion):
            let playingCard = player.playingCard(card)
            self.deck.exchangeTrumpCard(playingCard, completion: { trumpCard in
                player.addCard(trumpCard, completion: completion)
            })
        case .stashTableCards(let player, let completion):
            let playingCards = self.table.playingCards()
            player.stashCards(playingCards, completion: completion)
        case .gameEnd(winner: let winner):
            self.gameEnd()
        }
    }
    
    // MARK: - Helpers
    
    private func markPlayerOnMove(_ playerPosition: PlayerPosition?, players: [Player]) {
        guard let playingPlayerPosition = playerPosition else {
            // Clear all players move
            for player in players {
                player.markOnMove(false, cardColor: nil, trumpColor: nil)
            }
            return
        }
        
        for player in players {
            if player.position == playingPlayerPosition {
                player.markOnMove(true, cardColor: nil, trumpColor: nil)
            } else {
                player.markOnMove(false, cardColor: nil, trumpColor: nil)
            }
        }
    }
}
