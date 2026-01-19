//
//  GameView.swift
//  ColorGame
//
//  Created by cobsccomp242p-066 on 2026-01-12.
import SwiftUI

struct GameView: View {
    @StateObject private var engine: GameEngine
    @Environment(\.dismiss) private var dismiss

    init(difficulty: Difficulty) {
        _engine = StateObject(wrappedValue: GameEngine(difficulty: difficulty))
    }

    var body: some View {
        VStack {
            header

            // 🟦 Grid ONLY (no lines)
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: engine.size),
                spacing: 4
            ) {
                ForEach(engine.grid.flatMap { $0 }) { tile in
                    if tile.isVisible {
                        TileView(
                            tile: tile,
                            isSelected: engine.selectedTiles.contains(tile)
                        )
                        .onTapGesture {
                            engine.select(tile: tile)
                        }
                    }
                }
            }
            .padding()

            // ✅ Simple combo multiplier UI
            if engine.comboMultiplier > 1 {
                Text("Combo x\(engine.comboMultiplier)")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .padding(.top, 6)
            }
        }
        .navigationBarHidden(true)
    }

    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
            }

            Spacer()

            VStack(spacing: 4) {
                Text("Score: \(engine.score)")
                Text("Level: \(engine.level)")
                    .opacity(0.85)
            }

            Spacer()

            if let time = engine.remainingTime {
                Text("⏱ \(formatTime(time))")
                    .monospacedDigit()
            }
        }
        .foregroundColor(.white)
        .padding()
    }

    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}
