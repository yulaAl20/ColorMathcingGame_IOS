//
//  PlayerProfileStore.swift
//  ColorGame
//
//  Created by Yulani on 2026-01-19.
//
import Combine
import Foundation
import SwiftUI

final class PlayerProfileStore: ObservableObject {
    @Published var profile: PlayerProfile? {
        didSet { save() }
    }

    private let key = "player_profile_v1"

    init() {
        load()
    }

    func setName(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        if var existing = profile {
            existing.username = trimmed
            profile = existing
        } else {
            profile = PlayerProfile(username: trimmed, highScore: 0)
        }
    }

    func updateHighScoreIfNeeded(_ score: Int) {
        guard var p = profile else { return }
        if score > p.highScore {
            p.highScore = score
            profile = p
        }
    }

    private func save() {
        guard let profile else { return }
        do {
            let data = try JSONEncoder().encode(profile)
            UserDefaults.standard.set(data, forKey: key)
        } catch { }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            profile = nil
            return
        }
        do {
            profile = try JSONDecoder().decode(PlayerProfile.self, from: data)
        } catch {
            profile = nil
        }
    }
}
