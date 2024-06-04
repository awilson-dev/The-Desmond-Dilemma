//
//  Bitmap.swift
//  Engine
//
//  Created by Allen Wilson on 6/4/24.
//

public struct Bitmap {
    public private(set) var pixels: [Color]
    public let width, height: Int
    public let isOpaque: Bool
    
    public init(width: Int, pixels: [Color]) {
        self.width = width
        self.height = pixels.count / width
        self.pixels = pixels
        self.isOpaque = pixels.allSatisfy { $0.isOpaque }
    }
}

public extension Bitmap {
    subscript(x: Int, y: Int) -> Color {
        get { return pixels[y * width + x] }
        set {
            guard x >= 0, y >= 0, x < width, y < height else { return }
            pixels[y * width + x] = newValue
        }
    }
    
    subscript(normalized x: Double, y: Double) -> Color {
        return self[Int(x * Double(width)), Int(y * Double(height))]
    }
    
    init(width: Int, height: Int, color: Color) {
        self.pixels = Array(repeating: color, count: width * height)
        self.width = width
        self.height = height
        self.isOpaque = color.isOpaque
    }
    
    mutating func fill(rect: Rect, color: Color) {
        for y in Int(rect.min.y) ..< Int(rect.max.y) {
            for x in Int(rect.min.x) ..< Int(rect.max.x) {
                self[x, y] = color
            }
        }
    }
    
    mutating func drawLine(from: Vector, to: Vector, color: Color) {
        let difference = to - from
        let step: Vector
        let stepCount: Int
        if abs(difference.x) > abs(difference.y) {
            stepCount = Int(abs(difference.x).rounded(.up))
            let sign = difference.x > 0 ? 1.0 : -1.0
            step = Vector(x: 1, y: difference.y / difference.x) * sign
        } else {
            stepCount = Int(abs(difference.y).rounded(.up))
            let sign = difference.y > 0 ? 1.0 : -1.0
            step = Vector(x: difference.x / difference.y, y: 1) * sign
        }
        var point = from
        for _ in 0 ..< stepCount {
            self[Int(point.x), Int(point.y)] = color
            point += step
        }
    }
    
    mutating func drawColumn(_ sourceX: Int, of source: Bitmap, at point: Vector, height: Double, distance: Double = 1, fadeStrength: Double = 0.5) {
        let start = Int(point.y), end = Int((point.y + height).rounded(.up))
        let stepY = Double(source.height) / height
        var index = max(0, start) * width + Int(point.x)
        if source.isOpaque {
            for y in max(0, start) ..< min(self.height, end) {
                let sourceY = max(0, Double(y) - point.y) * stepY
                let sourceColor = source[sourceX, Int(sourceY)].darken(distance: distance, strength: fadeStrength)
                pixels[index] = sourceColor
                index += width
            }
        } else {
            for y in max(0, start) ..< min(self.height, end) {
                let sourceY = max(0, Double(y) - point.y) * stepY
                let sourceColor = source[sourceX, Int(sourceY)].darken(distance: distance, strength: fadeStrength)
                blendPixel(at: Int(point.x), y, with: sourceColor)
            }
        }
    }
    
    mutating func drawImage(_ source: Bitmap, at point: Vector, size: Vector) {
        let start = Int(point.x), end = Int(point.x + size.x)
        let stepX = Double(source.width) / size.x
        for x in max(0, start) ..< min(width, end) {
            let sourceX = (Double(x) - point.x) * stepX
            let outputPosition = Vector(x: Double(x), y: point.y)
            drawColumn(Int(sourceX), of: source, at: outputPosition, height: size.y)
        }
    }
    
    mutating func blendPixel(at x: Int, _ y: Int, with newColor: Color) {
        switch newColor.a {
        case 0:
            break
        case 255:
            self[x, y] = newColor
        default:
            let oldColor = self[x, y]
            let inverseAlpha = 1 - Double(newColor.a) / 255
            self[x, y] = Color(
                r: UInt8(Double(oldColor.r) * inverseAlpha) + newColor.r,
                g: UInt8(Double(oldColor.g) * inverseAlpha) + newColor.g,
                b: UInt8(Double(oldColor.b) * inverseAlpha) + newColor.b
            )
        }
    }
    
    mutating func tint(with color: Color, opacity: Double) {
        let alpha = min(1, max(0, Double(color.a) / 255 * opacity))
        let color = Color(
            r: UInt8(Double(color.r) * alpha),
            g: UInt8(Double(color.g) * alpha),
            b: UInt8(Double(color.b) * alpha),
            a: UInt8(255 * alpha)
        )
        for y in 0 ..< height {
            for x in 0 ..< width {
                blendPixel(at: x, y, with: color)
            }
        }
    }
}
