//
//  ColorObjective.swift
//  ColorGame
//
//  Created by yulani on 2026-01-19.
//

import Foundation

struct ColorObjective: Codable, Hashable, Equatable, Identifiable {
    let id: String
    let color: TileColor
    let required: Int

    init(color: TileColor, required: Int) {
        self.color = color
        self.required = required
        self.id = "\(color)-\(required)"
    }
}
