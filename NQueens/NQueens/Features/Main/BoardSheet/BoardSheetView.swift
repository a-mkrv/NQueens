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
        switch viewModel.viewState {
        case .loaded:
            SelectorSheetView(
                title: "Board size",
                items: viewModel.availableSizes,
                selectedItem: viewModel.currentSize,
                hideIcons: false,
                itemTitle: {
                    "\($0)×\($0)"
                },
                onSelect: {
                    viewModel.handle(.selectSize($0))
                },
                onDismiss: {
                    viewModel.handle(.dismiss)
                }
            )
        }
    }
}
