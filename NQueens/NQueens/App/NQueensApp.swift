//
//  NQueensApp.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

@main
struct NQueensApp: App {
    
    // MARK: - Properties

    private let dependencies = AppDependencies()
    
    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(dependencies: dependencies)
        }
    }
}
