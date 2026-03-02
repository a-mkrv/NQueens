//
//  BoardSheetViewModel.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

@Observable
final class BoardSheetViewModel {
    
    // MARK: - Properties
    
    private(set) var viewState: ViewState = .loaded
    
    var availableSizes: [Int] {
        settingsService.availableSizes
    }
    
    var currentSize: Int {
        settingsService.boardSize
    }
    
    // MARK: - Dependencies

    private let settingsService: ISettingsService
    private weak var homeCoordinatorDelegate: HomeCoordinatorDelegate?
    
    // MARK: - Init
    
    init(
        settingsService: ISettingsService,
        homeCoordinatorDelegate: HomeCoordinatorDelegate?
    ) {
        self.settingsService = settingsService
        self.homeCoordinatorDelegate = homeCoordinatorDelegate
    }
    
    // MARK: - Public
    
    func handle(_ action: Action) {
        switch action {
        case .selectSize(let size):
            settingsService.updateBoardSize(size)
            homeCoordinatorDelegate?.handle(.dismissSheet)
        case .dismiss:
            homeCoordinatorDelegate?.handle(.dismissSheet)
        }
    }
}
