//
//  ContentView.swift
//  The Desmond Dilemma
//
//  Created by Allen Wilson on 6/3/24.
//

import SwiftUI
import Engine

struct ContentView: View {
    @State var image = NSImage(size: NSSize(width: 0, height: 0))
    @State var world = World()
    @State var lastFrameTime = CACurrentMediaTime()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(nsImage: image)
                    .resizable()
                    .interpolation(.none)
            }
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 1 / 60, repeats: true) { _ in
                    let timeStep = CACurrentMediaTime() - lastFrameTime
                    lastFrameTime = CACurrentMediaTime()
                    
                    world.update(timeStep: timeStep)
                    
                    var renderer = Renderer(width: Int(geometry.size.height / 2), height: Int(geometry.size.height / 2))
                    renderer.draw(world)
                    
                    image = NSImage(bitmap: renderer.bitmap)!
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
