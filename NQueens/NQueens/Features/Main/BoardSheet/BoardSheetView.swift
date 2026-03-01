//
//  BoardSheetView.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

struct BoardSheetView: View {
    
    let viewModel: BoardSheetViewModel
    
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
            sizeListSection
            Spacer(minLength: LayoutToken.padding24)
        }
    }
    
    private var headerSection: some View {
        HStack {
            Text("Board size")
                .font(TextToken.headM)
                .foregroundStyle(ColorToken.textPrimary)
            
            Spacer()
            
            Button {
                viewModel.handle(.dismiss)
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: .iconSizeL))
                    .foregroundStyle(ColorToken.textSecondary)
            }
        }
        .padding(.horizontal, LayoutToken.padding24)
        .padding(.top, LayoutToken.padding20)
        .padding(.bottom, LayoutToken.padding16)
    }
    
    private var sizeListSection: some View {
        VStack(spacing: LayoutToken.spacing10) {
            ForEach(viewModel.availableSizes, id: \.self) { size in
                Button {
                    viewModel.handle(.selectSize(size))
                } label: {
                    HStack(spacing: LayoutToken.spacing14) {
                        Text("♕")
                            .font(TextToken.iconL)
                            .foregroundStyle(.white)
                        Text("\(size)×\(size)")
                            .font(TextToken.titleM)
                            .foregroundStyle(ColorToken.textPrimary)
                        Spacer()
                        if size == viewModel.currentSize {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: .iconSizeM))
                                .foregroundStyle(ColorToken.green)
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
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, LayoutToken.padding20)
    }
}

// MARK: - Constants

private extension CGFloat {
    static let iconSizeL: CGFloat = 28
    static let iconSizeM: CGFloat = 22
    static let borderWidth: CGFloat = 1
}
