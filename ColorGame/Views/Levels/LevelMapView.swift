//
//  LevelMapView.swift
//  ColorGame
//
//  Created by yulani on 2026-01-19.
//
import SwiftUI

struct LevelMapView: View {
    @ObservedObject var profileStore: PlayerProfileStore
    @ObservedObject var progressStore: LevelProgressStore
    let accessibilityMode: AccessibilityMode

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5)

    var body: some View {
        ZStack {
            Color.primaryBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Levels")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)

                    Text("Unlocked: \(progressStore.progress.highestUnlockedLevel)")
                        .foregroundStyle(.white.opacity(0.8))

                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(1...max(progressStore.progress.highestUnlockedLevel + 10, 30), id: \.self) { level in
                            levelCell(level)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func levelCell(_ level: Int) -> some View {
        let unlocked = progressStore.isUnlocked(level)
        let completed = progressStore.isCompleted(level)
        let best = progressStore.bestScore(for: level)

        let stage = LevelTimeline.config(for: level).stage
        let stageColor = stageAccent(stage)

        return NavigationLink {
            GameView(
                level: level,
                profileStore: profileStore,
                progressStore: progressStore,
                accessibilityMode: accessibilityMode
            )
        } label: {
            VStack(spacing: 6) {
                Text("\(level)")
                    .font(.headline)
                    .foregroundStyle(.white)

                if completed {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(.green)
                } else if unlocked {
                    Image(systemName: "play.fill")
                        .foregroundStyle(.white.opacity(0.85))
                } else {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.white.opacity(0.55))
                }

                Text(best > 0 ? "Best \(best)" : " ")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity, minHeight: 64)
            .padding(.vertical, 10)
            .background(
                stageColor.opacity(unlocked ? 0.22 : 0.12),
                in: RoundedRectangle(cornerRadius: 14)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(stageColor.opacity(unlocked ? 0.65 : 0.25), lineWidth: 1)
            )
            .opacity(unlocked ? 1.0 : 0.6)
        }
        .disabled(!unlocked)
    }

    private func stageAccent(_ stage: GameStage) -> Color {
        switch stage {
        case .easy:
            return .green
        case .medium:
            return .purple
        case .hard:
            return .orange
        }
    }
}
