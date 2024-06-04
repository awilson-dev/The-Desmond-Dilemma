//
//  KeyEventHandling.swift
//  The Desmond Dilemma
//
//  Created by Allen Wilson on 6/4/24.
//

import SwiftUI
import Engine

struct KeyEventHandling: NSViewRepresentable {
    class KeyView: NSView {
        override var acceptsFirstResponder: Bool { true }
        
        override func keyDown(with event: NSEvent) {
            if !event.isARepeat {
                if event.keyCode == 0 {
                    //a
                    ViewModel.shared.velocityVector += Vector(x: -1, y: 0)
                } else if event.keyCode == 2 {
                    //d
                    ViewModel.shared.velocityVector += Vector(x: 1, y: 0)
                } else if event.keyCode == 1 {
                    //s
                    ViewModel.shared.velocityVector += Vector(x: 0, y: -1)
                } else if event.keyCode == 13 {
                    //w
                    ViewModel.shared.velocityVector += Vector(x: 0, y: 1)
                }
            }
        }
        
        override func keyUp(with event: NSEvent) {
            if !event.isARepeat {
                if event.keyCode == 0 {
                    //a
                    ViewModel.shared.velocityVector -= Vector(x: -1, y: 0)
                } else if event.keyCode == 2 {
                    //d
                    ViewModel.shared.velocityVector -= Vector(x: 1, y: 0)
                } else if event.keyCode == 1 {
                    //s
                    ViewModel.shared.velocityVector -= Vector(x: 0, y: -1)
                } else if event.keyCode == 13 {
                    //w
                    ViewModel.shared.velocityVector -= Vector(x: 0, y: 1)
                }
            }
        }
    }
    
    func makeNSView(context: Context) -> NSView {
        let view = KeyView()
        DispatchQueue.main.async { // wait till next event cycle
            view.window?.makeFirstResponder(view)
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}
