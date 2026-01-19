//
//  GameView.swift
//  ColorGame
//
//  Created by cobsccomp242p-066 on 2026-01-12.
import SwiftUI

struct GameView: View {
    @StateObject private var engine: GameEngine
    @ObservedObject var profileStore: PlayerProfileStore
    let accessibilityMode: AccessibilityMode

    @Environment(\.dismiss) private var dismiss

    init(difficulty: Difficulty,
         profileStore: PlayerProfileStore,
         accessibilityMode: AccessibilityMode) {
        _engine = StateObject(wrappedValue: GameEngine(difficulty: difficulty))
        self.profileStore = profileStore
        self.accessibilityMode = accessibilityMode
    }

    var body: some View {
        VStack {
            header

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: engine.size),
                spacing: 4
            ) {
                ForEach(engine.grid.flatMap { $0 }) { tile in
                    if tile.isVisible {
                        TileView(
                            tile: tile,
                            isSelected: engine.selectedTiles.contains(tile),
                            accessibilityMode: accessibilityMode
                        )
                        .onTapGesture { engine.select(tile: tile) }
                    }
                }
            }
            .padding()

            if engine.comboMultiplier > 1 {
                Text("Combo x\(engine.comboMultiplier)")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .padding(.top, 6)
            }
        }
        .navigationBarHidden(true)
        .onChange(of: engine.score) { _, newScore in
            profileStore.updateHighScoreIfNeeded(newScore)
        }
    }

    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
            }

            Spacer()

            VStack(spacing: 4) {
                Text(profileStore.profile?.username ?? "Player")
                    .font(.headline)
                Text("Score: \(engine.score)  •  Level: \(engine.level)")
                    .opacity(0.85)
                    .font(.subheadline)
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
