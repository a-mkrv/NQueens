//
//  GameHistoryService.swift
//  NQueens
//
//  Created by Anton Makarov on 01.03.2026.
//

import SwiftUI

protocol IGameHistoryService {
    var gamesCount: Int { get }
    var streakCount: Int { get }
    
    var games: [GameHistoryItemModel] { get }
}

@Observable
final class GameHistoryService: IGameHistoryService {
    
    var gamesCount: Int {
        games.count
    }
    
    var streakCount: Int {
        Int.random(in: 0...10)
    }
    
    var games: [GameHistoryItemModel]
    
    init() {
        games = GameHistoryItemModel.mocks
    }
}
