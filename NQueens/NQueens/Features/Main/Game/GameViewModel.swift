//
//  GameViewModel.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

enum GameType: Equatable, Hashable {
    case new
    case history(GameHistoryItemModel)
}

@Observable
final class GameViewModel {
    
    // MARK: - Properties
    
    private(set) var viewState: ViewState = .loaded
    
    private(set) var placements: Set<QueenPosition> = []
    private(set) var gameSeconds: Int = 0
    private(set) var efficiency: Int = 0
    private(set) var moveCount: Int = 0
    private(set) var hintWasUsed: Bool = false
    private(set) var isHintEnabled: Bool = false
    
    private(set) var winResult: GameHistoryItemModel?
    
    private var timer: Timer?
    private let mode: GameType
    var queenStyle: QueenStyle
    
    var boardSize: Int {
        switch mode {
        case .new:
            return settingsService.boardSize
        case .history(let item):
            return item.boardSize
        }
    }
    
    var isHistoryGame: Bool {
        if case .history = mode { return true }
        return false
    }
    
    var historyItem: GameHistoryItemModel? {
        if case .history(let item) = mode { return item }
        return nil
    }
    
    var isWon: Bool {
        winResult != nil
    }
    
    // MARK: - Dependencies

    private var settingsService: ISettingsService
    private var gameHistoryService: IGameHistoryService
    private var gameValidationService: IGameValidationService
    private weak var homeCoordinatorDelegate: HomeCoordinatorDelegate?
    
    // MARK: - Init
    
    init(
        mode: GameType,
        settingsService: ISettingsService,
        gameHistoryService: IGameHistoryService,
        gameValidationService: IGameValidationService,
        homeCoordinatorDelegate: HomeCoordinatorDelegate?
    ) {
        self.mode = mode
        self.settingsService = settingsService
        self.gameHistoryService = gameHistoryService
        self.gameValidationService = gameValidationService
        self.homeCoordinatorDelegate = homeCoordinatorDelegate
        self.queenStyle = settingsService.queenStyle
        
        setupInitialState()
    }
    
    deinit {
        stopTimer()
    }
    
    // MARK: - Public
    
    var conflictLines: Set<QueenPosition> {
        gameValidationService.conflictLines(placements: placements, boardSize: boardSize)
    }
    
    var conflictPositions: Set<QueenPosition> {
        gameValidationService.conflictPositions(placements: placements)
    }
    
    var hintPositions: Set<QueenPosition> {
        guard isHintEnabled else { return [] }
        return gameValidationService.hintPositions(placements: placements, boardSize: boardSize)
    }
    
    func updateQueenStyle() {
        settingsService.updateQueenStyle(queenStyle)
    }
    
    // MARK: - Actions
    
    func handle(_ action: Action) {
        switch action {
        case .back:
            homeCoordinatorDelegate?.handle(.back)
        case .restart:
            setupInitialState()
        case .tapCell(let position):
            guard !isHistoryGame, !isWon else {
                return
            }
            toggleQueen(at: position)
        case .toggleHint:
            isHintEnabled.toggle()
            if isHintEnabled { hintWasUsed = true }
        case .setQueenStyle(let style):
            queenStyle = style
            updateQueenStyle()
        case .playAgain:
            homeCoordinatorDelegate?.handle(.playAgain(boardSize: boardSize))
        }
    }
    
    // MARK: - Private
    
    private func setupInitialState() {
        switch mode {
        case .new:
            placements = []
            gameSeconds = 0
            moveCount = 0
            efficiency = 0
            hintWasUsed = false
            isHintEnabled = false
            winResult = nil
            startTimer()
        case .history(let item):
            placements = Set(item.placements)
            gameSeconds = item.durationSeconds
            moveCount = item.moveCount
            efficiency = item.efficiency
            stopTimer()
        }
    }
    
    private func toggleQueen(at position: QueenPosition) {
        TapticEngine.feedback(tapticType: .queenPlacement)
        if placements.contains(position) {
            placements.remove(position)
        } else {
            moveCount += 1
            placements.insert(position)
            checkWinAndSaveIfNeeded()
        }
    }
    
    private func checkWinAndSaveIfNeeded() {
        guard !isHistoryGame,
              gameValidationService.isWon(placements: placements, boardSize: boardSize) else {
            return
        }
        stopTimer()
        let sortedPlacements = placements.sorted { $0.row < $1.row || ($0.row == $1.row && $0.col < $1.col) }
        let item = GameHistoryItemModel(
            id: UUID(),
            boardSize: boardSize,
            moveCount: moveCount,
            placements: sortedPlacements,
            durationSeconds: gameSeconds,
            date: Date(),
            solvedWithHint: hintWasUsed
        )
        gameHistoryService.addGame(item)
        winResult = item
        TapticEngine.feedback(tapticType: .victory)
        homeCoordinatorDelegate?.handle(.presentWinModal(item))
    }
    
    // MARK: - Timer
    
    private func startTimer() {
        guard !isHistoryGame else {
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.gameSeconds += 1
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    var formattedTime: String {
        let m = gameSeconds / 60
        let s = gameSeconds % 60
        return String(format: "%d:%02d", m, s)
    }
}
