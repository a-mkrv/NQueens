//
//  SelectorSheetView.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

struct SelectorSheetView<Item: Hashable>: View {

    // MARK: - Properties

    let title: String
    let items: [Item]
    let selectedItem: Item
    let itemTitle: (Item) -> String
    let onSelect: (Item) -> Void
    let onDismiss: () -> Void

    // MARK: - Body

    var body: some View {
        ZStack {
            ColorToken.backgroundMain
                .ignoresSafeArea()

            VStack(spacing: LayoutToken.spacing0) {
                headerSection
                listSection
                Spacer(minLength: LayoutToken.padding24)
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            Text(title)
                .font(TextToken.headM)
                .foregroundStyle(ColorToken.textPrimary)

            Spacer()

            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: .iconSize28))
                    .foregroundStyle(ColorToken.textSecondary)
            }
        }
        .padding(.horizontal, LayoutToken.padding24)
        .padding(.top, LayoutToken.padding20)
        .padding(.bottom, LayoutToken.padding16)
    }

    // MARK: - List

    private var listSection: some View {
        VStack(spacing: LayoutToken.spacing10) {
            ForEach(items, id: \.self) { item in
                Button {
                    onSelect(item)
                } label: {
                    HStack(spacing: LayoutToken.spacing14) {

                        Text(itemTitle(item))
                            .font(TextToken.titleM)
                            .foregroundStyle(ColorToken.textPrimary)

                        Spacer()

                        if item == selectedItem {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: .iconSize22))
                                .foregroundStyle(ColorToken.green)
                        }
                    }
                    .padding(LayoutToken.padding16)
                    .cardStyle()
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, LayoutToken.padding20)
    }
}

private extension CGFloat {
    static let iconSize22: CGFloat = 22
    static let iconSize28: CGFloat = 28
}
