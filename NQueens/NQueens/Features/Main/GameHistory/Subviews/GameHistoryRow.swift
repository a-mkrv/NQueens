//
//  GameHistoryRow.swift
//  NQueens
//
//  Created by Anton Makarov on 02.03.2026.
//

import SwiftUI

struct GameHistoryRow: View {
    
    // MARK: - Properties
    
    let game: GameHistoryItemModel
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: LayoutToken.spacing14) {
            iconView
            gameInfoView
            Spacer()
            statsView
        }
        .padding(.horizontal, LayoutToken.padding18)
        .padding(.vertical, LayoutToken.padding16)
        .cardStyle()
    }
    
    // MARK: - Subviews
    
    private var iconView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: LayoutToken.cornerRadius12)
                .fill(ColorToken.green.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: LayoutToken.cornerRadius12)
                        .stroke(ColorToken.green.opacity(0.2), lineWidth: .borderWidth)
                )
            Text("♛")
                .font(TextToken.iconL)
                .foregroundStyle(ColorToken.textPrimary)
        }
        .frame(squared: .imageSize)
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
    static let imageSize: CGFloat = 44
    static let borderWidth: CGFloat = 1
}

