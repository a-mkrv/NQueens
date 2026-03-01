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
        case onAppear
        case back
        case selectGame(GameHistoryItemModel)
    }
}
