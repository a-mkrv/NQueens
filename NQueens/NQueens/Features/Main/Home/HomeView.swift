//
//  HomeView.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

struct HomeView: View {

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
        VStack(spacing: LayoutToken.spacing12) {
            headerSection
            logoSection
            boardSizeSelector
            gameHistoryCard
            playButton

            Spacer()

            bottomSection
        }
        .padding(.horizontal, LayoutToken.padding24)
    }

    private var headerSection: some View {
        HStack {
            Spacer()
            streakBadge
        }
    }

    private var streakBadge: some View {
        HStack(spacing: LayoutToken.spacing8) {
            Text("🔥")
                .font(TextToken.iconM)
            Text("\(viewModel.streakCount)")
                .font(TextToken.titleS)
                .foregroundStyle(ColorToken.yellow)
        }
        .padding(LayoutToken.padding12)
        .background(ColorToken.backgroundCard, in: Capsule())
    }

    // MARK: - Logo

    private var logoSection: some View {
        VStack(spacing: LayoutToken.spacing8) {
            Text("♛")
                .font(.system(size: .logoSize))
                .foregroundStyle(ColorToken.textPrimary)

            Text("N-Queens")
                .font(TextToken.headM)
                .foregroundStyle(ColorToken.textPrimary)
        }
        .padding(.top, LayoutToken.padding24)
        .padding(.bottom, LayoutToken.padding12)
    }

    // MARK: - Board Size Selector

    private var boardSizeSelector: some View {
        Button {
            viewModel.handle(.openBoardSizeSheet)
        } label: {
            HomeMenuCardView(
                image: .resource(name: "chessboard"),
                title: "Board Size",
                subtitle: "\(viewModel.boardSize)×\(viewModel.boardSize)",
                showsDisclosure: true
            )
        }
    }

    private var gameHistoryCard: some View {
        Button {
            viewModel.handle(.presentGameHistory)
        } label: {
            HomeMenuCardView(
                image: .emoji(name: "📋"),
                title: "Game History",
                subtitle: "\(viewModel.totalGames) games",
                showsDisclosure: false
            )
        }
    }

    // MARK: - Play Button

    private var playButton: some View {
        PrimaryButton(
            size: .large,
            title: "Start Game"
        ) {
            viewModel.handle(.openGame)
        }
        .padding(.top, LayoutToken.padding36)
    }

    // MARK: - Bottom Section

    private var bottomSection: some View {
        tipCard
    }

    private var tipCard: some View {
        HStack(alignment: .center, spacing: LayoutToken.spacing12) {
            Text("💡")
                .font(TextToken.titleS)

            Text("**Place N-Queens** on the board so that no two attack each other - no same row, column, or diagonal.")
                .font(TextToken.captionM)
                .foregroundStyle(ColorToken.textSecondary)
        }
        .padding(LayoutToken.padding12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ColorToken.backgroundCard.opacity(0.5), in: RoundedRectangle(cornerRadius: LayoutToken.cornerRadius12))
    }
}

// MARK: - Constants

private extension CGFloat {
    static let logoSize: CGFloat = 64
}
