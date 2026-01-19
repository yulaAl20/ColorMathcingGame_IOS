//
//  HomeView.swift
//  ColorGame
//
//  Created by cobsccomp242p-066 on 2026-01-12.

import SwiftUI

struct ContentView: View {
    @State private var username: String = "Player1" // Default username
    @State private var highScore: Int = 0
    
    var body: some View {
        NavigationStack {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }

                ProfileView(username: username, highScore: highScore)
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }

                AchievementsView()
                    .tabItem {
                        Label("Achievements", systemImage: "star.fill")
                    }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct ProfileView: View {
    let username: String
    let highScore: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Username: \(username)")
                .font(.title2.bold())
                .foregroundColor(.white)
            
            Text("High Score: \(highScore)")
                .font(.title3)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryBackground.ignoresSafeArea())
    }
}

struct AchievementsView: View {
    
    let achievements: [Achievement] = [
        Achievement(title: "First Match", description: "Complete your first match", achieved: true),
        Achievement(title: "Score 500", description: "Reach 500 points", achieved: false),
        Achievement(title: "Hard Level", description: "Complete hard level", achieved: false)
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Achievements")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
            
            List(achievements) { achievement in
                HStack {
                    VStack(alignment: .leading) {
                        Text(achievement.title)
                            .font(.headline)
                        Text(achievement.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    if achievement.achieved {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "xmark.seal")
                            .foregroundColor(.red)
                    }
                }
                .listRowBackground(Color.primaryBackground)
            }
            .listStyle(.plain)
        }
        .padding()
        .background(Color.primaryBackground.ignoresSafeArea())
    }
}

#Preview {
    ContentView()
}
