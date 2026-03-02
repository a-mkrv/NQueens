//
//  HomeCoordinator.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

// MARK: - Coordinator

protocol HomeCoordinatorDelegate: AnyObject {
    func handle(_ action: HomeCoordinator.Action)
}

@Observable
final class HomeCoordinator: FlowCoordinator<HomeCoordinator.Destination, HomeCoordinator.Sheet> {

    // MARK: - Navigation

    enum Destination: Hashable {
        case game(GameType)
        case gameHistory
    }

    enum Sheet: Identifiable, Equatable, Hashable {
        case boardSize
        case winModal(GameHistoryItemModel)

        var id: String {
            switch self {
            case .boardSize: return "boardSize"
            case .winModal(let result): return "winModal-\(result.id.uuidString)"
            }
        }
    }

    enum Action {
        case openGame(GameType)
        case presentGameHistory
        case openBoardSizeSheet
        case presentWinModal(GameHistoryItemModel)
        case back
        case dismissSheet
        case restartGame
        case playAgain(boardSize: Int)
    }

    // MARK: - Properties

    @ObservationIgnored
    lazy var homeViewModel: HomeViewModel = makeHomeViewModel()

    /// Cached per mode so that presenting a sheet doesn't recreate the VM, and opening a different mode gets a fresh VM.
    private var cachedGameViewModel: (mode: GameType, vm: GameViewModel)?

    /// Cached so that when returning from a game detail the list still shows the same data instead of a new VM with empty games.
    private var cachedGameHistoryViewModel: GameHistoryViewModel?

    private let dependencies: AppDependencies

    // MARK: - Init

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    // MARK: - ViewModels Factory

    private func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            gameHistoryService: dependencies.gameHistoryService,
            settingsService: dependencies.settingsService,
            homeCoordinatorDelegate: self
        )
    }

    func makeGameHistoryViewModel() -> GameHistoryViewModel {
        if let cached = cachedGameHistoryViewModel {
            return cached
        }
        let viewModel = GameHistoryViewModel(
            gameHistoryService: dependencies.gameHistoryService,
            settingsService: dependencies.settingsService,
            homeCoordinatorDelegate: self
        )
        cachedGameHistoryViewModel = viewModel
        return viewModel
    }

    func makeGameViewModel(for mode: GameType) -> GameViewModel {
        if let cached = cachedGameViewModel, cached.mode == mode {
            return cached.vm
        }
        let viewModel = GameViewModel(
            mode: mode,
            settingsService: dependencies.settingsService,
            gameHistoryService: dependencies.gameHistoryService,
            gameValidationService: dependencies.gameValidationService,
            homeCoordinatorDelegate: self
        )
        cachedGameViewModel = (mode, viewModel)
        return viewModel
    }

    func makeBoardSheetViewModel() -> BoardSheetViewModel {
        BoardSheetViewModel(settingsService: dependencies.settingsService, homeCoordinatorDelegate: self)
    }

    func makeWinModalViewModel(result: GameHistoryItemModel) -> WinModalViewModel {
        WinModalViewModel(result: result, homeCoordinatorDelegate: self)
    }
}

// MARK: - HomeCoordinatorDelegate

extension HomeCoordinator: HomeCoordinatorDelegate {
    func handle(_ action: Action) {
        switch action {
        case .openGame(let mode):
            push(.game(mode))
        case .presentGameHistory:
            push(.gameHistory)
        case .openBoardSizeSheet:
            present(.boardSize)
        case .presentWinModal(let result):
            present(.winModal(result))
        case .back:
            if path.count == 1 {
                cachedGameHistoryViewModel = nil
            }
            cachedGameViewModel = nil
            pop()
        case .dismissSheet:
            dismiss()
        case .restartGame:
            cachedGameViewModel = nil
            pop()
            push(.game(.new))
        case .playAgain(let boardSize):
            cachedGameViewModel = nil
            pop()
            dependencies.settingsService.updateBoardSize(boardSize)
            push(.game(.new))
        }
    }
}
