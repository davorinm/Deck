//
//  CardsAPI.swift
//  CardGame
//
//  Created by Davorin Madaric on 26/12/2017.
//  Copyright © 2017 Davorin Madaric. All rights reserved.
//

import Foundation
import DMToolbox
import DeckCommon

public enum LobbyServiceState {
    case unknown
    case connected
    case disconnected
    case gameCreated(gameId: String)
}

public protocol LobbyService {
    var loading: ObservableProperty<Bool> { get }
    var users: ObservableProperty<[User]> { get }
    var state: ObservableProperty<LobbyServiceState> { get }
    
    func registerPlayer(name: String)
    func unregisterPlayer()
    func gameRequest(userId: String)
}
