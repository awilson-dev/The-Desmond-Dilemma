//
//  Sounds.swift
//  Engine
//
//  Created by Allen Wilson on 6/4/24.
//

public enum SoundName: String, CaseIterable {
    case pistolFire
    case ricochet
    case monsterHit
    case monsterGroan
    case monsterDeath
    case monsterSwipe
    case doorSlide
    case wallSlide
    case wallThud
    case switchFlip
    case playerDeath
    case playerWalk
    case squelch
    case fan
}

public struct Sound {
    public let name: SoundName?
    public let channel: Int?
    public let volume: Double
    public let pan: Double
    public let delay: Double
}
