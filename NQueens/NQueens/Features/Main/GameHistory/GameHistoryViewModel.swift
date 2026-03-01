//
//  GameHistoryViewModel.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

@Observable
final class GameHistoryViewModel {

    // MARK: - Properties

    private(set) var viewState: ViewState = .loaded
    
    var games: [GameHistoryItem] = []

    private weak var homeCoordinatorDelegate: HomeCoordinatorDelegate?

    // MARK: - Init

    init(homeCoordinatorDelegate: HomeCoordinatorDelegate?) {
        self.homeCoordinatorDelegate = homeCoordinatorDelegate
    }

    // MARK: - Public

    func handle(_ action: Action) {
        switch action {
        case .back:
            homeCoordinatorDelegate?.handle(.back)
        case .selectGame:
            homeCoordinatorDelegate?.handle(.openGame)
        }
    }
}
