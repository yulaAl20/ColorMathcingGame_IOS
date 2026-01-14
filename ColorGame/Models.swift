//
//  Models.swift
//  ColorGame
//
//  Created by Yulani on 2026-01-14.
//
import SwiftUI

// MARK: - Difficulty

enum Difficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var gridSize: Int {
        switch self {
        case .easy: return 6
        case .medium: return 8
        case .hard: return 10
        }
    }
}

// MARK: - Tile Color

enum TileColor: CaseIterable {
    case red, yellow, green, blue, purple

    var color: Color {
        switch self {
        case .red: return .red
        case .yellow: return .yellow
        case .green: return .green
        case .blue: return .blue
        case .purple: return .purple
        }
    }
}

// MARK: - Tile Model

struct Tile: Identifiable, Equatable {
    let id = UUID()
    var color: TileColor
    let row: Int
    let col: Int
}
