//
//  GameMessage.swift
//  CardGame
//
//  Created by Davorin Madaric on 18/04/2018.
//  Copyright © 2018 Davorin Madaric. All rights reserved.
//

import Foundation

// TODO: Cleanup
public struct GameMessage: Codable {
    public enum ContentType: String, Codable {
        case initialized
        case waitingForPlayers
        case createDeck
        case addCard
        case placeTrumpCard
        case playerOnMove
        case playerMove
        case playerCloseDeck
        case playerExchangeTrumpCard
        case stashTableCards
        case gameEnd
    }
    
    public let type: ContentType
    public let count: Int?
    public let card: Card?
    public let player: User?
    public let cards: [Card]?
    public let value: Bool?
    
    init(createDeck count: Int) {
        self.type = .createDeck
        self.count = count
        self.card = nil
        self.player = nil
        self.cards = nil
        self.value = nil
    }
    
    init(addCard card: Card, player: User, deckCardsCount count: Int) {
        self.type = .addCard
        self.count = count
        self.card = card
        self.player = player
        self.cards = nil
        self.value = nil
    }
    
    init(placeTrumpCard card: Card) {
        self.type = .placeTrumpCard
        self.count = nil
        self.card = card
        self.player = nil
        self.cards = nil
        self.value = nil
    }
    
    init(playerOnMove player: User) {
        self.type = .playerOnMove
        self.count = nil
        self.card = nil
        self.player = player
        self.cards = nil
        self.value = nil
    }
    
    init(playerMove player: User, card: Card) {
        self.type = .playerMove
        self.count = nil
        self.card = card
        self.player = player
        self.cards = nil
        self.value = nil
    }
    
    init(playerExchangeTrumpCard player: User, card: Card) {
        self.type = .playerExchangeTrumpCard
        self.count = nil
        self.card = card
        self.player = player
        self.cards = nil
        self.value = nil
    }
    
    init(stashTableCards player: User) {
        self.type = .stashTableCards
        self.count = nil
        self.card = nil
        self.player = player
        self.cards = nil
        self.value = nil
    }
    
    // JSON
    
    public init?(json: String) {
        guard let jsonData = json.data(using: .utf8) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        
        do {
            self = try decoder.decode(GameMessage.self, from: jsonData)
        } catch {
            return nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case count
        case card
        case player
        case cards
        case value
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = try values.decode(ContentType.self, forKey: .type)
        self.count = try values.decodeIfPresent(Int.self, forKey: .count)
        self.card = try values.decodeIfPresent(Card.self, forKey: .card)
        self.player = try values.decodeIfPresent(User.self, forKey: .player)
        self.cards = try values.decodeIfPresent([Card].self, forKey: .cards)
        self.value = try values.decodeIfPresent(Bool.self, forKey: .value)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(count, forKey: .count)
        try container.encode(card, forKey: .card)
        try container.encode(player, forKey: .player)
        try container.encode(cards, forKey: .cards)
        try container.encode(value, forKey: .value)
    }
    
    func toJson() -> String? {
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch let error {
            assertionFailure("GameMessage toJson \(error)")
            return nil
        }
    }
}
