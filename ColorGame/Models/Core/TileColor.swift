//
//  TileColor.swift
//  ColorGame
//
//  Created by Yulani on 2026-01-16.
//
import SwiftUI

enum TileColor: CaseIterable, Hashable, Codable {
    case red, green, blue, yellow, purple, orange

    var color: Color {
        switch self {
        case .red: return .red
        case .green: return .green
        case .blue: return .blue
        case .yellow: return .yellow
        case .purple: return .purple
        case .orange: return .orange
        }
    }

    var highContrastColor: Color {
        switch self {
        case .red: return Color(red: 1.0, green: 0.0, blue: 0.15)
        case .green: return Color(red: 0.0, green: 1.0, blue: 0.35)
        case .blue: return Color(red: 0.0, green: 0.55, blue: 1.0)
        case .yellow: return Color(red: 1.0, green: 0.9, blue: 0.0)
        case .purple: return Color(red: 0.7, green: 0.25, blue: 1.0)
        case .orange: return Color(red: 1.0, green: 0.45, blue: 0.0)
        }
    }

    var title: String {
        switch self {
        case .red: return "Red"
        case .green: return "Green"
        case .blue: return "Blue"
        case .yellow: return "Yellow"
        case .purple: return "Purple"
        case .orange: return "Orange"
        }
    }

    func anyShape() -> AnyShape {
        switch self {
        case .red:
            return AnyShape(Circle())

        case .green:
            
            return AnyShape(RoundedRectangle(cornerRadius: 4))

        case .blue:
            return AnyShape(TriangleShape())

        case .yellow:
            return AnyShape(DiamondShape())

        case .purple:
            
            return AnyShape(Rectangle())

        case .orange:
            return AnyShape(RoundedRectangle(cornerRadius: 0))
        }
    }

}


