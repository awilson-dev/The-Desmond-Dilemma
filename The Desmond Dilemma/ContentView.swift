//
//  ContentView.swift
//  The Desmond Dilemma
//
//  Created by Allen Wilson on 6/3/24.
//

import SwiftUI
import Engine

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel.shared
    
    @State private var image = NSImage()
    
    private let levels = loadLevels()
    private let textures = loadTextures()
    
    @State private var world: World
    
    private let maximumTimeStep: Double = 1 / 20
    private let worldTimeStep: Double = 1 / 120
    @State private var lastFrameTime = CACurrentMediaTime()
    
    @State private var previousMouseLocation = NSPoint.zero
    var mouseLocation: NSPoint { NSEvent.mouseLocation }
    @State private var lastInputEvent = 0.0
    @State private var inputLagTimerStart = CACurrentMediaTime()
    @State private var deltaX = 0.0
    
    init() {
        self.world = World(map: levels[0])
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                Image(nsImage: image)
                    .interpolation(.none)
                    .resizable()
            }
            .background(KeyEventHandling())
            .onAppear {
                setUpAudio()
                Timer.scheduledTimer(withTimeInterval: 1.0 / 60, repeats: true) { timer in
                    update(timer, width: Int(geometry.size.width) / 2, height: Int(geometry.size.height) / 2)
                }
            }
            .onAppear {
                let point = NSPoint(x: NSScreen.main!.frame.width * 0.5, y: NSScreen.main!.frame.height * 0.5)
                CGWarpMouseCursorPosition(point)
                previousMouseLocation = mouseLocation
                NSCursor.hide()
                NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { event in
                    deltaX = event.deltaX
                    return event
                }
                NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown) { event in
                    viewModel.lastFiredTime = CACurrentMediaTime()
                    return nil
                }
            }
        }
    }
    
    func update(_ timer: Timer, width: Int, height: Int) {
        let timeStep = min(maximumTimeStep, CACurrentMediaTime() - lastFrameTime)
        var renderer = Renderer(width: width, height: height, textures: textures)
        
        DispatchQueue.main.async {
            if mouseLocation.x - previousMouseLocation.x != 0 {
                inputLagTimerStart = CACurrentMediaTime()
            }
            
            if CACurrentMediaTime() - inputLagTimerStart > 0.1 {
                deltaX = 0
                inputLagTimerStart = CACurrentMediaTime()
            }
        }
        
        viewModel.rotation = deltaX * 0.08
        let point = NSPoint(x: NSScreen.main!.frame.width * 0.5, y: NSScreen.main!.frame.height * 0.5)
        CGWarpMouseCursorPosition(point)
        previousMouseLocation = mouseLocation
        
        let rotation = viewModel.rotation * world.player.turningSpeed * worldTimeStep
        
        let input = Input(
            velocityVector: viewModel.velocityVector,
            rotation: Rotation(sine: sin(rotation), cosine: cos(rotation)),
            isFiring: viewModel.lastFiredTime > lastFrameTime
        )
        
        let worldSteps = (timeStep / worldTimeStep).rounded(.up)
        
        for _ in 0 ..< Int(worldSteps) {
            if let action = world.update(timeStep: timeStep / worldSteps, input: input) {
                switch action {
                case .loadLevel(let index):
                    let index = index % levels.count
                    world.setLevel(levels[index])
                    SoundManager.shared.clearAll()
                case .playSounds(let sounds):
                    for sound in sounds {
                        DispatchQueue.main.asyncAfter(deadline: .now() + sound.delay) {
                            guard let url = sound.name?.url else {
                                if let channel = sound.channel {
                                    SoundManager.shared.clearChannel(channel)
                                }
                                return
                            }
                            try? SoundManager.shared.play(
                                url,
                                channel: sound.channel,
                                volume: sound.volume,
                                pan: sound.pan
                            )
                        }
                    }
                }
            }
        }
        
        lastFrameTime = CACurrentMediaTime()

        renderer.draw(world)

        image = NSImage(bitmap: renderer.bitmap)!
    }
}

#Preview {
    ContentView()
}

public func loadLevels() -> [Tilemap] {
    let jsonURL = Bundle.main.url(forResource: "Levels", withExtension: "json")!
    let jsonData = try! Data(contentsOf: jsonURL)
    let levels = try! JSONDecoder().decode([MapData].self, from: jsonData)
    return levels.enumerated().map { Tilemap($0.element, index: $0.offset) }
}

private func loadTextures() -> Textures {
    return Textures(loader: { name in
        Bitmap(image: NSImage(named: name)!)!
    })
}

public extension SoundName {
    var url: URL? {
        return Bundle.main.url(forResource: rawValue, withExtension: "mp3")
    }
}

func setUpAudio() {
    for name in SoundName.allCases {
        precondition(name.url != nil, "Missing mp3 file for \(name.rawValue)")
    }
    _ = try? SoundManager.shared.preload(SoundName.allCases[0].url!)
}
