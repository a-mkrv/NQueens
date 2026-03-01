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
    private(set) var games: [GameHistoryItemModel] = []

    private let gameHistoryService: IGameHistoryService
    
    private weak var homeCoordinatorDelegate: HomeCoordinatorDelegate?

    // MARK: - Init

    init(gameHistoryService: IGameHistoryService,
         homeCoordinatorDelegate: HomeCoordinatorDelegate?) {
        self.gameHistoryService = gameHistoryService
        self.homeCoordinatorDelegate = homeCoordinatorDelegate
    }

    // MARK: - Public

    func handle(_ action: Action) {
        switch action {
        case .onAppear:
            loadGames()
        case .back:
            homeCoordinatorDelegate?.handle(.back)
        case .selectGame(let game):
            homeCoordinatorDelegate?.handle(.openGame(.replay(game)))
        }
    }

    // MARK: - Private

    private func loadGames() {
        games = gameHistoryService.games
    }
}
