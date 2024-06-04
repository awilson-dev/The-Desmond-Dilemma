//
//  Tile.swift
//  Engine
//
//  Created by Allen Wilson on 6/4/24.
//

public enum Tile: Int, Decodable {
    case floor
    case wall
    case crackWall
    case slimeWall
    case crackFloor
    case elevatorFloor
    case elevatorSideWall
    case elevatorBackWall
    case fence
    case grassFloor
    case gateLeft
    case gateRight
}

public extension Tile {
    var isWall: Bool {
        switch self {
        case .wall, .crackWall, .slimeWall, .elevatorSideWall, .elevatorBackWall, .fence, .gateLeft, .gateRight:
            return true
        case .floor, .crackFloor, .elevatorFloor, .grassFloor:
            return false
        }
    }
    
    var needsSkyTexture: Bool {
        switch self {
        case .fence, .grassFloor, .gateLeft, .gateRight:
            return true
        case .floor, .wall, .crackWall, .slimeWall, .crackFloor, .elevatorFloor, .elevatorSideWall, .elevatorBackWall:
            return false
        }
    }
    
    var textures: [Texture] {
        switch self {
        case .floor:
            return [.floor, .ceiling]
        case .crackFloor:
            return [.crackFloor, .ceiling]
        case .wall:
            return [.wall, .wall2]
        case .crackWall:
            return [.crackWall, .crackWall2]
        case .slimeWall:
            return [.slimeWall, .slimeWall2]
        case .elevatorSideWall:
            return [.elevatorSideWall, .elevatorSideWall]
        case .elevatorBackWall:
            return [.elevatorBackWall, .elevatorBackWall]
        case .elevatorFloor:
            return [.elevatorFloor, .elevatorCeiling]
        case .fence:
            return [.fence, .fence]
        case .grassFloor:
            return [.grassFloor, .openCeiling]
        case .gateLeft:
            return [.gateLeft, .gateLeft]
        case .gateRight:
            return [.gateRight, .gateRight]
        }
    }
}
