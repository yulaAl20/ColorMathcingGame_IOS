//
//  LevelObjectiveGenerator.swift
//  ColorGame
//
//  Created by yulani on 2026-01-19.
//

import Foundation

struct LevelObjectiveGenerator {

    static func generate(level: Int, stage: GameStage, pool: [TileColor]) -> [ColorObjective] {
        let count: Int
        switch stage {
        case .easy: count = 1
        case .medium: count = 2
        case .hard: count = 3
        }

        let chosen = Array(pool.shuffled().prefix(count))

        let base: Int
        switch stage {
        case .easy: base = 18 + min(level, 5) * 2
        case .medium: base = 18 + min(max(level - 5, 1), 5) * 3
        case .hard: base = 18 + min(max(level - 10, 1), 20) * 2
        }

        let totalTarget = base * count

        return chosen.enumerated().map { idx, c in
            let share = max(12, (totalTarget / count) + (idx == 0 ? 3 : 0))
            return ColorObjective(color: c, required: share)
        }
    }
}
