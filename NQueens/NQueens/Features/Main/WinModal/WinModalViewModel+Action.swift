//
//  WinModalViewModel+Action.swift
//  NQueens
//
//  Created by Anton Makarov on 01.03.2026.
//

import Foundation

extension WinModalViewModel {

    // MARK: - ViewState

    enum ViewState: Equatable {
        case loaded
    }

    // MARK: - Action

    enum Action {
        case dismiss
    }
}
