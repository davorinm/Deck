import Foundation
import Leaf

struct SimplePage: HTMLTemplate {

    @TemplateValue(String.self)
    var context

    var body: HTML {
        Document(type: .html5) {
            Head {
                Title { context }
            }
            Body {
                P { context }
            }
        }
    }
}
