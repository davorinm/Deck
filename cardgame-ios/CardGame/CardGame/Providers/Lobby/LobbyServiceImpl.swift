//
//  LobbyServiceImpl.swift
//  CardGame
//
//  Created by Davorin Madaric on 14/04/2018.
//  Copyright © 2018 Davorin Madaric. All rights reserved.
//

import Foundation
import CardGameCommon
import DMToolbox

class LobbyServiceImpl: LobbyService {
    let loading: ObservableProperty<Bool> = ObservableProperty<Bool>(value: false)
    let users: ObservableProperty<[User]> = ObservableProperty<[User]>(value: [])
    let state: ObservableProperty<LobbyServiceState> = ObservableProperty<LobbyServiceState>(value: .unknown)
    
    private let socket: WebSocket
    
    init() {
        socket = WebSocket(url: URL(string: "ws://localhost:8080/lobby")!)
        socket.didReceiveMessage = websocketDidReceiveMessage
    }
    
    func registerPlayer(name: String) {
        socket.connect() {
            
            
            state.value = .connected
            
            let lobbyMessage = LobbyMessage(checkIn: "123DDDDMMMM")
            guard let json = lobbyMessage.toJson() else {
                assertionFailure("Lobby message json failure")
                return
            }
            
            socket.write(string: json)
            
        }
    }
    
    func unregisterPlayer() {
        socket.disconnect() {

            state.value = .disconnected
        }
    }
    
    func gameRequest(userId: String) {
        let lobbyMessage = LobbyMessage(gameRequest: userId)
        guard let json = lobbyMessage.toJson() else {
            assertionFailure("Lobby message json failure")
            return
        }
        
        socket.write(string: json)
    }
    
    // MARK: - WebSocketDelegate
    
    
    func websocketDidReceiveMessage(text: String) {
        print("websocketDidReceiveMessage \(text)")
        
        guard let lobbyMessage = LobbyMessage(json: text) else {
            assertionFailure("Lobby message faiure")
            return
        }
        
        switch lobbyMessage.type {
        case .checkIn:
            break
        case .join:
            if let user = lobbyMessage.user {
                var users = self.users.value
                users.append(user)
                
                self.users.value = users
            }
        case .leave:
            if let user = lobbyMessage.user {
                self.users.value = self.users.value.filter({ (filterUser) -> Bool in
                    return filterUser.userId != user.userId
                })
            }
        case .users:
            if let users = lobbyMessage.users {
                self.users.value = users
            }
        case .gameRequest:
            break
        case .gameAccepted:
            break
        case .gameDenied:
            break
        case .gameCreated:
            if let gameId = lobbyMessage.gameId {
                state.value = .gameCreated(gameId: gameId)
            }
        }
    }
}
