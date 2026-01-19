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
    @Published var lastScoreGained: Int = 0
    @Published var isInvalidSelection: Bool = false
    @Published var collectedColors: [TileColor: Int] = [:]
    @Published var level: Int = 1
    @Published var isProcessingMatch: Bool = false

    // ✅ New: combo
    @Published var comboMultiplier: Int = 1

    let difficulty: Difficulty
    let size: Int
    private var timer: Timer?

    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        self.size = difficulty.gridSize
        setupGrid()
        startTimer()
    }

    func setupGrid() {
        grid = (0..<size).map { row in
            (0..<size).map { col in
                Tile(
                    color: TileColor.allCases.randomElement()!,
                    row: row,
                    col: col,
                    isVisible: true
                )
            }
        }
        selectedTiles.removeAll()
        comboMultiplier = 1
    }

    func select(tile: Tile) {
        guard !isProcessingMatch else { return }

        guard let last = selectedTiles.last else {
            selectedTiles = [tile]
            isInvalidSelection = false
            return
        }

        let isAdjacent =
            abs(last.row - tile.row) <= 1 &&
            abs(last.col - tile.col) <= 1

        if isAdjacent &&
            tile.color == last.color &&
            !selectedTiles.contains(tile) {

            selectedTiles.append(tile)
            isInvalidSelection = false
        } else {
            // ✅ This is what makes score add AFTER you tap another tile
            completeMatch()
            selectedTiles = [tile]
        }
    }

    func completeMatch() {
        // ✅ "Color threshold" for hard is implemented here
        guard selectedTiles.count >= difficulty.minMatchCount else {
            selectedTiles.removeAll()
            comboMultiplier = 1
            return
        }

        isProcessingMatch = true

        let matchedTiles = selectedTiles

        // ✅ combo multiplier: grows with streak, capped to keep UI sane
        comboMultiplier = min(comboMultiplier + 1, 5)

        let base = matchedTiles.count * 10 * level
        let gained = base * comboMultiplier
        lastScoreGained = gained

        // Track collected colors
        if let color = matchedTiles.first?.color {
            collectedColors[color, default: 0] += matchedTiles.count
        }

        // Hide matched tiles
        for tile in matchedTiles {
            grid[tile.row][tile.col].isVisible = false
        }

        selectedTiles.removeAll()

        // ✅ Add score after a short effect delay (optional)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.score += gained
            self.levelUpIfNeeded()
            self.refillHiddenTiles()
            self.isProcessingMatch = false

            // ✅ Haptic feedback (simple)
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }

    private func refillHiddenTiles() {
        for row in 0..<size {
            for col in 0..<size {
                if !grid[row][col].isVisible {
                    grid[row][col] = Tile(
                        color: TileColor.allCases.randomElement()!,
                        row: row,
                        col: col,
                        isVisible: true
                    )
                }
            }
        }
    }

    private func levelUpIfNeeded() {
        if score >= level * 300 {
            level += 1
        }
    }

    private func startTimer() {
        guard let limit = difficulty.timeLimit else { return }
        remainingTime = limit

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] t in
            guard let self else { return }

            if let time = self.remainingTime, time > 0 {
                self.remainingTime = time - 1
            } else {
                t.invalidate()
            }
        }
    }

    deinit {
        timer?.invalidate()
    }
}
