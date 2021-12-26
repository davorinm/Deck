import Foundation
import Vapor
import CardGameCommon

class LobbyController {
    private var users: [User] = []
    
    init(_ app: Application) {
        
        users = (1...33).map { User(userId: "\($0)", name: "\($0)") }
        
        
        
        
        app.foo.bar = 0
        app.foo.bar += 1
        print(app.foo.bar) // 1
    }
    
    func lobby(req: Vapor.Request, ws: WebSocketKit.WebSocket) -> () {
        ws.onText { [unowned self] (ws, text) in
            print(text)
                        
            guard let lobbyMessage = LobbyMessage(json: text) else {
                ws.close(promise: nil)
                return
            }
            
            switch lobbyMessage.type {
            case .checkIn:
                if let checkIn = lobbyMessage.username {                    
                    self.users.append(User(userId: checkIn, name: checkIn))
                }
                
                let lm = LobbyMessage(users: self.users)
                guard let sss = lm.toJson() else {
                    assertionFailure("Lobby message json failure")
                    return
                }
                
                ws.send(sss)
            case .users:
                break
            case .join:
                break
            case .leave:
                break
            case .gameRequest:
                break
            case .gameAccepted:
                break
            case .gameDenied:
                break
            case .gameCreated:
                break
            }
        }
        
        ws.onBinary { [unowned self] (ws, buffer) in
            print(buffer)
            
            
        }
        
        ws.onClose.always { [unowned self] (result) in
            
            print(result)
        }
        
//        ws.onClose.whenComplete { [unowned self] (result) in
//
//            print(result)
//
//        }

//        let ip = req.remoteAddress?.description ?? "<no ip>"
//        ws.send("Hellooo 👋 \(ip)")
    }
    
    // MARK: - Helpers
    
    private func sendUsers() {
        
        
        
        
        
    }
}
