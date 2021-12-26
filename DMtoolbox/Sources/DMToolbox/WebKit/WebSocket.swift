import Foundation

// TODO: Finish
public class WebSocket {
    public var didReceiveMessage: ((_ message: String) -> Void)?
    
    private var webSocketTask: URLSessionWebSocketTask!
    
    public init(url: URL) {
        let urlSession = URLSession(configuration: .default)
        webSocketTask = urlSession.webSocketTask(with: url)
    }
    
    public func connect(_ completion: (() -> Void)) {
        webSocketTask.resume()
        receiveMessage()
        
        completion()
    }
    
    public func disconnect(_ completion: (() -> Void)) {
        webSocketTask.cancel(with: .goingAway, reason: nil)
    }
    
    public func write(string: String) {
        let message = URLSessionWebSocketTask.Message.string(string)
        webSocketTask.send(message) { error in
          if let error = error {
            print("WebSocket couldn’t send message because: \(error)")
          }
        }
    }
    
    // MARK: - Helpers
    
    private func receiveMessage() {
        webSocketTask.receive { result in
            switch result {
                case .failure(let error):
                    print("Error in receiving message: \(error)")
                case .success(let message):
                    switch message {
                        case .string(let text):
                            print("Received string: \(text)")
                            
                            DispatchQueue.main.async {
                                self.didReceiveMessage?(text)
                            }
                        
                        
                        case .data(let data):
                            print("Received data: \(data)")
                        @unknown default:
                            print("ERR")
                    }
            }
        }
    }
    
    
    func sendPing() {
      webSocketTask.sendPing { (error) in
        if let error = error {
          print("Sending PING failed: \(error)")
        }
     
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
          self.sendPing()
        }
      }
    }
}
