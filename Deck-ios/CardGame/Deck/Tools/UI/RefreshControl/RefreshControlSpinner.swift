import UIKit

class RefreshControlSpinner {
    
    /// Total number of rays to display.
    let numberOfRays = 12
    
    /// Radius of the inner circle that defines starting points of "rays".
    let innerRadius: CGFloat = 5
    
    /// Radius of the outer circle that defines ending points of "rays".
    let outerRadius: CGFloat = 10
    
    /// Width of each ray.
    let rayWidth: CGFloat = 1.4
    
    /// Color to draw rays with.
    var color: UIColor = UIColor.lightGray
    
    func drawRays(number: Int, withRect rect: CGRect, inContext context: CGContext) {
        UIGraphicsPushContext(context)
        
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        
        func x(radius: CGFloat, angle: Double) -> CGFloat {
            return radius * CGFloat(cos(angle)) + center.x
        }
        
        func y(radius: CGFloat, angle: Double) -> CGFloat {
            return radius * CGFloat(sin(angle)) + center.y
        }
        
        for i in 0..<number {
            let angle = Double(i) / Double(numberOfRays) * (Double.pi * 2) - Double.pi / 2
            let startPoint = CGPoint(x: x(radius: innerRadius + rayWidth / 2, angle: angle), y: y(radius: innerRadius + rayWidth / 2, angle: angle))
            let endPoint = CGPoint(x: x(radius: outerRadius - rayWidth / 2, angle: angle), y: y(radius: outerRadius - rayWidth / 2, angle: angle))
            
            let path = UIBezierPath()
            path.lineWidth = rayWidth
            path.lineCapStyle = .round
            path.move(to: startPoint)
            path.addLine(to: endPoint)
            
            color.setStroke()
            path.stroke()
        }
        
        UIGraphicsPopContext()
    }
}
