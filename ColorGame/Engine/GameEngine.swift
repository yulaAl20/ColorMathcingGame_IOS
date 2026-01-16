//
//  HomeView.swift
//  ColorGame
//
//  Created by cobsccomp242p-066 on 2026-01-12.

import SwiftUI
import Combine



final class GameEngine: ObservableObject {



    @Published var grid: [[Tile]] = []
    @Published var selectedTiles: [Tile] = []
    @Published var score: Int = 0
    @Published var remainingTime: Int?
    @Published var lastScoreGained: Int = 0
    @Published var isInvalidSelection: Bool = false
    @Published var collectedColors: [TileColor: Int] = [:]

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
                    col: col
                )
            }
        }
        selectedTiles.removeAll()
    }

    //Tile Selection

    func select(tile: Tile) {
        guard let last = selectedTiles.last else {
            selectedTiles = [tile]
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
            // Auto-complete previous selection
            completeMatch()
            selectedTiles = [tile]
        }
    }

    func completeMatch() {
        guard selectedTiles.count >= 3 else {
            // Not enough tiles to match
            selectedTiles.removeAll()
            return
        }

        // Calculate score
        let gained = selectedTiles.count * 10
        score += gained
        lastScoreGained = gained

        // Update collected colors for hard level
        if let color = selectedTiles.first?.color {
            collectedColors[color, default: 0] += selectedTiles.count
        }

        // Remove matched tiles and refill
        for tile in selectedTiles {
            grid[tile.row][tile.col].color = TileColor.allCases.randomElement()!
        }

        // Clear selection
        selectedTiles.removeAll()
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
