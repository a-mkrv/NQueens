//
//  GameHistoryViewModelTests.swift
//  NQueensTests
//
//  Same leak-bag workaround as HomeViewModelTests for @Observable deallocation in XCTest.
//

import XCTest
@testable import NQueens

@MainActor
final class GameHistoryViewModelTests: XCTestCase {

    private static var leakBag: [Any] = []

    private func makeMocks() -> (MockSettingsService, MockGameHistoryService, MockHomeCoordinatorDelegate) {
        let settings = MockSettingsService()
        let history = MockGameHistoryService()
        let delegate = MockHomeCoordinatorDelegate()
        return (settings, history, delegate)
    }

    private func makeMocksWithoutDelegate() -> (MockSettingsService, MockGameHistoryService) {
        let settings = MockSettingsService()
        let history = MockGameHistoryService()
        return (settings, history)
    }

    private func makeSut(
        settings: MockSettingsService,
        history: MockGameHistoryService,
        delegate: MockHomeCoordinatorDelegate?
    ) -> GameHistoryViewModel {
        let vm = GameHistoryViewModel(
            gameHistoryService: history,
            settingsService: settings,
            homeCoordinatorDelegate: delegate
        )
        Self.leakBag.append(vm)
        Self.leakBag.append(settings)
        Self.leakBag.append(history)
        if let d = delegate { Self.leakBag.append(d) }
        return vm
    }

    // MARK: - onAppear / load games

    func test_onAppear_loadsGamesFromServiceAndSortsByDate() {
        let (settings, history, delegate) = makeMocks()
        let older = Sample.game(date: Date().addingTimeInterval(-100))
        let newer = Sample.game(date: Date())
        history.games = [older, newer]
        let sut = makeSut(settings: settings, history: history, delegate: delegate)
        sut.handle(.onAppear)
        XCTAssertEqual(sut.games.count, 2)
        XCTAssertEqual(sut.games[0].id, newer.id)
        XCTAssertEqual(sut.games[1].id, older.id)
    }

    func test_filteredGames_withNoFilter_returnsAllGames() {
        let (settings, history, delegate) = makeMocks()
        history.games = [Sample.game(boardSize: 4), Sample.game(boardSize: 8)]
        let sut = makeSut(settings: settings, history: history, delegate: delegate)
        sut.handle(.onAppear)
        XCTAssertEqual(sut.filteredGames.count, 2)
        XCTAssertFalse(sut.isEmpty)
    }

    func test_filteredGames_withSizeFilter_returnsMatchingSize() {
        let (settings, history, delegate) = makeMocks()
        history.games = [Sample.game(boardSize: 4), Sample.game(boardSize: 8)]
        let sut = makeSut(settings: settings, history: history, delegate: delegate)
        sut.handle(.onAppear)
        sut.handle(.selectSizeFilter(8))
        XCTAssertEqual(sut.filteredGames.count, 1)
        XCTAssertEqual(sut.filteredGames[0].boardSize, 8)
    }

    func test_isEmpty_whenNoGames_returnsTrue() {
        let (settings, history, delegate) = makeMocks()
        history.games = []
        let sut = makeSut(settings: settings, history: history, delegate: delegate)
        sut.handle(.onAppear)
        XCTAssertTrue(sut.isEmpty)
    }

    func test_sizeFilterOptions_includesNilAndAvailableSizes() {
        let (settings, history, delegate) = makeMocks()
        let sut = makeSut(settings: settings, history: history, delegate: delegate)
        XCTAssertEqual(sut.sizeFilterOptions.count, 5)
        XCTAssertNil(sut.sizeFilterOptions[0])
        XCTAssertEqual(sut.sizeFilterOptions[1], 4)
        XCTAssertEqual(sut.sizeFilterOptions[2], 6)
        XCTAssertEqual(sut.sizeFilterOptions[3], 8)
        XCTAssertEqual(sut.sizeFilterOptions[4], 10)
    }

    // MARK: - Sort order

