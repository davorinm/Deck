import Foundation

/*
 MessageType protocol
 
                Client        Server          Client
 
 checkIn                 ->
 users                                  ->
 join                                   ->
 leave                                  ->
 gameRequest             ->             ->
 gameAccepted                           <-
 gameDenied              <-             <-
 gameCreated             <-             ->
 
*/

public struct LobbyMessage: Codable {
    public enum ContentType: String, Codable {
        case checkIn
        case users
        case join
        case leave
        case gameRequest
        case gameAccepted
        case gameDenied
        case gameCreated
    }
    
    public let type: ContentType
    public let username: String?
    public let user: User?
    public let users: [User]?
    public let userId: String?
    public let gameId: String?
    
    public init(checkIn username: String) {
        self.type = .checkIn
        self.username = username
        self.user = nil
        self.users = nil
        self.userId = nil
        self.gameId = nil
    }
    
    public init(userJoin user: User) {
        self.type = .join
        self.username = nil
        self.user = user
        self.users = nil
        self.userId = nil
        self.gameId = nil
    }
    
    public init(userLeave user: User) {
        self.type = .leave
        self.username = nil
        self.user = user
        self.users = nil
        self.userId = nil
        self.gameId = nil
    }
    
    public init(users: [User]) {
        self.type = .users
        self.username = nil
        self.user = nil
        self.users = users
        self.userId = nil
        self.gameId = nil
    }
    
    public init(gameRequest userId: String) {
        self.type = .gameRequest
        self.username = nil
        self.user = nil
        self.users = nil
        self.userId = userId
        self.gameId = nil
    }
    
    public init(gameAccepted userId: String) {
        self.type = .gameAccepted
        self.username = nil
        self.user = nil
        self.users = nil
        self.userId = userId
        self.gameId = nil
    }
    
    public init(gameDenied userId: String) {
        self.type = .gameDenied
        self.username = nil
        self.user = nil
        self.users = nil
        self.userId = userId
        self.gameId = nil
    }
    
    public init(gameCreated gameId: String) {
        self.type = .gameCreated
        self.username = nil
        self.user = nil
        self.users = nil
        self.userId = nil
        self.gameId = gameId
    }
    
    // JSON
    
    public init?(json: String) {
        guard let jsonData = json.data(using: .utf8) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        
        do {
            self = try decoder.decode(LobbyMessage.self, from: jsonData)
        } catch {
            return nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case username
        case user
        case users
        case userId
        case gameId
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try values.decode(ContentType.self, forKey: .type)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        user = try values.decodeIfPresent(User.self, forKey: .user)
        users = try values.decodeIfPresent([User].self, forKey: .users)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        gameId = try values.decodeIfPresent(String.self, forKey: .gameId)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(username, forKey: .username)
        try container.encode(user, forKey: .user)
        try container.encode(users, forKey: .users)
        try container.encode(userId, forKey: .userId)
        try container.encode(gameId, forKey: .gameId)
    }
    
    public func toJson() -> String? {
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch let error {
            assertionFailure("LobbyMessage toJson \(error)")
            return nil
        }
    }
}
