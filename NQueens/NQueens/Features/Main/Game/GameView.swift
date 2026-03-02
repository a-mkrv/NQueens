//
//  GameView.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

struct GameView: View {
    
    let viewModel: GameViewModel
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            ColorToken.backgroundMain
                .ignoresSafeArea()
            
            VStack(spacing: LayoutToken.spacing0) {
                headerSection
                statsSection
                
                if !viewModel.isHistoryGame {
                    conflictBannerSection
                        .padding(.top, LayoutToken.padding12)
                }
                
                boardSection
                    .padding(.top, viewModel.isHistoryGame ? LayoutToken.padding16 : 0)
                
                if !viewModel.isHistoryGame {
                    hintToggleSection
                    queenStyleSection
                }
                
                if viewModel.isHistoryGame {
                    historyFooterSection
                }
                
                Spacer(minLength: LayoutToken.padding24)
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        HStack {
            Button {
                viewModel.handle(.back)
            } label: {
                Image(systemName: "chevron.left")
                    .font(TextToken.navButton)
                    .foregroundStyle(ColorToken.textPrimary)
                    .frame(squared: .touchTarget)
            }
            
            Spacer()
            
            Text(viewModel.isHistoryGame ? "History" : "\(viewModel.boardSize)×\(viewModel.boardSize)")
                .font(TextToken.headM)
                .foregroundStyle(ColorToken.textPrimary)
            
            Spacer()
            
            Button {
                viewModel.handle(.restart)
            } label: {
                Image(systemName: "arrow.clockwise")
                    .font(TextToken.navButton)
                    .foregroundStyle(viewModel.isHistoryGame ? .clear : ColorToken.textPrimary)
                    .frame(squared: .touchTarget)
            }
            .disabled(viewModel.isHistoryGame)
        }
        .padding(.horizontal, LayoutToken.padding16)
        .padding(.top, LayoutToken.padding14)
        .padding(.bottom, LayoutToken.padding8)
    }
    
    // MARK: - Queens Counter
    
    private var statsSection: some View {
        HStack(spacing: LayoutToken.spacing0) {
            statItem(value: "\(viewModel.placements.count)/\(viewModel.boardSize)", label: "Queens")
            divider
            statItem(value: viewModel.formattedTime, label: "Time")
            divider
            statItem(value: "\(viewModel.moveCount)", label: "Moves")
            
            if viewModel.isHistoryGame {
                divider
                statItem(value: "\(viewModel.efficiency)%", label: "Efficiency")
            }
        }
        .padding(.horizontal, LayoutToken.padding20)
        .padding(.vertical, LayoutToken.padding10)
        .background(ColorToken.backgroundCard)
    }
    
