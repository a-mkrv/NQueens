//
//  AppCoordinatorView.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

struct AppCoordinatorView: View {
    
    // MARK: - Properties

    @State private var coordinator: AppCoordinator
    
    // MARK: - Init

    init(dependencies: AppDependencies) {
        _coordinator = State(wrappedValue: AppCoordinator(dependencies: dependencies))
    }
    
    // MARK: - Body

    var body: some View {
        HomeCoordinatorView(coordinator: coordinator.homeCoordinator)
    }
}
