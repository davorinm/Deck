//
//  GameEngineLocal.swift
//  CardGame
//
//  Created by Davorin Madaric on 17/04/2018.
//  Copyright © 2018 Davorin Madaric. All rights reserved.
//

import Foundation
import DMToolbox
import DeckCommon

class GameEngineLocal: GameEngine {
    let state: ObservableProperty<GameState> = ObservableProperty<GameState>(value: .initialized)
    let playingState: ObservableProperty<GamePlayingState?> = ObservableProperty<GamePlayingState?>(value: nil)
    
    private(set) var trumpColor: Card.Color?
    
    let gameType: GameType
    let players: [Player]
    
    private var deckCards: [Card]
    private var table: PlayerTable
    
    init(gameType: GameType) {
        self.gameType = gameType

        switch gameType {
        case .twoPlayers:
            self.table = TwoPlayerTable()
        case .threePlayers:
            self.table = ThreePlayerTable()
        case .fourPlayers:
            self.table = FourPlayerTable()
        }
        
        switch gameType {
        case .twoPlayers:
            self.players = [PlayerHuman(playerPosition: .first),
                            PlayerComputer(playerPosition: .second)]
        case .threePlayers:
            self.players = [PlayerHuman(playerPosition: .first),
                            PlayerComputer(playerPosition: .second),
                            PlayerComputer(playerPosition: .third)]
        case .fourPlayers:
            self.players = [PlayerHuman(playerPosition: .first),
                            PlayerComputer(playerPosition: .second),
                            PlayerComputer(playerPosition: .third),
                            PlayerComputer(playerPosition: .fourth)]
        }
        
        self.deckCards = Card.fakeDeck() // TODO: Deck
        
        // TODO: check!!!
        self.table.trumpColor = { [unowned self] in
            return self.trumpColor
        }
    }
    
    func registerPlayer(name: String) {
        self.playingState.value = .playersRegistered(players: self.players, gameType: self.gameType)
    }
    
    func startGame() {
        self.state.value = .playing(gameType: self.gameType)
        
        FutureChain.create()
            .then { self.createDeck() }
            .then { self.dealCards() }
            .then { self.markStartingPlayerMove() }
            .done { result in
                print("DONE startGame")
        }
    }
    
    func placeOnTable(_ player: Player, _ card: Card) {
        FutureChain.create()
            .then { self.disablePlayersMove() }
            .then { self.addCardToTable(player.position, card) }
            .done { (result) in
                switch result {
                case .success(let tableResult):
                    FutureChain.create()
                        .then { self.wait() }
                        .then { self.stash(tableResult: tableResult) }
                        .then { self.dealNextTrick(playerPosition: tableResult.playerPosition) }
                        .then { self.markTrickWinnerPlayerMove(playerPosition: tableResult.playerPosition) }
                        .done({ (result) in
                            switch result {
                            case .success:
                                print("placeOnTable markTrickWinnerPlayerMove success")
                            case .failure:
                                print("placeOnTable markTrickWinnerPlayerMove failure")
                                self.playingState.value = nil
                                self.state.value = .gameEnd
                            }
                        })
                case .failure(_):
                    FutureChain.create()
                        .then { self.markNextPlayerMove(player) }
                        .done({ (result) in
                            switch result {
                            case .success:
                                print("placeOnTable markNextPlayerMove success")
                            case .failure:
                                print("placeOnTable markNextPlayerMove failure")
                            }
                        })
                }
        }
    }
    
    func exchangeTrumpCard(_ player: Player, _ card: Card) {
        guard card.color == trumpColor && card.face == .jack else {
            assertionFailure()
            return
        }
        
        let cardT = self.deckCards.removeLast()
        
        self.playingState.value = .playerExchangeTrumpCard(player: player, card: card, completion: {
            print("TADAAAAAA")
            
            /*
            let card = self.deckCards.removeFirst()
            self.trumpColor = card.color
            self.state.value = .placeTrumpCard(card: card, completion: {
                self.deckCards.append(card)
                completion(FutureResult.success(()))
            })
 */
            
            self.deckCards.append(card)
            
            //deckCards.append(card)
        })
    }
    
    // MARK: - Futures
    
    private func createDeck() -> Future<Void> {
        return Future { [unowned self] completion in
            self.playingState.value = .createDeck(count: self.deckCards.count, completion: {
                completion(FutureResult.success(()))
            })
        }
    }
    
    private func dealCards() -> Future<Void> {
        switch gameType {
        case .twoPlayers:
            return dealTwoPlayerCards()
        case .threePlayers:
            return dealThreePlayerCards()
        case .fourPlayers:
            return dealFourPlayerCards()
        }
    }
    
