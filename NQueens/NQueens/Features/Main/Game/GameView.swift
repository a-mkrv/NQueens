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
                boardSection
                Spacer(minLength: LayoutToken.padding24)
            }
        }
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
                    .frame(width: .touchTarget, height: .touchTarget)
            }
            Spacer()
            Text("\(viewModel.boardSize)×\(viewModel.boardSize)")
                .font(TextToken.headM)
                .foregroundStyle(ColorToken.textPrimary)
            Spacer()
            Button {
                viewModel.handle(.restart)
            } label: {
                Image(systemName: "arrow.clockwise")
                    .font(TextToken.navButton)
                    .foregroundStyle(ColorToken.textPrimary)
                    .frame(width: .touchTarget, height: .touchTarget)
            }
        }
        .padding(.horizontal, LayoutToken.padding16)
        .padding(.top, LayoutToken.padding14)
        .padding(.bottom, LayoutToken.padding8)
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
            .padding(.top, LayoutToken.padding24)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func cellView(row: Int, col: Int, size: CGFloat) -> some View {
        let isLight = (row + col) % 2 == 0
        return RoundedRectangle(cornerRadius: LayoutToken.cornerRadius4)
            .fill(isLight ? ColorToken.backgroundCard : ColorToken.backgroundElevated)
            .overlay(
                RoundedRectangle(cornerRadius: LayoutToken.cornerRadius4)
                    .stroke(ColorToken.backgroundElevated, lineWidth: .borderWidth)
            )
            .frame(width: size, height: size)
    }
}

// MARK: - Constants

private extension CGFloat {
    static let touchTarget: CGFloat = 44
    static let borderWidth: CGFloat = 1
}
