//
//  ColorObjectiveView.swift
//  ColorGame
//
//  Created by yulani on 2026-01-19.
//
import SwiftUI

struct ColorObjectiveView: View {
    let objectives: [ColorObjective]
    let collected: [TileColor: Int]
    let accessibilityMode: AccessibilityMode

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(objectives) { obj in
                let have = collected[obj.color, default: 0]
                let done = have >= obj.required

                HStack(spacing: 10) {
                    objectiveIcon(for: obj.color)

                    Text(labelText(for: obj.color, have: have, required: obj.required))
                        .foregroundStyle(.white.opacity(0.9))
                        .font(.subheadline)
                        .monospacedDigit()

                    Spacer()

                    Image(systemName: done ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(done ? .green : .white.opacity(0.35))
                }
            }
        }
        .padding(10)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
    }

    private func labelText(for color: TileColor, have: Int, required: Int) -> String {
        if accessibilityMode == .shapesOnly {
            return "Shape \(have)/\(required)"
        } else {
            return "\(color.title) \(have)/\(required)"
        }
    }

    @ViewBuilder
    private func objectiveIcon(for color: TileColor) -> some View {
        switch accessibilityMode {
        case .shapesOnly:
            color.anyShape()
                .fill(.white)
                .frame(width: 24, height: 24)
                .overlay(
                    color.anyShape()
                        .stroke(.black, lineWidth: 2.5)
                )

        case .normal:
            Circle()
                .fill(color.color)
                .frame(width: 14, height: 14)
                .overlay(
                    Circle().stroke(.white.opacity(0.25), lineWidth: 1)
                )

        case .highContrast:
            Circle()
                .fill(color.highContrastColor)
                .frame(width: 16, height: 16)
                .overlay(
                    Circle().stroke(.black.opacity(0.9), lineWidth: 2)
                )
        }
    }
}
