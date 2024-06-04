//
//  Textures.swift
//  Engine
//
//  Created by Allen Wilson on 6/4/24.
//

public enum Texture: String, CaseIterable {
    case wall, wall2
    case crackWall, crackWall2
    case slimeWall, slimeWall2
    case door, door2
    case doorjamb, doorjamb2
    case floor
    case crackFloor
    case ceiling
    case monster
    case monsterWalk1, monsterWalk2
    case monsterScratch1, monsterScratch2, monsterScratch3, monsterScratch4
    case monsterScratch5, monsterScratch6, monsterScratch7, monsterScratch8
    case monsterHurt, monsterDeath1, monsterDeath2, monsterDead
    case pistol
    case pistolFire1, pistolFire2, pistolFire3, pistolFire4
    case switch1, switch2, switch3, switch4
    case elevatorFloor, elevatorCeiling, elevatorSideWall, elevatorBackWall
    case sky
    case fence
    case openCeiling
    case grassFloor
    case fan1, fan2, fan3, fan4
    case gateLeft, gateRight
}

public struct Textures {
    private let textures: [Texture: Bitmap]
}

public extension Textures {
    init(loader: (String) -> Bitmap) {
        var textures = [Texture: Bitmap]()
        for texture in Texture.allCases {
            textures[texture] = loader(texture.rawValue)
        }
        self.init(textures: textures)
    }
    
    subscript(_ texture: Texture) -> Bitmap {
        return textures[texture]!
    }
}
