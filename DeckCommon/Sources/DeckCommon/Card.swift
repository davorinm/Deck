import Foundation

public struct Card: Codable, Equatable {
    public enum Color: Int, Codable {
        case hearts = 1
        case diamonds = 2
        case spades = 3
        case clubs = 4
    }
    public enum Face: Int, Codable {
        case ace = 11
        case ten = 10
        case king = 4
        case queen = 3
        case jack = 2
    }
    
    public let color: Color
    public let face: Face
    public let value: Int
    
    init(_ cardColor: Color, _ cardFace: Face) {
        color = cardColor
        face = cardFace
        value = cardFace.rawValue
    }
}

extension Card {
    static func deck() -> [Card] {
        return [
            Card(.hearts, .ace),
            Card(.hearts, .ten),
            Card(.hearts, .king),
            Card(.hearts, .queen),
            Card(.hearts, .jack),
            Card(.diamonds, .ace),
            Card(.diamonds, .ten),
            Card(.diamonds, .king),
            Card(.diamonds, .queen),
            Card(.diamonds, .jack),
            Card(.spades, .ace),
            Card(.spades, .ten),
            Card(.spades, .king),
            Card(.spades, .jack),
            Card(.spades, .queen),
            Card(.clubs, .ace),
            Card(.clubs, .ten),
            Card(.clubs, .king),
            Card(.clubs, .queen),
            Card(.clubs, .jack)
        ]
    }
    
    static public func fakeDeck() -> [Card] {
        return [
            Card(.clubs, .jack),
            Card(.clubs, .king),
            Card(.clubs, .queen),
            
            Card(.hearts, .queen),
            Card(.hearts, .ten),
            Card(.hearts, .king),
            
            Card(.clubs, .ace),
            
            Card(.spades, .king),
            Card(.spades, .queen),
            
            Card(.diamonds, .king),
            Card(.diamonds, .queen),
            
            Card(.diamonds, .ten),
            Card(.diamonds, .jack),
            Card(.spades, .ace),
            Card(.spades, .ten),
            Card(.spades, .jack),
            Card(.diamonds, .ace),
            Card(.hearts, .ace),
            Card(.clubs, .ten),
            Card(.hearts, .jack)
        ]
    }
}
