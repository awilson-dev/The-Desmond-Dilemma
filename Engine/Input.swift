//
//  Input.swift
//  Engine
//
//  Created by Allen Wilson on 6/4/24.
//

public struct Input {
    public var velocityVector: Vector
    public var rotation: Rotation
    public var isFiring: Bool
    
    public init(velocityVector: Vector, rotation: Rotation, isFiring: Bool) {
        self.velocityVector = velocityVector
        self.rotation = rotation
        self.isFiring = isFiring
    }
}