    private func dealTwoPlayerCards() -> Future<Void> {
        return FutureChain.create()
            .then { self.dealCard(to: PlayerPosition.first) }
            .then { self.dealCard(to: PlayerPosition.first) }
            .then { self.dealCard(to: PlayerPosition.first) }
            .then { self.dealCard(to: PlayerPosition.second) }
            .then { self.dealCard(to: PlayerPosition.second) }
            .then { self.dealCard(to: PlayerPosition.second) }
            .then { self.placeTrumpCard() }
            .then { self.dealCard(to: PlayerPosition.first) }
            .then { self.dealCard(to: PlayerPosition.first) }
            .then { self.dealCard(to: PlayerPosition.second) }
            .then { self.dealCard(to: PlayerPosition.second) }
    }
    
    private func dealThreePlayerCards() -> Future<Void> {
        return FutureChain.create()
            .then { self.dealCard(to: PlayerPosition.first) }
            .then { self.dealCard(to: PlayerPosition.first) }
            .then { self.dealCard(to: PlayerPosition.first) }
            .then { self.dealCard(to: PlayerPosition.second) }
            .then { self.dealCard(to: PlayerPosition.second) }
            .then { self.dealCard(to: PlayerPosition.second) }
            .then { self.dealCard(to: PlayerPosition.third) }
            .then { self.dealCard(to: PlayerPosition.third) }
            .then { self.dealCard(to: PlayerPosition.third) }
            .then { self.placeTrumpCard() }
            .then { self.dealCard(to: PlayerPosition.first) }
            .then { self.dealCard(to: PlayerPosition.first) }
            .then { self.dealCard(to: PlayerPosition.second) }
            .then { self.dealCard(to: PlayerPosition.second) }
            .then { self.dealCard(to: PlayerPosition.third) }
            .then { self.dealCard(to: PlayerPosition.third) }
    }
    
    private func dealFourPlayerCards() -> Future<Void> {
        return FutureChain.create()
            .then { self.dealCard(to: PlayerPosition.first) }
            .then { self.dealCard(to: PlayerPosition.second) }
            .then { self.dealCard(to: PlayerPosition.third) }
            .then { self.dealCard(to: PlayerPosition.fourth) }
            .then { self.dealCard(to: PlayerPosition.first) }
            .then { self.dealCard(to: PlayerPosition.second) }
            .then { self.dealCard(to: PlayerPosition.third) }
            .then { self.dealCard(to: PlayerPosition.fourth) }
            .then { self.dealCard(to: PlayerPosition.first) }
            .then { self.dealCard(to: PlayerPosition.second) }
            .then { self.dealCard(to: PlayerPosition.third) }
            .then { self.dealCard(to: PlayerPosition.fourth) }
            .then { self.dealCard(to: PlayerPosition.first) }
            .then { self.dealCard(to: PlayerPosition.second) }
            .then { self.dealCard(to: PlayerPosition.third) }
            .then { self.dealCard(to: PlayerPosition.fourth) }
        
    }
    
    private func dealCard(to playerPosition: PlayerPosition) -> Future<Void> {
        return Future { [unowned self] completion in
            if self.deckCards.isEmpty {
                completion(FutureResult.success(()))
                return
            }
            
            guard let player = self.playerForPosition(playerPosition) else {
                assertionFailure("No player!!!!")
                completion(FutureResult.failure(GameServiceError.resolvingFailed))
                return
            }
            
            let card = self.deckCards.removeFirst()
            self.playingState.value = .addCard(player: player, card: card, deckCardsCount: self.deckCards.count, completion: {
                completion(FutureResult.success(()))
            })
        }
    }
    
    private func placeTrumpCard() -> Future<Void> {
        return Future { [unowned self] completion in
            let card = self.deckCards.removeFirst()
            self.trumpColor = card.color
            self.playingState.value = .placeTrumpCard(card: card, completion: {
                self.deckCards.append(card)
                completion(FutureResult.success(()))
            })
        }
    }
    
    private func markStartingPlayerMove() -> Future<Void> {
        return Future { [unowned self] completion in
            self.playingState.value = .playerOnMove(playerPosition: .first, players: self.players, completion: {
                completion(FutureResult.success(()))
            })
        }
    }
    
    private func markNextPlayerMove(_ player: Player) -> Future<Void> {
        return Future { [unowned self] completion in
            let nextPlayer: PlayerPosition
            let playerPosition = player.position
            
            switch gameType {
            case .twoPlayers:
                switch playerPosition {
                case .first:
                    nextPlayer = .second
                case .second:
                    nextPlayer = .first
                case .third:
                    assertionFailure("Error player")
                    return
                case .fourth:
                    assertionFailure("Error player")
                    return
                }
            case .threePlayers:
                switch playerPosition {
                case .first:
                    nextPlayer = .second
                case .second:
                    nextPlayer = .third
                case .third:
                    nextPlayer = .first
                case .fourth:
                    assertionFailure("Error player")
                    return
                }
            case .fourPlayers:
                switch playerPosition {
                case .first:
                    nextPlayer = .second
                case .second:
                    nextPlayer = .third
                case .third:
                    nextPlayer = .fourth
                case .fourth:
                    nextPlayer = .first
                }
            }
            
            self.playingState.value = .playerOnMove(playerPosition: nextPlayer, players: self.players, completion: {
                completion(FutureResult.success(()))
            })
        }
    }
    
