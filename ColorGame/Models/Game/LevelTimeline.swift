//
//  LevelTimeline.swift
//  ColorGame
//
//  Created by yulani on 2026-01-19.
//

import Foundation

struct LevelTimeline {

    static func config(for level: Int) -> LevelConfig {
        let stage: GameStage
        if level <= 5 { stage = .easy }
        else if level <= 10 { stage = .medium }
        else { stage = .hard }

        let gridSize: Int
        let minMatch: Int
        let timeLimit: Int?
        let comboCap: Int
        let scorePerTile: Int

        switch stage {
        case .easy:
            gridSize = 6
            minMatch = 3
            timeLimit = (level <= 2) ? nil : 300
            comboCap = 3
            scorePerTile = 4
        case .medium:
            gridSize = 8
            minMatch = 3
            timeLimit = 240
            comboCap = 4
            scorePerTile = 5
        case .hard:
            gridSize = 10
            minMatch = 4
            timeLimit = hardTimeLimit(level: level)
            comboCap = 5
            scorePerTile = 6
        }

        let pool = colorPool(for: level, stage: stage)
        let objectives = LevelObjectiveGenerator.generate(level: level, stage: stage, pool: pool)
        let targetScore = targetScore(for: level, stage: stage)

        return LevelConfig(
            level: level,
            stage: stage,
            gridSize: gridSize,
            minMatchCount: minMatch,
            timeLimitSeconds: timeLimit,
            targetScore: targetScore,
            colorPool: pool,
            objectives: objectives,
            comboCap: comboCap,
            scorePerTile: scorePerTile
        )
    }

    static func targetScore(for level: Int, stage: GameStage) -> Int {
        switch stage {
        case .easy:
            return 220 + level * 70
        case .medium:
            return 350 + (level - 5) * 90
        case .hard:
            return 520 + (level - 10) * 120
        }
    }

    static func hardTimeLimit(level: Int) -> Int {
        var t = 180
        if level >= 20 {
            let steps = (level - 20) / 5
            t = max(120, 180 - steps * 5)
        }
        return t
    }

    static func colorPool(for level: Int, stage: GameStage) -> [TileColor] {
        switch stage {
        case .easy:
            return [.red, .green, .blue, .yellow]
        case .medium:
            return [.red, .green, .blue, .yellow, .purple]
        case .hard:
            var base: [TileColor] = [.red, .green, .blue, .yellow, .purple]
            if level >= 25 {
                base.append(.orange)
            }
            return base
        }
    }
}
