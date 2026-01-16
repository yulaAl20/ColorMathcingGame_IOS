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
    let row: Int
    let col: Int
}
