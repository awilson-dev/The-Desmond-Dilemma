//
//  Tilemap.swift
//  Engine
//
//  Created by Allen Wilson on 6/4/24.
//

public struct MapData: Decodable {
    fileprivate let distanceFade: Double
    fileprivate let sky: Int
    fileprivate let width: Int
    fileprivate let tiles: [Tile]
    fileprivate let things: [Thing]
}

public struct Tilemap {
    public let distanceFade: Double
    public let sky: Texture
    public let width: Int
    private(set) var tiles: [Tile]
    public let things: [Thing]
    public let index: Int
    
    public init(_ map: MapData, index: Int) {
        self.tiles = map.tiles
        self.things = map.things
        self.width = map.width
        switch map.sky {
        case 0:
            self.sky = .sky
        default:
            self.sky = .sky
        }
        if map.distanceFade > 0 {
            self.distanceFade = map.distanceFade
        } else {
            self.distanceFade = 0.5
        }
        self.index = index
    }
}

public extension Tilemap {
    var height: Int {
        return tiles.count / width
    }
    
    var size: Vector {
        return Vector(x: Double(width), y: Double(height))
    }
    
    subscript(x: Int, y: Int) -> Tile {
        get { return tiles[y * width + x] }
        set { tiles[y * width + x] = newValue }
    }
    
    func tileCoords(at position: Vector, from direction: Vector) -> (x: Int, y: Int) {
        var offsetX = 0, offsetY = 0
        if position.x.rounded(.down) == position.x {
            offsetX = direction.x > 0 ? 0 : -1
        }
        if position.y.rounded(.down) == position.y {
            offsetY = direction.y > 0 ? 0 : -1
        }
        return (x: Int(position.x) + offsetX, y: Int(position.y) + offsetY)
    }
    
    func tile(at position: Vector, from direction: Vector) -> Tile {
        let (x, y) = tileCoords(at: position, from: direction)
        return self[x, y]
    }
    
    func closestFloorTile(to x: Int, _ y: Int) -> Tile? {
        for y in max(0, y - 1) ... min(height - 1, y + 1) {
            for x in max(0, x - 1) ... min(width - 1, x + 1) {
                let tile = self[x, y]
                if tile.isWall == false {
                    return tile
                }
            }
        }
        return nil
    }
    
    func hitTest(_ ray: Ray) -> Vector {
        var position = ray.origin
        let slope = ray.direction.x / ray.direction.y
        repeat {
            let edgeDistanceX, edgeDistanceY: Double
            if ray.direction.x > 0 {
                edgeDistanceX = position.x.rounded(.down) + 1 - position.x
            } else {
                edgeDistanceX = position.x.rounded(.up) - 1 - position.x
            }
            if ray.direction.y > 0 {
                edgeDistanceY = position.y.rounded(.down) + 1 - position.y
            } else {
                edgeDistanceY = position.y.rounded(.up) - 1 - position.y
            }
            let step1 = Vector(x: edgeDistanceX, y: edgeDistanceX / slope)
            let step2 = Vector(x: edgeDistanceY * slope, y: edgeDistanceY)
            if step1.length < step2.length {
                position += step1
            } else {
                position += step2
            }
        } while tile(at: position, from: ray.direction).isWall == false
        return position
    }
}
