//
//  DifficultyButton.swift
//  ColorGame
//
//  Created by Yulani on 2026-01-14.

import SwiftUI

struct DifficultyButton: View {
    let difficulty: Difficulty

    var body: some View {
        HStack {
            Text(difficulty.rawValue)
                .font(.title3.bold())

            Spacer()

            Text("\(difficulty.gridSize) × \(difficulty.gridSize)")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.08))
        )
        .foregroundColor(.white)
    }
}
