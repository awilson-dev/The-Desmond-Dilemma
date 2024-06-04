//
//  Vector.swift
//  Engine
//
//  Created by Allen Wilson on 6/4/24.
//

import Foundation

public struct Vector: Equatable {
    public var x, y: Double
    
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

public extension Vector {
    var normalized: Vector {
        if length > 0 {
            return self / length
        }
        return self
    }
    
    var orthogonal: Vector {
        return Vector(x: -y, y: x)
    }
    
    var length: Double {
        return (x * x + y * y).squareRoot()
    }
    
    var angle: Double {
        if length == 0 {
            return 0
        }
        if x == 0 {
            if y > 0 {
                return .pi / 2
            } else {
                return .pi * 3 / 2
            }
        } else if y == 0 {
            if x > 0 {
                return 0
            } else {
                return .pi
            }
        }
        var angle = atan(y / x)
        if y <= 0 {
            angle += .pi
        }
        return angle
    }
    
    func dot(_ rhs: Vector) -> Double {
        return x * rhs.x + y * rhs.y
    }
    
    static func + (lhs: Vector, rhs: Vector) -> Vector {
        return Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func - (lhs: Vector, rhs: Vector) -> Vector {
        return Vector(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func * (lhs: Vector, rhs: Double) -> Vector {
        return Vector(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    
    static func / (lhs: Vector, rhs: Double) -> Vector {
        return Vector(x: lhs.x / rhs, y: lhs.y / rhs)
    }
    
    static func * (lhs: Double, rhs: Vector) -> Vector {
        return Vector(x: lhs * rhs.x, y: lhs * rhs.y)
    }
    
    static func / (lhs: Double, rhs: Vector) -> Vector {
        return Vector(x: lhs / rhs.x, y: lhs / rhs.y)
    }
    
    static func += (lhs: inout Vector, rhs: Vector) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
    
    static func -= (lhs: inout Vector, rhs: Vector) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }
    
    static func *= (lhs: inout Vector, rhs: Double) {
        lhs.x *= rhs
        lhs.y *= rhs
    }
    
    static func /= (lhs: inout Vector, rhs: Double) {
        lhs.x /= rhs
        lhs.y /= rhs
    }
    
    static prefix func - (rhs: Vector) -> Vector {
        return Vector(x: -rhs.x, y: -rhs.y)
    }
}
