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

    // MARK: - SortOrder

    enum SortOrder: String, CaseIterable, Equatable {
        case date = "Date"
        case moves = "Moves"
        case time = "Time"
        case efficiency = "Efficiency"
    }

    // MARK: - Action

    enum Action {
        case onAppear
        case back
        case openSortModal
        case selectSortOrder(SortOrder)
        case dismissSortModal
        case selectSizeFilter(Int?)
        case openClearConfirm
        case dismissClearConfirm
        case clearAllGames
        case startGame
        case selectGame(GameHistoryItemModel)
    }
}
