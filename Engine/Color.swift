//
//  Color.swift
//  Engine
//
//  Created by Allen Wilson on 6/4/24.
//

public struct Color {
    public var r, g, b, a: UInt8
    
    public init(r: UInt8, g: UInt8, b: UInt8, a: UInt8 = 255) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
}

public extension Color {
    var isOpaque: Bool {
        return a == 255
    }
    
    static let clear = Color(r: 0, g: 0, b: 0, a: 0)
    static let black = Color(r: 0, g: 0, b: 0)
    static let white = Color(r: 255, g: 255, b: 255)
    static let gray = Color(r: 192, g: 192, b: 192)
    static let red = Color(r: 255, g: 0, b: 0)
    static let green = Color(r: 0, g: 255, b: 0)
    static let blue = Color(r: 0, g: 0, b: 255)
    
    func darken(distance: Double, strength: Double) -> Color {
        var color = self
        let invDistance = 1 / (1 + distance * strength)
        color.r = UInt8(Double(r) * invDistance)
        color.g = UInt8(Double(g) * invDistance)
        color.b = UInt8(Double(b) * invDistance)
        return color
    }
}
