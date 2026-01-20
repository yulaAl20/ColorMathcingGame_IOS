//
//  LevelModels.swift
//  ColorGame
//
//  Created by Yulani on 2026-01-19.
//

import Foundation

enum GameStage: String, Codable {
    case easy
    case medium
    case hard
}

struct LevelConfig: Codable, Equatable {
    let level: Int
    let stage: GameStage
    let gridSize: Int
    let minMatchCount: Int
    let timeLimitSeconds: Int?
    let targetScore: Int
    let colorPool: [TileColor]
    let objectives: [ColorObjective]
    let comboCap: Int
    let scorePerTile: Int
}
