import Foundation

public struct User: Codable {
    public let userId: String
    public let name: String
    public let position: PlayerPositionX?
    
    public init(userId: String, name: String, position: PlayerPositionX? = nil) {
        self.userId = userId
        self.name = name
        self.position = position
    }
}

public enum PlayerPositionX: Int, Codable {
    case first = 0
    case second
    case third
    case fourth
}
