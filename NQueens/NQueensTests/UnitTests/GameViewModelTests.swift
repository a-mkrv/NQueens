//
//  GameViewModelTests.swift
//  NQueensTests
//
//  Same leak-bag workaround as HomeViewModelTests for @Observable deallocation in XCTest.
//

import XCTest
@testable import NQueens

@MainActor
final class GameViewModelTests: XCTestCase {

    private static var leakBag: [Any] = []

    private func makeMocks() -> (MockSettingsService, MockGameHistoryService, MockGameValidationService, MockHomeCoordinatorDelegate) {
        let settings = MockSettingsService()
        let history = MockGameHistoryService()
        let validation = MockGameValidationService()
        let delegate = MockHomeCoordinatorDelegate()
        return (settings, history, validation, delegate)
    }

    private func makeMocksWithoutDelegate() -> (MockSettingsService, MockGameHistoryService, MockGameValidationService) {
        let settings = MockSettingsService()
        let history = MockGameHistoryService()
        let validation = MockGameValidationService()
        return (settings, history, validation)
    }

    private func makeSut(
        mode: GameType = .new,
        settings: MockSettingsService,
        history: MockGameHistoryService,
        validation: MockGameValidationService,
        delegate: MockHomeCoordinatorDelegate?
    ) -> GameViewModel {
        let vm = GameViewModel(
            mode: mode,
            settingsService: settings,
            gameHistoryService: history,
            gameValidationService: validation,
            homeCoordinatorDelegate: delegate
        )
        Self.leakBag.append(vm)
        Self.leakBag.append(settings)
        Self.leakBag.append(history)
        Self.leakBag.append(validation)
        if let d = delegate { Self.leakBag.append(d) }
        return vm
    }

    // MARK: - New game initial state

    func test_newGame_initialPlacementsEmpty() {
        let (settings, history, validation, delegate) = makeMocks()
        settings.boardSize = 4
        let sut = makeSut(settings: settings, history: history, validation: validation, delegate: delegate)
        XCTAssertTrue(sut.placements.isEmpty)
        XCTAssertEqual(sut.boardSize, 4)
        XCTAssertFalse(sut.isHistoryGame)
        XCTAssertFalse(sut.isWon)
        XCTAssertEqual(sut.moveCount, 0)
    }

    func test_newGame_formattedTime_startsAtZero() {
        let (settings, history, validation, delegate) = makeMocks()
        let sut = makeSut(settings: settings, history: history, validation: validation, delegate: delegate)
        XCTAssertEqual(sut.formattedTime, "0:00")
    }

    // MARK: - History game initial state

    func test_historyGame_loadsPlacementsAndStats() {
        let (settings, history, validation, delegate) = makeMocks()
        let item = Sample.game(boardSize: 6, moveCount: 8, durationSeconds: 65)
        let sut = makeSut(mode: .history(item), settings: settings, history: history, validation: validation, delegate: delegate)
        XCTAssertEqual(sut.boardSize, 6)
        XCTAssertTrue(sut.isHistoryGame)
        XCTAssertEqual(sut.placements.count, 4)
        XCTAssertEqual(sut.moveCount, 8)
        XCTAssertEqual(sut.formattedTime, "1:05")
    }

    // MARK: - Tap cell

    func test_tapCell_addsQueen() {
        let (settings, history, validation, delegate) = makeMocks()
        let sut = makeSut(settings: settings, history: history, validation: validation, delegate: delegate)
        let pos = QueenPosition(row: 0, col: 1)
        sut.handle(.tapCell(pos))
        XCTAssertTrue(sut.placements.contains(pos))
        XCTAssertEqual(sut.moveCount, 1)
    }

    func test_tapCell_removeQueen() {
        let (settings, history, validation, delegate) = makeMocks()
        let sut = makeSut(settings: settings, history: history, validation: validation, delegate: delegate)
        let pos = QueenPosition(row: 0, col: 1)
        sut.handle(.tapCell(pos))
        sut.handle(.tapCell(pos))
        XCTAssertFalse(sut.placements.contains(pos))
        XCTAssertEqual(sut.moveCount, 1)
    }

