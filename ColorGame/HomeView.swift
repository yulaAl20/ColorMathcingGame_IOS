//
//  HomeView.swift
//  ColorGame
//
//  Created by cobsccomp242p-066 on 2026-01-12.
import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color.primaryBackground.ignoresSafeArea()

            VStack(spacing: 40) {
                VStack(spacing: 12) {
                    Image(systemName: "square.grid.3x3.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.purple)

                    Text("Sweet Match")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    Text("Match identical tiles to score points")
                        .foregroundColor(.white.opacity(0.7))
                }

                VStack(spacing: 16) {
                    ForEach(Difficulty.allCases, id: \.self) { level in
                        NavigationLink {
                            GameView(difficulty: level)
                        } label: {
                            DifficultyButton(difficulty: level)
                        }
                    }
                }
                .padding(.horizontal, 32)
            }
        }
    }
}
