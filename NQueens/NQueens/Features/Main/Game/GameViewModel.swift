//
//  GameViewModel.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

@Observable
final class GameViewModel {

    // MARK: - Properties

    private(set) var viewState: ViewState = .loaded

    var boardSize: Int {
        settingsService.boardSize
    }

    private let settingsService: ISettingsService
    private weak var homeCoordinatorDelegate: HomeCoordinatorDelegate?
    
    // MARK: - Init

    init(settingsService: ISettingsService, homeCoordinatorDelegate: HomeCoordinatorDelegate?) {
        self.settingsService = settingsService
        self.homeCoordinatorDelegate = homeCoordinatorDelegate
    }

    // MARK: - Public

    func handle(_ action: Action) {
        switch action {
        case .back:
            homeCoordinatorDelegate?.handle(.back)
        case .restart:
            homeCoordinatorDelegate?.handle(.restartGame)
        }
    }
}
