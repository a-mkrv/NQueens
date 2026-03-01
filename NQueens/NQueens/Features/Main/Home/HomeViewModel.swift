//
//  HomeViewModel.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

@Observable
final class HomeViewModel {
    
    // MARK: - Properties
    
    private(set) var viewState: ViewState = .loaded
    
    var boardSize: Int {
        settingsService.boardSize
    }
    
    var totalGames: Int {
        gameHistoryService.gamesCount
    }
    
    var streakCount: Int {
        gameHistoryService.streakCount
    }
    
    private let gameHistoryService: IGameHistoryService
    private let settingsService: ISettingsService
    
    private weak var homeCoordinatorDelegate: HomeCoordinatorDelegate?

    // MARK: - Init
    
    init(
        gameHistoryService: IGameHistoryService,
        settingsService: ISettingsService,
        homeCoordinatorDelegate: HomeCoordinatorDelegate?
    ) {
        self.gameHistoryService = gameHistoryService
        self.settingsService = settingsService
        self.homeCoordinatorDelegate = homeCoordinatorDelegate
    }
    
    // MARK: - Public
    
    func handle(_ action: Action) {
        switch action {
        case .openGame:
            homeCoordinatorDelegate?.handle(.openGame(.newGame))
        case .presentGameHistory:
            homeCoordinatorDelegate?.handle(.presentGameHistory)
        case .openBoardSizeSheet:
            homeCoordinatorDelegate?.handle(.openBoardSizeSheet)
        }
    }
}
