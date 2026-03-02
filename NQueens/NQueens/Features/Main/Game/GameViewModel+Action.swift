//
//  GameViewModel+Action.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import Foundation

extension GameViewModel {

    // MARK: - ViewState

    enum ViewState: Equatable {
        case loaded
    }

    // MARK: - Action

    enum Action {
        case back
        case restart
        case tapCell(QueenPosition)
        case toggleHint
        case setQueenStyle(QueenStyle)
        case playAgain
    }
}
