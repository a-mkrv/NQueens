//
//  HomeCoordinator.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

// MARK: - Coordinator

protocol HomeCoordinatorDelegate: AnyObject {
    func handle(_ action: HomeCoordinator.Action)
}

@Observable
final class HomeCoordinator: FlowCoordinator<HomeCoordinator.Destination, HomeCoordinator.Sheet> {
    
    // MARK: - Navigation
    
    enum Destination: Hashable {
        case game(GameType)
        case gameHistory
    }
    
    enum Sheet: String, Identifiable, Equatable {
        case boardSize
        var id: String { self.rawValue }
    }
    
    enum Action {
        case openGame(GameType)
        case presentGameHistory
        case openBoardSizeSheet
        case back
        case dismissSheet
        case restartGame
    }
    
    // MARK: - Properties
    
    @ObservationIgnored
    lazy var homeViewModel: HomeViewModel = makeHomeViewModel()
    
    private let dependencies: AppDependencies
    
    // MARK: - Init
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - ViewModels Factory
    
    private func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            gameHistoryService: dependencies.gameHistoryService,
            settingsService: dependencies.settingsService,
            homeCoordinatorDelegate: self
        )
    }
    
    func makeGameHistoryViewModel() -> GameHistoryViewModel {
        GameHistoryViewModel(
            gameHistoryService: dependencies.gameHistoryService,
            settingsService: dependencies.settingsService,
            homeCoordinatorDelegate: self
        )
    }
    
    func makeGameViewModel(for mode: GameType) -> GameViewModel {
        GameViewModel(
            mode: mode,
            settingsService: dependencies.settingsService,
            homeCoordinatorDelegate: self
        )
    }
    
    func makeBoardSheetViewModel() -> BoardSheetViewModel {
        BoardSheetViewModel(settingsService: dependencies.settingsService, homeCoordinatorDelegate: self)
    }
}

// MARK: - HomeNavigationDelegate

extension HomeCoordinator: HomeCoordinatorDelegate {
    func handle(_ action: Action) {
        switch action {
        case .openGame(let mode):
            push(.game(mode))
        case .presentGameHistory:
            push(.gameHistory)
        case .openBoardSizeSheet:
            present(.boardSize)
        case .back:
            pop()
        case .dismissSheet:
            dismiss()
        case .restartGame:
            pop()
            push(.game(.new))
        }
    }
}
