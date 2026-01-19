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

    @State private var popScale: CGFloat = 1.0
    @State private var opacity: Double = 1.0

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(tile.color.color.gradient)
            .aspectRatio(1, contentMode: .fit)
            .scaleEffect(popScale)
            .opacity(opacity)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.white, lineWidth: isSelected ? 3 : 1)
                    .shadow(
                        color: .white.opacity(isSelected ? 0.8 : 0),
                        radius: isSelected ? 10 : 0
                    )
            }
            .onChange(of: isSelected) {
                if isSelected {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.5)) {
                        popScale = 1.12
                    }
                } else {
                    withAnimation(.spring(response: 0.3)) {
                        popScale = 1.0
                    }
                }
            }
            .onChange(of: tile.isVisible) {
                if !tile.isVisible {
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
}
