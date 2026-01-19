//
//  TileView.swift
//  ColorGame
//
//  Created by Yulani on 2026-01-16.
//

import SwiftUI

struct TileView: View {
    let tile: Tile
    let isSelected: Bool
    let accessibilityMode: AccessibilityMode

    @State private var popScale: CGFloat = 1.0
    @State private var opacity: Double = 1.0

    var body: some View {
        let shape = tileShape

        let fillStyle: AnyShapeStyle = {
            switch accessibilityMode {
            case .highContrast:
                return AnyShapeStyle(tile.color.highContrastColor)
            case .normal, .shapesOnly:
                return AnyShapeStyle(tile.color.color.gradient)
            }
        }()

        ZStack {
            shape
                .fill(fillStyle)

            // ✅ Strong outline in High Contrast (this makes it clearly different)
            if accessibilityMode == .highContrast {
                shape
                    .stroke(.black.opacity(0.9), lineWidth: 3)
            } else {
                shape
                    .stroke(.white.opacity(0.18), lineWidth: 1)
            }

            if isSelected {
                shape
                    .stroke(.white, lineWidth: 3)
                    .shadow(color: .white.opacity(0.8), radius: 10)
            }
        }
        .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
        .aspectRatio(1, contentMode: .fit)
        .scaleEffect(popScale)
        .opacity(opacity)
        .onChange(of: isSelected) { animateSelection($0) }
        .onChange(of: tile.isVisible) { animateVisibility($0) }
    }

    private var tileShape: AnyShape {
        switch accessibilityMode {
        case .normal, .highContrast:
            return AnyShape(RoundedRectangle(cornerRadius: 10))
        case .shapesOnly:
            return tile.color.anyShape()
        }
    }

    private func animateSelection(_ selected: Bool) {
        if selected {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.5)) {
                popScale = 1.12
            }
        } else {
            withAnimation(.spring(response: 0.3)) {
                popScale = 1.0
            }
        }
    }

    private func animateVisibility(_ visible: Bool) {
        if !visible {
            withAnimation(.easeIn(duration: 0.25)) {
                popScale = 0.2
                opacity = 0
            }
        } else {
            popScale = 0.2
            opacity = 0
            withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                popScale = 1.0
                opacity = 1
            }
        }
    }
}

