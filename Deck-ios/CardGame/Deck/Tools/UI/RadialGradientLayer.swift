//
//  GradientView.swift
//  Gradient View
//
//  Created by Sam Soffes on 10/27/09.
//  Copyright (c) 2009-2014 Sam Soffes. All rights reserved.
//

import UIKit

/// Simple view for drawing gradients and borders.
@IBDesignable class GradientView: UIView {
    
    // MARK: - Types
    
    /// The mode of the gradient.
    public enum GradientType {
        /// A linear gradient.
        case linear
        
        /// A radial gradient.
        case radial
    }
    
    
    /// The direction of the gradient.
    public enum Direction {
        /// The gradient is vertical.
        case vertical
        
        /// The gradient is horizontal
        case horizontal
    }
    
    
    // MARK: - Properties
    
    /// An optional array of `UIColor` objects used to draw the gradient. If the value is `nil`, the `backgroundColor`
    /// will be drawn instead of a gradient. The default is `nil`.
    var colors: [UIColor]? {
        didSet {
            updateGradient()
        }
    }
    
    /// An array of `UIColor` objects used to draw the dimmed gradient. If the value is `nil`, `colors` will be
    /// converted to grayscale. This will use the same `locations` as `colors`. If length of arrays don't match, bad
    /// things will happen. You must make sure the number of dimmed colors equals the number of regular colors.
    ///
    /// The default is `nil`.
    var dimmedColors: [UIColor]? {
        didSet {
            updateGradient()
        }
    }
    
    /// Automatically dim gradient colors when prompted by the system (i.e. when an alert is shown).
    ///
    /// The default is `true`.
    var automaticallyDims: Bool = true
    
    /// An optional array of `CGFloat`s defining the location of each gradient stop.
    ///
    /// The gradient stops are specified as values between `0` and `1`. The values must be monotonically increasing. If
    /// `nil`, the stops are spread uniformly across the range.
    ///
    /// Defaults to `nil`.
    var locations: [CGFloat]? {
        didSet {
            updateGradient()
        }
    }
    
    /// The mode of the gradient. The default is `.Linear`.
    var mode: GradientType = .linear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The direction of the gradient. Only valid for the `Mode.Linear` mode. The default is `.Vertical`.
    var direction: Direction = .vertical {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - UIView
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let size = bounds.size
        
        // Gradient
        if let gradient = gradient {
            let options: CGGradientDrawingOptions = [.drawsAfterEndLocation]
            
            if mode == .linear {
                let startPoint = CGPoint.zero
                let endPoint = direction == .vertical ? CGPoint(x: 0, y: size.height) : CGPoint(x: size.width, y: 0)
                context?.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: options)
            } else {
                let center = CGPoint(x: bounds.midX, y: bounds.midY)
                context?.drawRadialGradient(gradient, startCenter: center, startRadius: 0, endCenter: center, endRadius: max(size.width, size.height) / 1.5, options: options)
            }
        }
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        if automaticallyDims {
            updateGradient()
        }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        contentMode = .redraw
    }
    
    
    // MARK: - Private
    
    private var gradient: CGGradient?
    
    private func updateGradient() {
        gradient = nil
        setNeedsDisplay()
        
        let colors = gradientColors()
        if let colors = colors {
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colorSpaceModel = colorSpace.model

            let gradientColors = colors.map { (color: UIColor) -> AnyObject? in
                let cgColor = color.cgColor
                let cgColorSpace = cgColor.colorSpace
                
                // The color's color space is RGB, simply add it.
                if cgColorSpace?.model.rawValue == colorSpaceModel.rawValue {
                    return cgColor as AnyObject?
                }
                
                // Convert to RGB. There may be a more efficient way to do this.
                var red: CGFloat = 0
                var blue: CGFloat = 0
                var green: CGFloat = 0
                var alpha: CGFloat = 0
                color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                return UIColor(red: red, green: green, blue: blue, alpha: alpha).cgColor as AnyObject?
            }
            
            // TODO: This is ugly. Surely there is a way to make this more concise.
            if let locations = locations {
                gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: locations)
            } else {
                gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: nil)
            }
        }
    }
    
    private func gradientColors() -> [UIColor]? {
        if tintAdjustmentMode == .dimmed {
            if let dimmedColors = dimmedColors {
                return dimmedColors
            }
            
            if automaticallyDims {
                if let colors = colors {
                    return colors.map {
                        var hue: CGFloat = 0
                        var brightness: CGFloat = 0
                        var alpha: CGFloat = 0
                        
                        $0.getHue(&hue, saturation: nil, brightness: &brightness, alpha: &alpha)
                        
                        return UIColor(hue: hue, saturation: 0, brightness: brightness, alpha: alpha)
                    }
                }
            }
        }
        
        return colors
    }
}

/*

class RadialGradientLayer: CALayer {
    
    override init(){
        
        super.init()
        
        needsDisplayOnBoundsChange = true
    }
    
    init(center:CGPoint,radius:CGFloat,colors:[CGColor]){
        
        self.center = center
        self.radius = radius
        self.colors = colors
        
        super.init()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init()
        
    }
    
    var center:CGPoint = CGPointMake(50,50)
    var radius:CGFloat = 20
    var colors:[CGColor] = [UIColor(red: 251/255, green: 237/255, blue: 33/255, alpha: 1.0).CGColor , UIColor(red: 251/255, green: 179/255, blue: 108/255, alpha: 1.0).CGColor]
    
    override func drawInContext(ctx: CGContext!) {
        
        CGContextSaveGState(ctx)
        
        var colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var locations:[CGFloat] = [0.0, 1.0]
        
        var gradient = CGGradientCreateWithColors(colorSpace, colors, [0.0,1.0])
        
        var startPoint = CGPointMake(0, self.bounds.height)
        var endPoint = CGPointMake(self.bounds.width, self.bounds.height)
        
        CGContextDrawRadialGradient(ctx, gradient, center, 0.0, center, radius, 0)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func ddd() {
        
        //A linear Gradient Consists of two colours: top colour and bottom colour
        let topColor = UIColor(red: 15.0/255.0, green: 118.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        let bottomColor = UIColor(red: 84.0/255.0, green: 187.0/255.0, blue: 187.0/255.0, alpha: 1.0)
        
        //Add the top and bottom colours to an array and setup the location of those two.
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [CGFloat] = [0.0, 1.0]
        
        CARadialGra
        
        //Create a Gradient CA layer
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
        
    }
    
}
 
 */











/*
 
 
 
 
 
 UIGraphicsBeginImageContext(self.view.frame.size)
 UIImage(named: "Cyan.jpg")?.drawInRect(self.view.bounds)
 
 let image: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
 
 UIGraphicsEndImageContext()
 
 self.view.backgroundColor = UIColor(patternImage: image)
 
 */
 