    func test_tapCell_whenHistoryGame_ignored() {
        let (settings, history, validation, delegate) = makeMocks()
        let item = Sample.game()
        let sut = makeSut(mode: .history(item), settings: settings, history: history, validation: validation, delegate: delegate)
        let countBefore = sut.placements.count
        sut.handle(.tapCell(QueenPosition(row: 2, col: 0)))
        XCTAssertEqual(sut.placements.count, countBefore)
    }

    // MARK: - Restart

    func test_restart_resetsPlacementsAndMoveCount() {
        let (settings, history, validation, delegate) = makeMocks()
        let sut = makeSut(settings: settings, history: history, validation: validation, delegate: delegate)
        sut.handle(.tapCell(QueenPosition(row: 0, col: 0)))
        sut.handle(.tapCell(QueenPosition(row: 1, col: 2)))
        sut.handle(.restart)
        XCTAssertTrue(sut.placements.isEmpty)
        XCTAssertEqual(sut.moveCount, 0)
    }

    // MARK: - Win flow

    func test_whenIsWon_addsGameAndPresentsWinModal() {
        let (settings, history, validation, delegate) = makeMocks()
        settings.boardSize = 4
        validation.isWonResult = true
        let sut = makeSut(settings: settings, history: history, validation: validation, delegate: delegate)
        sut.handle(.tapCell(QueenPosition(row: 0, col: 1)))
        sut.handle(.tapCell(QueenPosition(row: 1, col: 3)))
        sut.handle(.tapCell(QueenPosition(row: 2, col: 0)))
        sut.handle(.tapCell(QueenPosition(row: 3, col: 2)))
        XCTAssertTrue(sut.isWon)
        XCTAssertEqual(history.addedGames.count, 1)
        XCTAssertEqual(history.addedGames[0].boardSize, 4)
        let hasPresentWin = delegate.actions.contains { if case .presentWinModal = $0 { return true }; return false }
        XCTAssertTrue(hasPresentWin)
    }

    // MARK: - Back / Play again

    func test_handleBack_sendsBackToDelegate() {
        let (settings, history, validation, delegate) = makeMocks()
        let sut = makeSut(settings: settings, history: history, validation: validation, delegate: delegate)
        sut.handle(.back)
        XCTAssertEqual(delegate.actions.count, 1)
        guard case .back = delegate.actions[0] else {
            XCTFail("Expected .back, got \(delegate.actions)")
            return
        }
    }

    func test_handlePlayAgain_sendsPlayAgainWithBoardSize() {
        let (settings, history, validation, delegate) = makeMocks()
        settings.boardSize = 8
        let item = Sample.game(boardSize: 8)
        let sut = makeSut(mode: .history(item), settings: settings, history: history, validation: validation, delegate: delegate)
        sut.handle(.playAgain)
        XCTAssertEqual(delegate.actions.count, 1)
        guard case .playAgain(let size) = delegate.actions[0] else {
            XCTFail("Expected .playAgain(boardSize:), got \(delegate.actions)")
            return
        }
        XCTAssertEqual(size, 8)
    }

    // MARK: - Conflict / hint from validation

    func test_conflictPositions_delegatesToValidation() {
        let (settings, history, validation, delegate) = makeMocks()
        let a = QueenPosition(row: 0, col: 0)
        let b = QueenPosition(row: 1, col: 1)
        validation.conflictPositionsResult = [a, b]
        let sut = makeSut(settings: settings, history: history, validation: validation, delegate: delegate)
        sut.handle(.tapCell(a))
        sut.handle(.tapCell(b))
        XCTAssertEqual(sut.conflictPositions, Set([a, b]))
    }

    func test_queenStyle_setQueenStyle_updatesStyle() {
        let (settings, history, validation, delegate) = makeMocks()
        let sut = makeSut(settings: settings, history: history, validation: validation, delegate: delegate)
        XCTAssertEqual(sut.queenStyle, .queen_1)
        sut.handle(.setQueenStyle(.queen_2))
        XCTAssertEqual(sut.queenStyle, .queen_2)
    }
}
