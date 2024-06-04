//
//  Rect.swift
//  Engine
//
//  Created by Allen Wilson on 6/4/24.
//

public struct Rect {
    var min, max: Vector

    public init(min: Vector, max: Vector) {
        self.min = min
        self.max = max
    }
}
