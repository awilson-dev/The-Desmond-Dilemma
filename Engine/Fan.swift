//
//  Fan.swift
//  Engine
//
//  Created by Allen Wilson on 6/4/24.
//

public enum FanState {
    case off
    case slow
    case fast
}

public struct Fan {
    public let position: Vector
    public var state: FanState = .fast
    public var animation: Animation = .fanFast
    public let soundChannel: Int
    
    public init(position: Vector, soundChannel: Int) {
        self.position = position
        self.soundChannel = soundChannel
    }
}

public extension Fan {
    mutating func update(in world: inout World) {
        switch state {
        case .off:
            world.playSound(nil, at: position, in: soundChannel)
        case .slow:
            world.playSound(.fan, at: position, in: soundChannel)
        case .fast:
            world.playSound(.fan, at: position, in: soundChannel)
        }
    }
}

public extension Animation {
    static let fanOff = Animation(frames: [
        .fan1
    ], duration: 0)
    static let fanSlow = Animation(frames: [
        .fan1,
        .fan2,
        .fan3,
        .fan4
    ], duration: 0.3)
    static let fanFast = Animation(frames: [
        .fan1,
        .fan2,
        .fan3,
        .fan4
    ], duration: 0.17)
}
