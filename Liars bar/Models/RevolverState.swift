//
//  RevolverState.swift
//  Liars bar
//
//  Created by 김동준 on 2/5/25.
//

import Foundation

struct RevolverState {
    var playerName: String
    var bulletPosition: Int
    var currentPosition: Int
    var remainingChambers: Int
    var fired: Bool
    var message: String = ""
    var showMessage: Bool = false
    var redHoles: Set<Int> = []  // 빨간색으로 표시할 구멍들의 인덱스
    
    var probability: Double {
        return remainingChambers > 0 ? (1.0 / Double(remainingChambers)) * 100 : 0
    }
    
    mutating func addRandomRedHole() {
        var availableHoles = Set(0..<6)
        availableHoles.subtract(redHoles)
        if let randomHole = availableHoles.randomElement() {
            redHoles.insert(randomHole)
        }
    }
}
