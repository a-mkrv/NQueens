//
//  HomeView.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - Properties
    
    let viewModel: HomeViewModel
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            ColorToken.backgroundMain
                .ignoresSafeArea()
            
            switch viewModel.viewState {
            case .loaded:
                loadedView
            }
        }
    }
    
    // MARK: - Loaded
    
    private var loadedView: some View {
        Text("Home View")
    }
}
