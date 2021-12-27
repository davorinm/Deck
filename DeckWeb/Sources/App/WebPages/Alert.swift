import Foundation
import Leaf

public struct Alert: HTMLComponent {
    let isDisimissable: Conditionable // This is a protocol that makes it possible to optimize if's
    let message: HTML

    public var body: HTML {
        Div {
            message
            
            IF(isDisimissable) {
                Button {
                    Span { "&times;" }
                        .aria(for: "hidden", value: true)
                }
                .type(.button)
                .class("close")
                .data("dismiss", value: "alert")
                .aria("label", value: "Close")
            }
        }
        .class("alert alert-danger bg-danger")
        .modify(if: isDisimissable) {
            $0.class("fade show")
        }
        .role("alert")
    }
}
