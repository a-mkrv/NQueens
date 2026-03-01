//
//  GameHistoryViewModel.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import Foundation

@Observable
final class GameHistoryViewModel {

    // MARK: - Properties

    private(set) var viewState: ViewState = .loaded
    private(set) var games: [GameHistoryItemModel] = []
    private(set) var sortOrder: SortOrder = .date
    private(set) var selectedSizeFilter: Int? = nil

    var isSortModalPresented: Bool = false
    var isClearConfirmPresented: Bool = false

    var filteredGames: [GameHistoryItemModel] {
        guard let size = selectedSizeFilter else { return games }
        return games.filter { $0.boardSize == size }
    }

    var isEmpty: Bool {
        filteredGames.isEmpty
    }

    var sizeFilterOptions: [Int?] {
        [nil] + settingsService.availableSizes
    }

    // MARK: - Dependencies

    private let gameHistoryService: IGameHistoryService
    private let settingsService: ISettingsService
    private weak var homeCoordinatorDelegate: HomeCoordinatorDelegate?

    // MARK: - Init

    init(
        gameHistoryService: IGameHistoryService,
        settingsService: ISettingsService,
        homeCoordinatorDelegate: HomeCoordinatorDelegate?
    ) {
        self.gameHistoryService = gameHistoryService
        self.settingsService = settingsService
        self.homeCoordinatorDelegate = homeCoordinatorDelegate
    }

    // MARK: - Actions

    func handle(_ action: Action) {
        switch action {
        case .onAppear:
            loadGames()
        case .back:
            homeCoordinatorDelegate?.handle(.back)
        case .openSortModal:
            isSortModalPresented = true
        case .selectSortOrder(let order):
            sortOrder = order
            applySort()
            isSortModalPresented = false
        case .dismissSortModal:
            isSortModalPresented = false
        case .selectSizeFilter(let size):
            selectedSizeFilter = size
        case .openClearConfirm:
            isClearConfirmPresented = true
        case .dismissClearConfirm:
            isClearConfirmPresented = false
        case .clearAllGames:
            gameHistoryService.clearAllGames()
            loadGames()
            isClearConfirmPresented = false
        case .startGame:
            homeCoordinatorDelegate?.handle(.openGame(.new))
        case .selectGame(let game):
            homeCoordinatorDelegate?.handle(.openGame(.history(game)))
        }
    }

    // MARK: - Private

    private func loadGames() {
        games = gameHistoryService.games
        applySort()
    }

    private func applySort() {
        switch sortOrder {
        case .date:
            games.sort { $0.date > $1.date }
        case .moves:
            games.sort { $0.moveCount < $1.moveCount }
        case .time:
            games.sort { $0.durationSeconds < $1.durationSeconds }
        case .efficiency:
            games.sort { $0.efficiency > $1.efficiency }
        }
    }
}
