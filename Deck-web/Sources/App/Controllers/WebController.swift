import Foundation
import Vapor
import Leaf
//import HTMLKit_Vapor_Provider

struct WebController {
    func index(req: Request) throws -> String {
        return "It works!"
    }
    
    func indexLeaf(req: Request) throws -> EventLoopFuture<View> {
        return req.view.render("index")
    }
    
    func index2(req: Request) throws -> EventLoopFuture<View> {
        let data = try req.query.decode(SimpleTemplateData.self)
        return SimpleTemplate().render(with: data, for: req)
    }
    
    func login(req: Request) throws -> EventLoopFuture<View> {
        let config = try req.query.decode(LoginPageConfig.self)
        if config.useHTMLKit {
            return LoginPage().render(for: req)
        } else {
            return req.view.render("login-page", config)
        }
    }
}
