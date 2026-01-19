//
//  HomeView.swift
//  ColorGame
//
//  Created by cobsccomp242p-066 on 2026-01-12.
import SwiftUI

struct HomeView: View {
    @StateObject private var profileStore = PlayerProfileStore()

    @State private var nameInput: String = ""
    @State private var showNameSheet: Bool = false

    @State private var accessibilityMode: AccessibilityMode = .normal

    var body: some View {
        ZStack {
            Color.primaryBackground.ignoresSafeArea()

            VStack(spacing: 28) {
                VStack(spacing: 12) {
                    Image(systemName: "square.grid.3x3.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.purple)

                    Text("Color Tap")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    Text("Tap on the same colored tiles to score points")
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 22)
                }

                Text("Player: \(profileStore.profile?.username ?? "Not set")  •  High Score: \(profileStore.profile?.highScore ?? 0)")
                    .foregroundStyle(.white.opacity(0.85))
                    .font(.subheadline)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Accessibility")
                        .foregroundStyle(.white.opacity(0.9))
                        .font(.headline)

                    Picker("Accessibility", selection: $accessibilityMode) {
                        ForEach(AccessibilityMode.allCases) { mode in
                            Text(mode.title).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal, 24)

                VStack(spacing: 14) {
                    ForEach(Difficulty.allCases, id: \.self) { level in
                        NavigationLink {
                            GameView(
                                difficulty: level,
                                profileStore: profileStore,
                                accessibilityMode: accessibilityMode
                            )
                        } label: {
                            DifficultyButton(difficulty: level)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            if profileStore.profile == nil {
                                showNameSheet = true
                            }
                        })
                    }
                }
                .padding(.horizontal, 32)

                Spacer(minLength: 10)
            }
            .padding(.top, 22)
        }
        .onAppear {
            if profileStore.profile == nil {
                showNameSheet = true
            }
        }
        .sheet(isPresented: $showNameSheet) {
            nameSheet
        }
    }

    private var nameSheet: some View {
        ZStack {
            Color.primaryBackground.ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Enter your player name")
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                TextField("e.g., Yulani", text: $nameInput)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)

                Button {
                    profileStore.setName(nameInput)
                    showNameSheet = false
                } label: {
                    Text("Continue")
                        .font(.headline)
                        .foregroundStyle(Color.primaryBackground)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 20)
                }
                .disabled(nameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                Spacer()
            }
            .padding(.top, 24)
        }
        .presentationDetents([.medium])
    }
}
