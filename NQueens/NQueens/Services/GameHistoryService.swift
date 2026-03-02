//
//  GameHistoryService.swift
//  NQueens
//
//  Created by Anton Makarov on 01.03.2026.
//

import Foundation

protocol IGameHistoryService {
    var gamesCount: Int { get }
    var streakCount: Int { get }
    
    var games: [GameHistoryItemModel] { get }
    
    func addGame(_ item: GameHistoryItemModel)
    func clearAllGames()
}

@Observable
final class GameHistoryService: IGameHistoryService {
    
    // MARK: - Properties
    
    private enum Storage {
        static let historyKey = "gameHistory"
    }
    
    var gamesCount: Int {
        games.count
    }
    
    var streakCount: Int {
        let calendar = Calendar.current
        let days = Set(games.map { calendar.startOfDay(for: $0.date) })
        guard var current = days.max() else { return 0 }
        var count = 0
        while days.contains(current) {
            count += 1
            current = calendar.date(byAdding: .day, value: -1, to: current) ?? current
        }
        return count
    }
    
    var games: [GameHistoryItemModel]
    
    init() {
        self.games = Self.loadFromStorage()
    }
    
    // MARK: - Public
    
    func addGame(_ item: GameHistoryItemModel) {
        games.insert(item, at: 0)
        updateStorage()
    }
    
    func clearAllGames() {
        games = []
        updateStorage()
    }
    
    // MARK: - Local Storage
    
    private func updateStorage() {
        guard let data = try? JSONEncoder().encode(games) else { return }
        UserDefaults.standard.set(data, forKey: Storage.historyKey)
    }
    
    private static func loadFromStorage() -> [GameHistoryItemModel] {
        guard let data = UserDefaults.standard.data(forKey: Storage.historyKey),
              let decoded = try? JSONDecoder().decode([GameHistoryItemModel].self, from: data) else {
            return []
        }
        return decoded
    }
}
