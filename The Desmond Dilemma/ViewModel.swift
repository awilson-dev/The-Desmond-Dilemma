//
//  ViewModel.swift
//  The Desmond Dilemma
//
//  Created by Allen Wilson on 6/4/24.
//

import SwiftUI
import Engine

class ViewModel: ObservableObject {
    @Published var velocityVector: Vector = Vector(x: 0, y: 0)
    @Published var rotation: Double = 0.0
    @Published var direction: Vector = Vector(x: 1, y: 0)
    @Published var lastFiredTime: Double = 0.0
    
    static let shared = ViewModel()
}
