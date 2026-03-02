//
//  HomeViewModel+Action.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

extension HomeViewModel {

    // MARK: - ViewState

    enum ViewState: Equatable {
        case loaded
    }

    // MARK: - Action

    enum Action {
        case openGame
        case presentGameHistory
        case openBoardSizeSheet
    }
}
