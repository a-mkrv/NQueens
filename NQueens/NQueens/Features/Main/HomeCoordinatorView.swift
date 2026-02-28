//
//  HomeCoordinatorView.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

struct HomeCoordinatorView: View {
    
    // MARK: - Properties
    
    private var coordinator: HomeCoordinator
    
    @State private var path: [HomeCoordinator.Destination] = []
    @State private var sheet: HomeCoordinator.Sheet?
    
    // MARK: - Init
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack(path: $path) {
            rootContent
                .navigationDestination(for: HomeCoordinator.Destination.self, destination: destination(for:))
                .sheet(item: $sheet, content: sheetContent(for:))
        }
        .bind(to: coordinator, path: $path, sheet: $sheet)
    }
    
    private var rootContent: some View {
        HomeView(viewModel: coordinator.homeViewModel)
    }
    
    // MARK: - Destination Factory
    
    @ViewBuilder
    private func destination(for route: HomeCoordinator.Destination) -> some View {
        switch route {
        case .game:
            Text("GameView")
        }
    }
    
    // MARK: - Sheet Factory
    
    @ViewBuilder
    private func sheetContent(for sheet: HomeCoordinator.Sheet) -> some View {
        switch sheet {
        case .leaderboard:
            Text("LeaderboardSheetView")
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}
