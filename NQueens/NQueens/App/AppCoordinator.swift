//
//  AppCoordinator.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

@Observable
final class AppCoordinator {
    
    // MARK: - Properties

    private let dependencies: AppDependencies
    
    private(set) var homeCoordinator: HomeCoordinator

    // MARK: - Init

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        self.homeCoordinator = HomeCoordinator(dependencies: dependencies)
    }
}