    private var conflictBannerSection: some View {
        ZStack {
            if !viewModel.conflictPositions.isEmpty {
                HStack(spacing: LayoutToken.spacing6) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(TextToken.captionS)
                        .foregroundStyle(ColorToken.red)
                    Text("Conflict")
                        .font(TextToken.captionM)
                        .foregroundStyle(ColorToken.red)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, LayoutToken.padding8)
                .background(ColorToken.red.opacity(0.08))
                .transition(.opacity)
            } else {
                HStack(spacing: LayoutToken.spacing6) {
                    Text("Solve N-Queens Problem")
                        .font(TextToken.captionM)
                        .foregroundStyle(ColorToken.textPrimary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, LayoutToken.padding8)
            }
        }
        .frame(height: .bannerHeight)
        .animation(.easeInOut(duration: 0.2), value: viewModel.conflictPositions.isEmpty)
    }
    
    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: LayoutToken.spacing2) {
            Text(value)
                .font(TextToken.titleS)
                .foregroundStyle(ColorToken.textPrimary)
                .monospacedDigit()
            Text(label)
                .font(TextToken.captionXS)
                .foregroundStyle(ColorToken.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var divider: some View {
        Rectangle()
            .fill(ColorToken.backgroundElevated)
            .frame(width: .borderWidth, height: .bannerHeight)
    }
    
    // MARK: - History Footer (when viewing a past game)
    
    private var historyFooterSection: some View {
        VStack(spacing: LayoutToken.spacing12) {
            if let item = viewModel.historyItem {
                HStack(spacing: LayoutToken.spacing6) {
                    Image(systemName: "calendar")
                        .font(TextToken.captionM)
                        .foregroundStyle(ColorToken.textSecondary)
                    Text(item.formattedDate)
                        .font(TextToken.bodyM)
                        .foregroundStyle(ColorToken.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, LayoutToken.padding14)
                .padding(.horizontal, LayoutToken.padding20)
                .cardStyle()
            }
            
            PrimaryButton(size: .compact, title: "Play Again", imageName: "arrow.clockwise") {
                viewModel.handle(.playAgain)
            }
        }
        .padding(.horizontal, LayoutToken.padding20)
        .padding(.top, LayoutToken.padding24)
    }
    
    // MARK: - Hint Toggle
    
    private var hintToggleSection: some View {
        HStack(spacing: LayoutToken.spacing10) {
            Image(systemName: "lightbulb.fill")
                .font(TextToken.captionM)
                .foregroundStyle(viewModel.isHintEnabled ? ColorToken.yellow : ColorToken.textSecondary)
            
            Text("Hints")
                .font(TextToken.bodyM)
                .foregroundStyle(ColorToken.textPrimary)
            
            Spacer()
            
            Toggle("", isOn: Binding(
                get: { viewModel.isHintEnabled },
                set: { newValue in
                    if newValue != viewModel.isHintEnabled {
                        viewModel.handle(.toggleHint)
                    }
                }
            ))
            .tint(ColorToken.green)
            .labelsHidden()
        }
        .padding(.horizontal, LayoutToken.padding20)
        .padding(.vertical, LayoutToken.padding14)
        .cardStyle()
        .padding(.horizontal, LayoutToken.padding20)
        .padding(.top, LayoutToken.padding12)
    }
    
    // MARK: - Queen Style
    
    private var queenStyleSection: some View {
        HStack(spacing: LayoutToken.spacing10) {
            Text("Queen")
                .font(TextToken.bodyM)
                .foregroundStyle(ColorToken.textPrimary)
            Spacer()
            HStack(spacing: LayoutToken.spacing8) {
                ForEach(QueenStyle.allCases) { style in
                    queenStyleButton(style)
                }
            }
        }
        .padding(.horizontal, LayoutToken.padding20)
        .padding(.vertical, LayoutToken.padding14)
        .cardStyle()
        .padding(.horizontal, LayoutToken.padding20)
        .padding(.top, LayoutToken.padding12)
    }
    
    private func queenStyleButton(_ style: QueenStyle) -> some View {
        let isSelected = viewModel.queenStyle == style
        return Button {
            viewModel.handle(.setQueenStyle(style))
        } label: {
            Image(style.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(squared: .iconSizeSmall)
                .padding(LayoutToken.padding6)
                .background(isSelected ? ColorToken.green.opacity(0.2) : ColorToken.backgroundElevated, in: RoundedRectangle(cornerRadius: LayoutToken.cornerRadius8))
                .overlay(
                    RoundedRectangle(cornerRadius: LayoutToken.cornerRadius8)
                        .stroke(isSelected ? ColorToken.green : Color.clear, lineWidth: .borderWidthHighlight)
                )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Board
    
    private var boardSection: some View {
        GeometryReader { geo in
            let n = viewModel.boardSize
            let padding = LayoutToken.padding20
            let spacing = LayoutToken.spacing6
            let width = geo.size.width - padding * 2
            let totalSpacing = spacing * CGFloat(max(0, n - 1))
            let side = (width - totalSpacing) / CGFloat(n)
            
            VStack(spacing: spacing) {
                ForEach(0..<n, id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(0..<n, id: \.self) { col in
                            cellView(row: row, col: col, size: side)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, padding)
            .padding(.top, LayoutToken.padding12)
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private func cellView(row: Int, col: Int, size: CGFloat) -> some View {
        let position = QueenPosition(row: row, col: col)
        let isLight = (row + col) % 2 == 0
        let hasQueen = viewModel.placements.contains(position)
        let isConflict = viewModel.conflictPositions.contains(position)
        let isConflictLine = !hasQueen && !isConflict && viewModel.conflictLines.contains(position)
        let isAttacked = !hasQueen && !isConflict && !isConflictLine && viewModel.hintPositions.contains(position)
        
        return RoundedRectangle(cornerRadius: LayoutToken.cornerRadius4)
            .fill(cellColor(isLight: isLight, isConflict: isConflict, isConflictLine: isConflictLine, isAttacked: isAttacked))
            .overlay(
                RoundedRectangle(cornerRadius: LayoutToken.cornerRadius4)
                    .stroke(
                        isConflict ? ColorToken.red.opacity(0.6) : ColorToken.backgroundElevated,
                        lineWidth: isConflict ? 1.5 : .borderWidth
                    )
            )
            .overlay(
                Group {
                    if hasQueen {
                        queenContent(size: size, isLight: isLight, isConflict: isConflict)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
            )
            .onTapGesture {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                    viewModel.handle(.tapCell(position))
                }
            }
    }
    
    @ViewBuilder
    private func queenContent(size: CGFloat, isLight: Bool, isConflict: Bool) -> some View {
        let color = isConflict
        ? ColorToken.red
        : (isLight ? ColorToken.white.opacity(0.75) : ColorToken.white.opacity(0.9))
        Image(viewModel.queenStyle.imageName)
            .resizable()
            .frame(width: size * 0.7, height: size * 0.7)
            .foregroundStyle(color)
    }
    
    private func cellColor(isLight: Bool, isConflict: Bool, isConflictLine: Bool, isAttacked: Bool) -> Color {
        if isConflict {
            return ColorToken.red.opacity(isLight ? 0.25 : 0.40)
        }
        if isConflictLine {
            return ColorToken.red.opacity(isLight ? 0.15 : 0.22)
        }
        if isAttacked {
            return ColorToken.red.opacity(isLight ? 0.05 : 0.08)
        }
        return isLight ? ColorToken.backgroundCard : ColorToken.backgroundElevated
    }
}

// MARK: - Constants

private extension CGFloat {
    static let touchTarget: CGFloat = 44
    static let iconSizeSmall: CGFloat = 32
    static let bannerHeight: CGFloat = 36
    static let borderWidth: CGFloat = 1
    static let borderWidthHighlight: CGFloat = 2
}
