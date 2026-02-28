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
        case game
    }
    
    enum Sheet: String, Identifiable, Equatable {
        case leaderboard
        var id: String { self.rawValue }
    }
    
    enum Action {
        case openGame
        case presentLeaderboard
        case back
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
            settingsService: dependencies.settingsService,
            homeCoordinatorDelegate: self
        )
    }
}

// MARK: - HomeNavigationDelegate

extension HomeCoordinator: HomeCoordinatorDelegate {
    func handle(_ action: Action) {
        switch action {
        case .openGame:
            push(.game)
            
        case .presentLeaderboard:
            present(.leaderboard)
            
        case .back:
            pop()
        }
    }
}
