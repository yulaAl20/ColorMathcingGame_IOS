//
//  Tile.swift
//  ColorGame
//
//  Created by Yulani on 2026-01-16.
//
import SwiftUI

struct Tile: Identifiable, Equatable {
    let id = UUID()
    var color: TileColor
    var row: Int
    var col: Int
    var isVisible: Bool = true

    static func == (lhs: Tile, rhs: Tile) -> Bool {
        lhs.id == rhs.id
    }
}

