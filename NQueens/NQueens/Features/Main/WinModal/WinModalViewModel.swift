//
//  WinModalViewModel.swift
//  NQueens
//
//  Created by Anton Makarov on 01.03.2026.
//

import SwiftUI

@Observable
final class WinModalViewModel {

    // MARK: - Properties

    private(set) var viewState: ViewState = .loaded
    
    let result: GameHistoryItemModel

    // MARK: - Dependencies

    private weak var homeCoordinatorDelegate: HomeCoordinatorDelegate?

    // MARK: - Init

    init(
        result: GameHistoryItemModel,
        homeCoordinatorDelegate: HomeCoordinatorDelegate?
    ) {
        self.result = result
        self.homeCoordinatorDelegate = homeCoordinatorDelegate
    }

    // MARK: - Public

    func handle(_ action: Action) {
        switch action {
        case .dismiss:
            homeCoordinatorDelegate?.handle(.dismissSheet)
        }
    }
}
