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
        case .openGame:
            homeCoordinatorDelegate?.handle(.openGame)
            
        case .presentLeaderboard:
            homeCoordinatorDelegate?.handle(.presentLeaderboard)
        }
    }
}
