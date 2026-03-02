//
//  FlowCoordinator.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

@Observable
class FlowCoordinator<Destination: Hashable, Sheet: Identifiable & Hashable> {
    
    // MARK: - State
    
    var path: [Destination] = []
    var sheet: Sheet?
    
    // MARK: - Stack Navigation
    
    func push(_ destination: Destination) {
        path.append(destination)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeAll()
    }
    
    // MARK: - Sheet Navigation
    
    func present(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func dismiss() {
        sheet = nil
    }
    
    // MARK: - Reset
    
    func resetNavigation() {
        sheet = nil
        path.removeAll()
    }
}
