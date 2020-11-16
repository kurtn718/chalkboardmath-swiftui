//
//  MathGameModel.swift
//  ChalkboardMath-SwiftUI
//
//  Created by Kurt Niemi on 10/16/20.
//

import Foundation

class MathGameModel: ObservableObject {
    var selectedNumbers: Set<Int> = Set<Int>()
    var flashcardMode:Bool = false
    var playChalkman:Bool = false
}

