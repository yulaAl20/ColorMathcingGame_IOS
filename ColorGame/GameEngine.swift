import SwiftUI
import Combine

final class GameEngine: ObservableObject {

    @Published var grid: [[Tile]] = []
    @Published var score = 0
    @Published var selectedTiles: [Tile] = []
    @Published var isInvalidSelection = false
    @Published var lastScoreGained = 0

    let size: Int

    init(difficulty: Difficulty) {
        self.size = difficulty.gridSize
        setupGrid()
    }

    func setupGrid() {
        score = 0
        selectedTiles.removeAll()
        lastScoreGained = 0

        grid = (0..<size).map { row in
            (0..<size).map { col in
                Tile(
                    color: TileColor.allCases.randomElement()!,
                    row: row,
                    col: col
                )
            }
        }
    }

    func select(tile: Tile) {
        guard let first = selectedTiles.first else {
            selectedTiles = [tile]
            return
        }

        guard tile.color == first.color else {
            invalidSelection()
            return
        }

        if selectedTiles.contains(tile) { return }

        if let last = selectedTiles.last, isConnected(last, tile) {
            selectedTiles.append(tile)
        }
    }

    func completeMatch() {
        guard selectedTiles.count >= 2 else {
            selectedTiles.removeAll()
            return
        }

        let gained = selectedTiles.count * 10
        score += gained
        lastScoreGained = gained

        for tile in selectedTiles {
            grid[tile.row][tile.col].color =
                TileColor.allCases.randomElement()!
        }

        selectedTiles.removeAll()
    }

    private func invalidSelection() {
        isInvalidSelection = true
        selectedTiles.removeAll()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isInvalidSelection = false
        }
    }

    private func isConnected(_ a: Tile, _ b: Tile) -> Bool {
        let r = abs(a.row - b.row)
        let c = abs(a.col - b.col)
        return r <= 1 && c <= 1 && !(r == 0 && c == 0)
    }
}
