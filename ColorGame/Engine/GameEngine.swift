//
//  GameEngine.swift
//  ColorGame
//
//  Created by cobsccomp242p-066 on 2026-01-12.

import SwiftUI
import Combine
import UIKit

final class GameEngine: ObservableObject {

    @Published var grid: [[Tile]] = []
    @Published var selectedTiles: [Tile] = []
    @Published var score: Int = 0
    @Published var remainingTime: Int?
    @Published var collectedColors: [TileColor: Int] = [:]
    @Published var comboMultiplier: Int = 1
    @Published var lastScoreGained: Int = 0

    @Published var isProcessingMatch: Bool = false
    @Published var didWin: Bool = false
    @Published var isLevelOver: Bool = false

    @Published private(set) var config: LevelConfig

    private var timer: Timer?

    init(level: Int) {
        self.config = LevelTimeline.config(for: level)
        loadLevel(level)
    }

    var level: Int { config.level }

    func loadLevel(_ level: Int) {
        timer?.invalidate()

        config = LevelTimeline.config(for: level)
        score = 0
        selectedTiles.removeAll()
        collectedColors = [:]
        comboMultiplier = 1
        lastScoreGained = 0
        didWin = false
        isLevelOver = false
        isProcessingMatch = false

        setupGrid()
        startTimerIfNeeded()
    }

    func restartLevel() {
        loadLevel(config.level)
    }

    func setupGrid() {
        let pool = config.colorPool
        let size = config.gridSize

        grid = (0..<size).map { row in
            (0..<size).map { col in
                Tile(
                    color: pool.randomElement()!,
                    row: row,
                    col: col,
                    isVisible: true
                )
            }
        }
        selectedTiles.removeAll()
    }

    func select(tile: Tile) {
        guard !isProcessingMatch, !isLevelOver else { return }

        guard let last = selectedTiles.last else {
            selectedTiles = [tile]
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            return
        }

        let isAdjacent =
            abs(last.row - tile.row) <= 1 &&
            abs(last.col - tile.col) <= 1

        if isAdjacent && tile.color == last.color && !selectedTiles.contains(tile) {
            selectedTiles.append(tile)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } else {
            completeMatch()
            selectedTiles = [tile]
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }

    func completeMatch() {
        guard !isProcessingMatch, !isLevelOver else { return }

        guard selectedTiles.count >= config.minMatchCount else {
            selectedTiles.removeAll()
            comboMultiplier = 1
            return
        }

        isProcessingMatch = true

        let matched = selectedTiles
        selectedTiles.removeAll()

        if let c = matched.first?.color {
            collectedColors[c, default: 0] += matched.count
        }

        let lengthBonus = bonus(for: matched.count)
        let perTile = config.scorePerTile
        let gainedRaw = matched.count * perTile + lengthBonus

        comboMultiplier = min(comboMultiplier + 1, config.comboCap)
        let gained = gainedRaw * comboMultiplier
        lastScoreGained = gained

        for t in matched {
            grid[t.row][t.col].isVisible = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
            self.score += gained
            self.refillHiddenTiles()
            self.isProcessingMatch = false

            UIImpactFeedbackGenerator(style: .medium).impactOccurred()

            self.evaluateLevelState()
        }
    }

    private func bonus(for length: Int) -> Int {
        if length <= 3 { return 0 }
        if length == 4 { return 6 }
        if length == 5 { return 14 }
        if length == 6 { return 25 }
        return 40
    }

    private func refillHiddenTiles() {
        let size = config.gridSize
        let pool = config.colorPool

        for r in 0..<size {
            for c in 0..<size {
                if !grid[r][c].isVisible {
                    grid[r][c] = Tile(
                        color: pool.randomElement()!,
                        row: r,
                        col: c,
                        isVisible: true
                    )
                }
            }
        }
    }

    private func startTimerIfNeeded() {
        guard let limit = config.timeLimitSeconds else {
            remainingTime = nil
            return
        }

        remainingTime = limit
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] t in
            guard let self else { return }
            guard !self.isLevelOver else { t.invalidate(); return }

            if let time = self.remainingTime, time > 0 {
                self.remainingTime = time - 1
            } else {
                t.invalidate()
                self.failLevel()
            }
        }
    }

    private func objectivesMet() -> Bool {
        for obj in config.objectives {
            let have = collectedColors[obj.color, default: 0]
            if have < obj.required { return false }
        }
        return true
    }

    func evaluateLevelState() {
        guard !isLevelOver else { return }

        let scoreMet = score >= config.targetScore
        let colorsMet = objectivesMet()

        if scoreMet && colorsMet {
            winLevel()
        }
    }

    private func winLevel() {
        isLevelOver = true
        didWin = true
        timer?.invalidate()
    }

    private func failLevel() {
        isLevelOver = true
        didWin = false
        timer?.invalidate()
    }

    deinit {
        timer?.invalidate()
    }
}

