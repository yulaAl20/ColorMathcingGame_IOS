//
//  LevelProgressStore.swift
//  ColorGame
//
//  Created by yulani on 2026-01-19.
//
import Foundation
import Combine

final class LevelProgressStore: ObservableObject {

    @Published var progress: LevelProgress {
        didSet { save() }
    }

    private let key = "level_progress_v1"

    init() {
        if let loaded = Self.loadStatic(key: key) {
            self.progress = loaded
        } else {
            self.progress = .empty
        }
    }

    func isUnlocked(_ level: Int) -> Bool {
        level <= progress.highestUnlockedLevel
    }

    func isCompleted(_ level: Int) -> Bool {
        progress.completedLevels.contains(level)
    }

    func bestScore(for level: Int) -> Int {
        progress.bestScores[level] ?? 0
    }

    func markCompleted(level: Int, score: Int) {
        progress.completedLevels.insert(level)

        let currentBest = progress.bestScores[level] ?? 0
        if score > currentBest {
            progress.bestScores[level] = score
        }

        if level >= progress.highestUnlockedLevel {
            progress.highestUnlockedLevel = level + 1
        }
    }

    func recordAttempt(level: Int, score: Int) {
        let currentBest = progress.bestScores[level] ?? 0
        if score > currentBest {
            progress.bestScores[level] = score
        }
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(progress)
            UserDefaults.standard.set(data, forKey: key)
        } catch { }
    }

    
    private static func loadStatic(key: String) -> LevelProgress? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(LevelProgress.self, from: data)
    }
}
