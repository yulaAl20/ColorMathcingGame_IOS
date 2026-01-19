//
//  TileColor.swift
//  ColorGame
//
//  Created by Yulani on 2026-01-16.
//
import SwiftUI

enum TileColor: CaseIterable {
    case red, green, blue, yellow, purple

    var color: Color {
        switch self {
        case .red: return .red
        case .green: return .green
        case .blue: return .blue
        case .yellow: return .yellow
        case .purple: return .purple
        }
    }
}