    private func disablePlayersMove() -> Future<Void> {
        return Future { [unowned self] completion in
            self.playingState.value = .playerOnMove(playerPosition: nil, players: self.players, completion: {
                completion(FutureResult.success(()))
            })
        }
    }
    
    private func addCardToTable(_ playerPosition: PlayerPosition, _ card: Card) -> Future<TableResolvingResult> {
        return Future { [unowned self] completion in
            guard let player = self.playerForPosition(playerPosition) else {
                assertionFailure("No player!!!!")
                completion(FutureResult.failure(GameServiceError.resolvingFailed))
                return
            }
            
            self.playingState.value = .playerMove(player: player, card: card, completion: {
                if let result = self.table.addCard(card, by: playerPosition) {
                    completion(FutureResult.success(result))
                } else {
                    completion(FutureResult.failure(GameServiceError.resolvingFailed))
                }
            })
        }
    }
    
    private func markTrickWinnerPlayerMove(playerPosition: PlayerPosition) -> Future<Void> {
        return Future { [unowned self] completion in
            var endgame = false
            self.players.forEach({ (player) in
                if player.isEmpty() {
                    endgame = true
                }
            })
            
            if endgame {
                self.playingState.value = .gameEnd(winner: playerPosition)
                completion(FutureResult.success(()))
                return
            }
            
            self.playingState.value = .playerOnMove(playerPosition: playerPosition, players: self.players, completion: {
                completion(FutureResult.success(()))
            })
        }
    }
    
    private func stash(tableResult: TableResolvingResult) -> Future<Void> {
        return Future { [unowned self] completion in
            guard let player = self.playerForPosition(tableResult.playerPosition) else {
                assertionFailure("No player!!!!")
                completion(FutureResult.failure(GameServiceError.resolvingFailed))
                return
            }
            
            self.playingState.value = .stashTableCards(player: player, completion: {
                completion(FutureResult.success(()))
            })
        }
    }
    
    private func dealNextTrick(playerPosition: PlayerPosition) -> Future<Void> {
        switch gameType {
        case .twoPlayers:
            switch playerPosition {
            case .first:
                return FutureChain.create()
                    .then { self.dealCard(to: PlayerPosition.first) }
                    .then { self.dealCard(to: PlayerPosition.second) }
            case .second:
                return FutureChain.create()
                    .then { self.dealCard(to: PlayerPosition.second) }
                    .then { self.dealCard(to: PlayerPosition.first) }
            default:
                assertionFailure("Case error")
            }
        case .threePlayers:
            switch playerPosition {
            case .first:
                return FutureChain.create()
                    .then { self.dealCard(to: PlayerPosition.first) }
                    .then { self.dealCard(to: PlayerPosition.second) }
                    .then { self.dealCard(to: PlayerPosition.third) }
            case .second:
                return FutureChain.create()
                    .then { self.dealCard(to: PlayerPosition.second) }
                    .then { self.dealCard(to: PlayerPosition.third) }
                    .then { self.dealCard(to: PlayerPosition.first) }
            case .third:
                return FutureChain.create()
                    .then { self.dealCard(to: PlayerPosition.third) }
                    .then { self.dealCard(to: PlayerPosition.first) }
                    .then { self.dealCard(to: PlayerPosition.second) }
            default:
                assertionFailure("Case error")
            }
        case .fourPlayers:
            switch playerPosition {
            case .first:
                return FutureChain.create()
                    .then { self.dealCard(to: PlayerPosition.first) }
                    .then { self.dealCard(to: PlayerPosition.second) }
                    .then { self.dealCard(to: PlayerPosition.third) }
                    .then { self.dealCard(to: PlayerPosition.fourth) }
            case .second:
                return FutureChain.create()
                    .then { self.dealCard(to: PlayerPosition.second) }
                    .then { self.dealCard(to: PlayerPosition.third) }
                    .then { self.dealCard(to: PlayerPosition.fourth) }
                    .then { self.dealCard(to: PlayerPosition.first) }
            case .third:
                return FutureChain.create()
                    .then { self.dealCard(to: PlayerPosition.third) }
                    .then { self.dealCard(to: PlayerPosition.fourth) }
                    .then { self.dealCard(to: PlayerPosition.first) }
                    .then { self.dealCard(to: PlayerPosition.second) }
            case .fourth:
                return FutureChain.create()
                    .then { self.dealCard(to: PlayerPosition.fourth) }
                    .then { self.dealCard(to: PlayerPosition.first) }
                    .then { self.dealCard(to: PlayerPosition.second) }
                    .then { self.dealCard(to: PlayerPosition.third) }
            }
        }
        
        assertionFailure("Players number error")
        return FutureChain.create()
    }
    
    // MARK: - Helpers
    
    private func playerForPosition(_ playerPosition: PlayerPosition) -> Player? {
        return players.first { player in
            player.position == playerPosition
        }
    }
    
    private func wait() -> Future<Void> {
        return Future { [unowned self] completion in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                completion(FutureResult.success(()))
            }
        }
    }
}
