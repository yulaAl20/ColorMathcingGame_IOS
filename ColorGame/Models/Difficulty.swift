//
//  Difficulty.swift
//  ColorGame
//
//  Created by yulani on 2026-01-16.
//
import Foundation

enum Difficulty: String, CaseIterable, Identifiable {
    case easy
    case medium
    case hard

    var id: String { rawValue }

    var gridSize: Int {
        switch self {
        case .easy: return 6
        case .medium: return 8
        case .hard: return 10
        }
    }

    var timeLimit: Int? {
        switch self {
        case .easy: return nil
        case .medium: return 600   // 10 minutes
        case .hard: return 300     // 5 minutes
        }
    }

    var targetScore: Int {
        switch self {
        case .easy: return 300
        case .medium: return 600
        case .hard: return 900
        }
    }
}


