//
//  AccessibilityMode.swift
//  ColorGame
//
//  Created by Yulani on 2026-01-19.
//
import Foundation

enum AccessibilityMode: String, CaseIterable, Identifiable {
    case normal
    case shapesOnly
    case highContrast

    var id: String { rawValue }

    var title: String {
        switch self {
        case .normal: return "Normal"
        case .shapesOnly: return "Shapes"
        case .highContrast: return "Contrast"
        }
    }
}
