//
//  ProfileView.swift
//  ColorGame
//
//  Created by yulani on 2026-01-19.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var profileStore: PlayerProfileStore
    @ObservedObject var progressStore: LevelProgressStore
    let accessibilityMode: AccessibilityMode

    var body: some View {
        ZStack {
            Color.primaryBackground.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                Text("Profile")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                VStack(alignment: .leading, spacing: 10) {
                    row(title: "Player", value: profileStore.profile?.username ?? "Not set")
                    row(title: "High Score", value: "\(profileStore.profile?.highScore ?? 0)")
                    row(title: "Highest Unlocked Level", value: "\(progressStore.progress.highestUnlockedLevel)")
                    row(title: "Completed Levels", value: "\(progressStore.progress.completedLevels.count)")
                    row(title: "Accessibility", value: accessibilityMode.title)
                }
                .padding(14)
                .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))

                NavigationLink {
                    LevelMapView(
                        profileStore: profileStore,
                        progressStore: progressStore,
                        accessibilityMode: accessibilityMode
                    )
                } label: {
                    Text("View Levels")
                        .font(.headline)
                        .foregroundStyle(Color.primaryBackground)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 14))
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func row(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.white.opacity(0.8))
            Spacer()
            Text(value)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
        }
        .font(.subheadline)
    }
}
