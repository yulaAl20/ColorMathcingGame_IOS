//
//  GameView.swift
//  ColorGame
//
//  Created by cobsccomp242p-066 on 2026-01-12.

import SwiftUI

struct GameView: View {
    @StateObject private var engine: GameEngine

    @ObservedObject var profileStore: PlayerProfileStore
    @ObservedObject var progressStore: LevelProgressStore
    let accessibilityMode: AccessibilityMode

    @Environment(\.dismiss) private var dismiss
    @State private var goToLevelMap: Bool = false

    init(level: Int,
         profileStore: PlayerProfileStore,
         progressStore: LevelProgressStore,
         accessibilityMode: AccessibilityMode) {
        _engine = StateObject(wrappedValue: GameEngine(level: level))
        self.profileStore = profileStore
        self.progressStore = progressStore
        self.accessibilityMode = accessibilityMode
    }

    var body: some View {
        ZStack {
            Color.primaryBackground.ignoresSafeArea()

            VStack(spacing: 12) {
                header

                ColorObjectiveView(
                    objectives: engine.config.objectives,
                    collected: engine.collectedColors,
                    accessibilityMode: accessibilityMode
                )


                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: engine.config.gridSize),
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
                .padding(.horizontal)
                .padding(.bottom, 6)

                if engine.comboMultiplier > 1 {
                    Text("Combo x\(engine.comboMultiplier)")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .padding(.bottom, 6)
                }

                Spacer(minLength: 6)
            }

            if engine.isLevelOver {
                LevelResultPopup(
                    didWin: engine.didWin,
                    level: engine.level,
                    score: engine.score,
                    target: engine.config.targetScore,
                    objectives: engine.config.objectives,
                    collected: engine.collectedColors,
                    accessibilityMode: accessibilityMode,
                    onLevelMap: {
                        goToLevelMap = true
                    },
                    onReplay: {
                        engine.restartLevel()
                    },
                    onNext: {
                        guard engine.didWin else { return }
                        progressStore.markCompleted(level: engine.level, score: engine.score)
                        engine.loadLevel(engine.level + 1)
                    }
                )
            }

            NavigationLink(
                destination: LevelMapView(
                    profileStore: profileStore,
                    progressStore: progressStore,
                    accessibilityMode: accessibilityMode
                ),
                isActive: $goToLevelMap
            ) { EmptyView() }
        }
        .navigationBarHidden(true)
        .onChange(of: engine.score) { _, newScore in
            profileStore.updateHighScoreIfNeeded(newScore)
            progressStore.recordAttempt(level: engine.level, score: newScore)
        }
        .onChange(of: engine.isLevelOver) { _, over in
            if over && engine.didWin {
                progressStore.markCompleted(level: engine.level, score: engine.score)
            }
        }
    }

    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.white)
            }

            Spacer()

            VStack(spacing: 3) {
                Text(profileStore.profile?.username ?? "Player")
                    .foregroundStyle(.white)
                    .font(.headline)

                Text(stageText(engine.config.stage) + " • Level \(engine.level)")
                    .foregroundStyle(.white.opacity(0.85))
                    .font(.subheadline)

                Text("Score \(engine.score) / \(engine.config.targetScore)")
                    .foregroundStyle(.white.opacity(0.85))
                    .font(.subheadline)
                    .monospacedDigit()
            }

            Spacer()

            if let time = engine.remainingTime {
                Text(formatTime(time))
                    .foregroundStyle(.white)
                    .monospacedDigit()
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }

    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }

    private func stageText(_ stage: GameStage) -> String {
        switch stage {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }
}


