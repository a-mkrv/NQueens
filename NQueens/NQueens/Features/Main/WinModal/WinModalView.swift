//
//  WinModalView.swift
//  NQueens
//
//  Created by Anton Makarov on 01.03.2026.
//

import SwiftUI

struct WinModalView: View {

    let viewModel: WinModalViewModel

    @State private var isRevealed = false
    @State private var confettiTrigger = false

    // MARK: - Body

    var body: some View {
        switch viewModel.viewState {
        case .loaded:
            content
        }
    }

    private var content: some View {
        let result = viewModel.result
        return ZStack {
            VictoryConfettiView(trigger: confettiTrigger)

            VStack(spacing: LayoutToken.spacing20) {
                Image(systemName: "crown.fill")
                    .font(TextToken.iconXL)
                    .foregroundStyle(ColorToken.yellow)
                    .scaleEffect(isRevealed ? 1 : 0)
                    .opacity(isRevealed ? 1 : 0)

                Text("Victory!")
                    .font(TextToken.headL)
                    .foregroundStyle(ColorToken.textPrimary)
                    .opacity(isRevealed ? 1 : 0)
                    .offset(y: isRevealed ? 0 : 8)

                Text("Congratulations! You solved the \(result.boardSize)×\(result.boardSize) puzzle.")
                    .font(TextToken.bodyM)
                    .foregroundStyle(ColorToken.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(isRevealed ? 1 : 0)
                    .offset(y: isRevealed ? 0 : 6)

                VStack(spacing: LayoutToken.spacing12) {
                    rowTitle(with: "Time", value: result.formattedDuration)
                    rowTitle(with: "Moves", value: "\(result.moveCount)")
                    rowTitle(with: "Efficiency", value: "\(result.efficiency)%")
                }
                .padding(.vertical, LayoutToken.padding16)
                .padding(.horizontal, LayoutToken.padding24)
                .background(ColorToken.backgroundCard, in: RoundedRectangle(cornerRadius: LayoutToken.cornerRadius16))
                .padding(.horizontal, LayoutToken.padding24)
                .opacity(isRevealed ? 1 : 0)
                .offset(y: isRevealed ? 0 : 12)

                PrimaryButton(size: .compact, title: "Done") {
                    viewModel.handle(.dismiss)
                }
                .padding(.horizontal, LayoutToken.padding24)
                .padding(.top, LayoutToken.padding8)
                .opacity(isRevealed ? 1 : 0)
            }
            .padding(.vertical, LayoutToken.padding32)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isRevealed = true
            }
            confettiTrigger = true
        }
    }

    private func rowTitle(with label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(TextToken.bodyM)
                .foregroundStyle(ColorToken.textSecondary)
            Spacer()
            Text(value)
                .font(TextToken.titleS)
                .foregroundStyle(ColorToken.textPrimary)
                .monospacedDigit()
        }
    }
}