    func test_selectSortOrder_time_sortsByDuration() {
        let (settings, history, delegate) = makeMocks()
        history.games = [Sample.game(durationSeconds: 100), Sample.game(durationSeconds: 10)]
        let sut = makeSut(settings: settings, history: history, delegate: delegate)
        sut.handle(.onAppear)
        sut.handle(.selectSortOrder(.time))
        XCTAssertEqual(sut.games[0].durationSeconds, 10)
        XCTAssertEqual(sut.games[1].durationSeconds, 100)
    }

    func test_selectSortOrder_moves_sortsByMoveCount() {
        let (settings, history, delegate) = makeMocks()
        history.games = [Sample.game(moveCount: 20), Sample.game(moveCount: 4)]
        let sut = makeSut(settings: settings, history: history, delegate: delegate)
        sut.handle(.onAppear)
        sut.handle(.selectSortOrder(.moves))
        XCTAssertEqual(sut.games[0].moveCount, 4)
        XCTAssertEqual(sut.games[1].moveCount, 20)
    }

    func test_selectSortOrder_dismissesSortModal() {
        let (settings, history, delegate) = makeMocks()
        let sut = makeSut(settings: settings, history: history, delegate: delegate)
        sut.handle(.openSortModal)
        XCTAssertTrue(sut.isSortModalPresented)
        sut.handle(.selectSortOrder(.date))
        XCTAssertFalse(sut.isSortModalPresented)
    }

    // MARK: - Clear all

    func test_clearAllGames_callsServiceAndReloads() {
        let (settings, history, delegate) = makeMocks()
        history.games = [Sample.game()]
        let sut = makeSut(settings: settings, history: history, delegate: delegate)
        sut.handle(.onAppear)
        XCTAssertEqual(sut.games.count, 1)
        sut.handle(.clearAllGames)
        XCTAssertTrue(history.clearAllCalled)
        XCTAssertEqual(sut.games.count, 0)
        XCTAssertFalse(sut.isClearConfirmPresented)
    }

    func test_openClearConfirm_showsConfirm() {
        let (settings, history, delegate) = makeMocks()
        let sut = makeSut(settings: settings, history: history, delegate: delegate)
        sut.handle(.openClearConfirm)
        XCTAssertTrue(sut.isClearConfirmPresented)
    }

    func test_dismissClearConfirm_hidesConfirm() {
        let (settings, history, delegate) = makeMocks()
        let sut = makeSut(settings: settings, history: history, delegate: delegate)
        sut.handle(.openClearConfirm)
        sut.handle(.dismissClearConfirm)
        XCTAssertFalse(sut.isClearConfirmPresented)
    }

    // MARK: - Delegate actions

    func test_handleBack_sendsBackToDelegate() {
        let (settings, history, delegate) = makeMocks()
        let sut = makeSut(settings: settings, history: history, delegate: delegate)
        sut.handle(.back)
        XCTAssertEqual(delegate.actions.count, 1)
        guard case .back = delegate.actions[0] else {
            XCTFail("Expected .back, got \(delegate.actions)")
            return
        }
    }

    func test_handleStartGame_sendsOpenGameNewToDelegate() {
        let (settings, history, delegate) = makeMocks()
        let sut = makeSut(settings: settings, history: history, delegate: delegate)
        sut.handle(.startGame)
        XCTAssertEqual(delegate.actions.count, 1)
        guard case .openGame(.new) = delegate.actions[0] else {
            XCTFail("Expected .openGame(.new), got \(delegate.actions)")
            return
        }
    }

    func test_handleSelectGame_sendsOpenGameHistoryToDelegate() {
        let (settings, history, delegate) = makeMocks()
        let game = Sample.game()
        history.games = [game]
        let sut = makeSut(settings: settings, history: history, delegate: delegate)
        sut.handle(.onAppear)
        sut.handle(.selectGame(game))
        XCTAssertEqual(delegate.actions.count, 1)
        guard case .openGame(.history(let item)) = delegate.actions[0] else {
            XCTFail("Expected .openGame(.history), got \(delegate.actions)")
            return
        }
        XCTAssertEqual(item.id, game.id)
    }
}
