//
//  GameHistoryView.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

struct GameHistoryView: View {
    
    let viewModel: GameHistoryViewModel
    
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
    }
    
    // MARK: - Loaded
    
    private var loadedView: some View {
        VStack(spacing: LayoutToken.spacing0) {
            headerSection
            listSection
        }
    }
    
    private var headerSection: some View {
        HStack {
            Button {
                viewModel.handle(.back)
            } label: {
                Image(systemName: "chevron.left")
                    .font(TextToken.navButton)
                    .foregroundStyle(ColorToken.textPrimary)
                    .frame(width: .touchTarget, height: .touchTarget)
            }
            
            Spacer()
            
            Text("Game History")
                .font(TextToken.headM)
                .foregroundStyle(ColorToken.textPrimary)
            
            Spacer()
            
            Button {
                viewModel.handle(.back)
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .font(TextToken.navButton)
                    .foregroundStyle(ColorToken.textPrimary)
                    .frame(width: .touchTarget, height: .touchTarget)
            }
        }
        .padding(.horizontal, LayoutToken.padding16)
        .padding(.top, LayoutToken.padding14)
        .padding(.bottom, LayoutToken.padding8)
    }
    
    private var listSection: some View {
        ScrollView {
            LazyVStack(spacing: LayoutToken.spacing10) {
                ForEach(viewModel.games) { game in
                    Button {
                        viewModel.handle(.selectGame(game))
                    } label: {
                        GameHistoryRow(
                            boardSize: game.boardSize,
                            duration: game.formattedDuration,
                            date: game.formattedDate,
                            efficiency: game.efficiency,
                            solvedWithHint: game.solvedWithHint,
                            moveCount: game.moveCount
                        )
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

// MARK: - GameHistoryRow Subview

private struct GameHistoryRow: View {
    
    let boardSize: Int
    let duration: String
    let date: String
    let efficiency: Int
    let solvedWithHint: Bool
    let moveCount: Int
    
    var body: some View {
        HStack(spacing: LayoutToken.spacing14) {
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
            VStack(alignment: .leading, spacing: LayoutToken.spacing2) {
                Text("\(boardSize)×\(boardSize)")
                    .font(TextToken.bodyM)
                    .foregroundStyle(ColorToken.textPrimary)
                Text(date)
                    .font(TextToken.captionS)
                    .foregroundStyle(ColorToken.textSecondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: LayoutToken.spacing1) {
                HStack {
                    if solvedWithHint {
                        Text("💡")
                            .font(TextToken.captionS)
                    }
                    
                    Text(duration)
                        .font(TextToken.titleS)
                        .foregroundStyle(ColorToken.green)
                }
                Text("\(moveCount) moves - \(efficiency)%")
                    .font(TextToken.captionS)
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
    static let borderWidth: CGFloat = 1
}
