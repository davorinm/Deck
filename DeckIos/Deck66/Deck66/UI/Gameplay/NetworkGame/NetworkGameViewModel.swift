//
//  NetworkGameViewModel.swift
//  CardGame
//
//  Created by Davorin Madaric on 26/12/2017.
//  Copyright © 2017 Davorin Madaric. All rights reserved.
//

import Foundation
import DMToolbox
import DeckGame

protocol NetworkGameViewModelDelegate: AnyObject {
    func showError(error: Error)
    func showLoading(isLoading: Bool)
    func reload()
    func beginGame(gameId: String)
    func disconnected()
}

struct MultiplayerData {
    let userId: String
    let name: String
    let rank: String
}

class NetworkGameViewModel {
    weak var delegate: NetworkGameViewModelDelegate?
    
    private var items: [MultiplayerData] = [MultiplayerData]()
    
    private var lobbyServiceLoadingDisposable: DisposableEvent?
    private var lobbyServiceUsersDisposable: DisposableEvent?
    private var lobbyServiceStateDisposable: DisposableEvent?
    
    func load() {
        let lobbyService: LobbyService = ServiceLocator.current.get()
        
        lobbyServiceLoadingDisposable = lobbyService.loading.subscribeWithRaise { [unowned self] (loading) in
            self.delegate?.showLoading(isLoading: loading)
        }
        
        lobbyServiceUsersDisposable = lobbyService.users.subscribeWithRaise { [unowned self] (users) in
            self.items.removeAll()
            
            for user in users {
                self.items.append(MultiplayerData(userId: user.userId, name: user.name, rank: "x"))
            }
            
            self.delegate?.reload()
        }
        
        lobbyServiceStateDisposable = lobbyService.state.subscribeWithRaise { [unowned self] (state) in
            switch state {
            case .unknown:
                break
            case .connected:
                break
            case .disconnected:
                self.delegate?.disconnected()
            case .gameCreated(let gameId):
                self.delegate?.beginGame(gameId: gameId)
            }
        }
        
        lobbyService.registerPlayer(name: "Player!!!")
    }
    
    func unload() {
        lobbyServiceLoadingDisposable = nil
        lobbyServiceUsersDisposable = nil
        lobbyServiceStateDisposable = nil
        
        let lobbyService: LobbyService = ServiceLocator.current.get()
        lobbyService.unregisterPlayer()
        items.removeAll()
    }
    
    func gameRequest(userId: String) {
        let lobbyService: LobbyService = ServiceLocator.current.get()
        lobbyService.gameRequest(userId: userId)
    }
    
    // MARK: Data
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func dataAtIndex(index: Int) -> MultiplayerData? {
        return items[index]
    }
}
