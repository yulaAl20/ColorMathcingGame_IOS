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

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(tile.color.color.gradient)
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.white, lineWidth: isSelected ? 3 : 1)
            }
    }
}

