//
//  LevelResultPopup.swift
//  ColorGame
//
//  Created by yulanion 2026-01-19.
//

import SwiftUI

struct LevelResultPopup: View {
    let didWin: Bool
    let level: Int
    let score: Int
    let target: Int
    let objectives: [ColorObjective]
    let collected: [TileColor: Int]

    let accessibilityMode: AccessibilityMode   

    let onLevelMap: () -> Void
    let onReplay: () -> Void
    let onNext: () -> Void


    var body: some View {
        ZStack {
            Color.black.opacity(0.55).ignoresSafeArea()

            VStack(spacing: 12) {
                Text(didWin ? "Level Complete!" : "Try Again")
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                Text("Level \(level)")
                    .foregroundStyle(.white.opacity(0.85))

                VStack(spacing: 8) {
                    HStack {
                        Text("Score")
                        Spacer()
                        Text("\(score) / \(target)")
                            .monospacedDigit()
                    }
                    .foregroundStyle(.white.opacity(0.9))

                    ColorObjectiveView(
                        objectives: objectives,
                        collected: collected,
                        accessibilityMode: accessibilityMode
                    )


                }
                .padding(.top, 6)

                HStack(spacing: 10) {
                    Button(action: onLevelMap) {
                        Text("Level Map")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .background(Color.white.opacity(0.14), in: RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.white)

                    Button(action: onReplay) {
                        Text("Replay")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .background(Color.white.opacity(0.14), in: RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.white)
                }

                Button(action: onNext) {
                    Text("Next Level")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .background(didWin ? Color.white : Color.white.opacity(0.25), in: RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(didWin ? Color.primaryBackground : Color.white.opacity(0.6))
                .disabled(!didWin)
                .padding(.top, 2)
            }
            .padding(16)
            .background(Color.primaryBackground.opacity(0.95), in: RoundedRectangle(cornerRadius: 18))
            .padding(.horizontal, 18)
        }
    }
}

