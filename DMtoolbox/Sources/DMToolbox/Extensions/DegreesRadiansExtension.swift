//
//  DegreesRadiansExtension.swift
//  CardGame
//
//  Created by Davorin on 18/06/2017.
//  Copyright © 2017 DavorinMadaric. All rights reserved.
//

import Foundation

extension Int {
    public var degreesToRadians: Double { return Double(self) * .pi / 180 }
}

extension FloatingPoint {
    public var degreesToRadians: Self { return self * .pi / 180 }
    public var radiansToDegrees: Self { return self * 180 / .pi }
}
