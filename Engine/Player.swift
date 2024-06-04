//
//  Player.swift
//  Engine
//
//  Created by Allen Wilson on 6/4/24.
//

public struct Player {
    public let radius: Double = 0.5
    
    public var position: Vector
    public var velocity: Vector
    
    public init(position: Vector) {
        self.position = position
        self.velocity = Vector(x: 1, y: 1)
    }
}

public extension Player {
    var rect: Rect {
        let halfSize = Vector(x: radius, y: radius)
        return Rect(min: position - halfSize, max: position + halfSize)
    }
}
