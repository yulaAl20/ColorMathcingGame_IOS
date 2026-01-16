//
//  TileColor.swift
//  ColorGame
//
//  Created by Yulani on 2026-01-16.
//
import SwiftUI

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


