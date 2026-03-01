//
//  GameHistoryViewModel+Models.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import Foundation

extension GameHistoryViewModel {

    // MARK: - ViewState

    enum ViewState: Equatable {
        case loaded
    }

    // MARK: - Action

    enum Action {
        case back
        case selectGame(GameHistoryItem)
    }

    struct GameHistoryItem: Identifiable, Equatable {
        let id: String
        let boardSize: Int
        let durationSeconds: Int
        let date: Date
        let isWin: Bool
    }
}
