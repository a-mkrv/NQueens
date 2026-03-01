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
                hideIcons: true,
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
                .frame(width: .touchTarget, height: .touchTarget)
        }
    }

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
                                .stroke(ColorToken.backgroundElevated, lineWidth: viewModel.selectedSizeFilter == option ? 0 : 1)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, LayoutToken.padding20)
        .padding(.vertical, LayoutToken.padding12)
    }

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
                .font(.system(size: 48))
                .foregroundStyle(ColorToken.textSecondary.opacity(0.5))
            Text("No Games Yet")
                .font(TextToken.bodyM)
                .foregroundStyle(ColorToken.textSecondary)
            Button {
                viewModel.handle(.startGame)
            } label: {
                Text("Start Game")
                    .font(TextToken.titleL)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, LayoutToken.padding16 + LayoutToken.padding4)
                    .background(ColorToken.green, in: RoundedRectangle(cornerRadius: LayoutToken.cornerRadius16))
                    .overlay(
                        LinearGradient(
                            colors: [.white.opacity(0.12), .clear],
                            startPoint: .top,
                            endPoint: .center
                        )
                        .clipShape(RoundedRectangle(cornerRadius: LayoutToken.cornerRadius16))
                    )
                    .shadow(color: ColorToken.green.opacity(0.4), radius: .shadowRadiusM, y: 2)
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

// MARK: - GameHistoryRow

private struct GameHistoryRow: View {

    let game: GameHistoryItemModel

    var body: some View {
        HStack(spacing: LayoutToken.spacing14) {
            iconView
            gameInfoView
            Spacer()
            statsView
        }
        .padding(.horizontal, LayoutToken.padding18)
        .padding(.vertical, LayoutToken.padding16)
        .background(ColorToken.backgroundCard, in: RoundedRectangle(cornerRadius: LayoutToken.cornerRadius16))
        .overlay(
            RoundedRectangle(cornerRadius: LayoutToken.cornerRadius16)
                .stroke(ColorToken.backgroundElevated, lineWidth: .borderWidth)
        )
    }

    private var iconView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: LayoutToken.cornerRadius12)
                .fill(ColorToken.green.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: LayoutToken.cornerRadius12)
                        .stroke(ColorToken.green.opacity(0.2), lineWidth: .borderWidth)
                )
                .frame(width: .touchTarget, height: .touchTarget)
            Text("♛")
                .font(TextToken.iconL)
                .foregroundStyle(ColorToken.textPrimary)
        }
    }

    private var gameInfoView: some View {
        VStack(alignment: .leading, spacing: LayoutToken.spacing2) {
            Text("\(game.boardSize)×\(game.boardSize)")
                .font(TextToken.bodyM)
                .foregroundStyle(ColorToken.textPrimary)
            Text(game.formattedDate)
                .font(TextToken.captionS)
                .foregroundStyle(ColorToken.textSecondary)
        }
    }

    private var statsView: some View {
        VStack(alignment: .trailing, spacing: LayoutToken.spacing1) {
            HStack {
                if game.solvedWithHint {
                    Text("💡")
                        .font(TextToken.captionS)
                }
                Text(game.formattedDuration)
                    .font(TextToken.titleS)
                    .foregroundStyle(ColorToken.green)
            }
            Text("\(game.moveCount) moves - \(game.efficiency)%")
                .font(TextToken.captionS)
                .foregroundStyle(ColorToken.textSecondary)
        }
    }
}

// MARK: - Constants

private extension CGFloat {
    static let touchTarget: CGFloat = 44
    static let borderWidth: CGFloat = 1
    static let shadowRadiusM: CGFloat = 16
}
