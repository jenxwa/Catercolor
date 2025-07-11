//
//  Models.swift
//  Catercolor
//
//  Created by Jennifer Warbeck on 11.07.25.
//

import SwiftUI

enum CaterpillarColor: String, CaseIterable {
    case red, green, blue, yellow
}

struct Caterpillar: Identifiable {
    let id = UUID()
    var color: CaterpillarColor
    var segments: [CaterpillarSegment]
}

struct CaterpillarSegment: Identifiable {
    let id = UUID()
    let color: Color
    let sizeMultiplier: CGFloat
}

struct CaterpillarAnimationState: Identifiable {
    let id = UUID()
    var offsetX: CGFloat = 0
    var offsetY: CGFloat = 0
    var rotation: Double = 0
    var opacity: Double = 1
    var wiggleX: CGFloat = 0
}



struct ColorBall: Identifiable {
    let id = UUID()
    let color: Color
    let correctCaterpillar: CaterpillarColor
    let sizeMultiplier: CGFloat // e.g., 0.9 to 1.1
}


struct GameResult {
    var totalBalls: Int = 0
    var correctMatches: [CaterpillarColor: Int] = [:]
    var incorrectMatches: [CaterpillarColor: Int] = [:]
}

