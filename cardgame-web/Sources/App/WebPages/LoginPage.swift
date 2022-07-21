import Foundation
import Leaf

struct LoginPageConfig: Codable {
    let message: String
    let useHTMLKit: Bool
}

struct LoginPage: HTMLPage {
    var body: HTML {
        Div {
            H3 { "Some Title" }                
        }
    }
}
