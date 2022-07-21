import Vapor
import Fluent
import Leaf

func routes(_ app: Application) throws {
    let webController = WebController()
    app.get(use: webController.index)
    app.get("login", use: webController.login)
    app.get("hello", use: webController.indexLeaf)
        
    let lobbyController = LobbyController(app)
    app.webSocket("lobby", onUpgrade: lobbyController.lobby)

    let todoController = TodoController()
    app.get("todos", use: todoController.index)
    app.post("todos", use: todoController.create)
    app.on(.DELETE, "todos", ":todoID", use: todoController.delete)
}
