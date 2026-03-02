//
//  GameHistoryView.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

struct GameHistoryView: View {
    
    @Bindable var viewModel: GameHistoryViewModel
    
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
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.handle(.onAppear)
        }
        .sheet(isPresented: $viewModel.isSortModalPresented) {
            SelectorSheetView(
                title: "Sort by",
                items: Array(GameHistoryViewModel.SortOrder.allCases),
                selectedItem: viewModel.sortOrder,
                itemTitle: {
                    $0.rawValue
                },
                onSelect: {
                    viewModel.handle(.selectSortOrder($0))
                },
                onDismiss: {
                    viewModel.handle(.dismissSortModal)
                }
            )
            .presentationDetents([.height(LayoutToken.sheetHeight)])
            .presentationDragIndicator(.visible)
        }
        .confirmationDialog("Clear History", isPresented: $viewModel.isClearConfirmPresented, titleVisibility: .visible) {
            Button("Clear", role: .destructive) {
                viewModel.handle(.clearAllGames)
            }
            Button("Cancel", role: .cancel) {
                viewModel.handle(.dismissClearConfirm)
            }
        } message: {
            Text("Are you sure?")
        }
    }
    
    // MARK: - Loaded
    
    private var loadedView: some View {
        VStack(spacing: LayoutToken.spacing0) {
            headerSection
            
            if !viewModel.games.isEmpty {
                sizeFilterTagsSection
            }
            contentSection
        }
    }
    
    private var headerSection: some View {
        ZStack {
            Text("Game History")
                .font(TextToken.headM)
                .foregroundStyle(ColorToken.textPrimary)
            
            HStack {
                navBarButton(icon: "chevron.left", action: .back)
                
                Spacer()
                
                HStack(spacing: LayoutToken.spacing0) {
                    if !viewModel.games.isEmpty {
                        navBarButton(icon: "trash", action: .openClearConfirm)
                    }
                    navBarButton(icon: "arrow.up.arrow.down", action: .openSortModal)
                }
            }
        }
        .padding(.horizontal, LayoutToken.padding16)
        .padding(.top, LayoutToken.padding14)
        .padding(.bottom, LayoutToken.padding8)
    }
    
    private func navBarButton(icon: String, action: GameHistoryViewModel.Action) -> some View {
        Button {
            viewModel.handle(action)
        } label: {
            Image(systemName: icon)
                .font(TextToken.navButton)
                .foregroundStyle(ColorToken.textPrimary)
                .frame(squared: .imageSize)
        }
    }
    
    // MARK: - Tags
    
    private var sizeFilterTagsSection: some View {
        HStack(spacing: LayoutToken.spacing8) {
            ForEach(viewModel.sizeFilterOptions, id: \.self) { option in
                Button {
                    viewModel.handle(.selectSizeFilter(option))
                } label: {
                    Text(option.map { "\($0)" } ?? "All")
                        .font(TextToken.titleS)
                        .foregroundStyle(viewModel.selectedSizeFilter == option ? .white : ColorToken.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, LayoutToken.padding8)
                        .background(
                            viewModel.selectedSizeFilter == option
                            ? ColorToken.green
                            : ColorToken.backgroundCard,
                            in: Capsule()
                        )
                        .overlay(
                            Capsule()
                                .stroke(ColorToken.backgroundElevated, lineWidth: viewModel.selectedSizeFilter == option ? 0 : .borderWidth)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, LayoutToken.padding20)
        .padding(.vertical, LayoutToken.padding12)
    }
    
    // MARK: - Content Section
    
    @ViewBuilder
    private var contentSection: some View {
        if viewModel.isEmpty {
            emptyStateView
        } else {
            gamesListView
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: LayoutToken.spacing20) {
            Text("♛")
                .font(.system(size: CGFloat.logoSize))
                .foregroundStyle(ColorToken.textSecondary.opacity(0.5))
            
            Text("No Games Yet")
                .font(TextToken.bodyM)
                .foregroundStyle(ColorToken.textSecondary)
            
            PrimaryButton(size: .large, title: "Start Game") {
                viewModel.handle(.startGame)
            }
            .padding(.horizontal, LayoutToken.padding24)
            .padding(.top, LayoutToken.padding8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var gamesListView: some View {
        ScrollView {
            LazyVStack(spacing: LayoutToken.spacing10) {
                ForEach(viewModel.filteredGames) { game in
                    Button {
                        viewModel.handle(.selectGame(game))
                    } label: {
                        GameHistoryRow(game: game)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, LayoutToken.padding20)
            .padding(.vertical, LayoutToken.padding12)
            .padding(.bottom, LayoutToken.padding24)
        }
    }
}

// MARK: - Constants

private extension CGFloat {
    static let imageSize: CGFloat = 44
    static let borderWidth: CGFloat = 1
    static let logoSize: CGFloat = 64
}
