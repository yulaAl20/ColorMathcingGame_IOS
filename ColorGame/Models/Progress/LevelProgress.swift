//
//  LevelProgress.swift
//  ColorGame
//
//  Created by yulani on 2026-01-19.
//

import Foundation

struct LevelProgress: Codable, Equatable {
    var highestUnlockedLevel: Int
    var completedLevels: Set<Int>
    var bestScores: [Int: Int]

    static let empty = LevelProgress(highestUnlockedLevel: 1, completedLevels: [], bestScores: [:])
}
