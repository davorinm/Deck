//
//  File.swift
//  
//
//  Created by Davorin Madaric on 28/12/2021.
//

import Foundation

public enum GameType: Int, Codable {
    case twoPlayers = 0
    case threePlayers
    case fourPlayers
}

public enum GameMode {
    case quick(gameType: GameType)
    case network
}
