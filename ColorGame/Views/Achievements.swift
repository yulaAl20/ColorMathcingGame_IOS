//
//  Achievements.swift
//  ColorGame
//
//  Created by Yulani on 2026-01-16.
//

import Foundation

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let achieved: Bool
}
