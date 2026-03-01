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
        VStack(spacing: LayoutToken.spacing0) {
            headerSection
            logoSection
            boardSizeSelector
            historyGameCard
            playButton
                .padding(.top, LayoutToken.padding24)

            Spacer(minLength: LayoutToken.padding24)
        }
    }
    
    private var headerSection: some View {
        HStack {
            streakBadge
            Spacer()
        }
        .padding(.horizontal, LayoutToken.padding24)
        .padding(.top, LayoutToken.padding14)
        .padding(.bottom, LayoutToken.padding8)
    }
    
    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [ColorToken.green, ColorToken.greenDark],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: .avatarSize, height: .avatarSize)
                .shadow(color: ColorToken.green.opacity(0.4), radius: .shadowRadiusS, y: 2)
        }
    }
    
    private var streakBadge: some View {
        HStack(spacing: LayoutToken.spacing6) {
            Text("🔥")
                .font(TextToken.iconM)
            Text("\(viewModel.streakCount)")
                .font(TextToken.titleS)
                .foregroundStyle(ColorToken.yellow)
        }
        .padding(.horizontal, LayoutToken.padding14)
        .padding(.vertical, LayoutToken.padding6)
        .background(ColorToken.backgroundCard, in: Capsule())
    }
    
    // MARK: - Logo
    
    private var logoSection: some View {
        VStack(spacing: LayoutToken.spacing4) {
            Text("♛")
                .font(.system(size: .logoSize))
                .shadow(color: ColorToken.green.opacity(0.3), radius: .shadowRadiusM, y: 2)
                .foregroundStyle(ColorToken.textPrimary)
            
            Text("N-Queens")
                .font(TextToken.headM)
                .foregroundStyle(ColorToken.textPrimary)
        }
        .padding(.top, LayoutToken.padding24)
        .padding(.bottom, LayoutToken.padding8)
    }
    
    // MARK: - Board Size Selector
    
    private var boardSizeSelector: some View {
        Button {
            viewModel.handle(.openBoardSizeSheet)
        } label: {
            HStack(spacing: LayoutToken.spacing10) {
                Image("chessboard")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: LayoutToken.cornerRadius12))

                VStack(alignment: .leading, spacing: LayoutToken.spacing2) {
                    Text("Board size")
                        .font(TextToken.captionM)
                        .foregroundStyle(ColorToken.textSecondary)
                    
                    Text("\(viewModel.boardSize)×\(viewModel.boardSize)")
                        .font(TextToken.titleM)
                        .foregroundStyle(ColorToken.textPrimary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .font(TextToken.titleS)
                    .foregroundStyle(ColorToken.textSecondary)
            }
            .padding(.horizontal, LayoutToken.padding18)
            .padding(.vertical, LayoutToken.padding16)
            .background(ColorToken.backgroundCard, in: RoundedRectangle(cornerRadius: LayoutToken.cornerRadius16))
            .overlay(
                RoundedRectangle(cornerRadius: LayoutToken.cornerRadius16)
                    .stroke(ColorToken.backgroundElevated, lineWidth: .borderWidth)
            )
        }
        .padding(.horizontal, LayoutToken.padding20)
        .padding(.top, LayoutToken.padding12)
    }

    // MARK: - Play Button
    
    private var playButton: some View {
        Button {
            viewModel.handle(.openGame)
        } label: {
            Text("Start game")
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
        .padding(.horizontal, LayoutToken.padding20)
        .padding(.top, LayoutToken.padding12)
    }

    // MARK: - Action Cards
    
    private var historyGameCard: some View {
        Button {
            viewModel.handle(.presentGameHistory)
        } label: {
            HomeActionCard(
                iconBackground: Color(hex: "0A84FF").opacity(0.12),
                iconBorder: Color(hex: "0A84FF").opacity(0.2),
                icon: "📋",
                title: "Game history",
                subtitle: "\(viewModel.totalGames) games · \(viewModel.totalWins) wins",
                valueText: viewModel.winRateFormatted,
                valueColor: ColorToken.green,
                unitText: "wins"
            )
        }
        .padding(.horizontal, LayoutToken.padding20)
        .padding(.top, LayoutToken.padding12)
    }
}

// MARK: - Subviews

private struct HomeActionCard: View {
    
    let iconBackground: Color
    let iconBorder: Color
    let icon: String
    let title: String
    let subtitle: String
    let valueText: String
    let valueColor: Color
    let unitText: String
    
    var body: some View {
        HStack(spacing: LayoutToken.spacing14) {
            ZStack {
                RoundedRectangle(cornerRadius: LayoutToken.cornerRadius12)
                    .fill(iconBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: LayoutToken.cornerRadius12)
                            .stroke(iconBorder, lineWidth: .borderWidth)
                    )
                
                Text(icon)
            }
            .frame(width: .touchTarget, height: .touchTarget)
            
            VStack(alignment: .leading, spacing: LayoutToken.spacing2) {
                Text(title)
                    .font(TextToken.bodyM)
                    .foregroundStyle(ColorToken.textPrimary)
                Text(subtitle)
                    .font(TextToken.captionM)
                    .foregroundStyle(ColorToken.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: LayoutToken.spacing1) {
                Text(valueText)
                    .font(TextToken.titleS)
                    .foregroundStyle(valueColor)
                Text(unitText)
                    .font(TextToken.captionXS)
                    .foregroundStyle(ColorToken.textSecondary)
            }
        }
        .padding(.horizontal, LayoutToken.padding18)
        .padding(.vertical, LayoutToken.padding16)
        .background(ColorToken.backgroundCard, in: RoundedRectangle(cornerRadius: LayoutToken.cornerRadius16))
        .overlay(
            RoundedRectangle(cornerRadius: LayoutToken.cornerRadius16)
                .stroke(ColorToken.backgroundElevated, lineWidth: .borderWidth)
        )
    }
}

// MARK: - Constants

private extension CGFloat {
    static let touchTarget: CGFloat = 44
    static let avatarSize: CGFloat = 40
    static let logoSize: CGFloat = 64
    static let borderWidth: CGFloat = 1
    static let shadowRadiusS: CGFloat = 6
    static let shadowRadiusM: CGFloat = 16
}
