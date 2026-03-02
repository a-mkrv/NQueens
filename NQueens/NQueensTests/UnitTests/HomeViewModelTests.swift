//
//  HomeViewModelTests.swift
//  NQueensTests
//
//  Workaround for malloc crash when @Observable is deallocated in XCTest: we keep
//  view models and mocks in a static "leak bag" so they are never deallocated.
//  See https://forums.swift.org/t/pointer-being-freed-was-not-allocated-unless-i-have-an-empty-deinit/84034
//

import XCTest
@testable import NQueens

@MainActor
final class HomeViewModelTests: XCTestCase {

    /// Keep view model and dependencies alive to avoid deallocation crash (do not clear).
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
    ) -> HomeViewModel {
        let vm = HomeViewModel(
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

    // MARK: - Data from services

    func test_boardSize_returnsValueFromSettings() {
        let (settings, history, delegate) = makeMocks()
        settings.boardSize = 6
        let sut = makeSut(settings: settings, history: history, delegate: delegate)
        XCTAssertEqual(sut.boardSize, 6)
    }

    /// Home shows one board size → open selector (BoardSheetViewModel) → select another size → Home shows the new size.
    func test_boardSize_afterSelectInSheet_reflectsNewSize() {
        let (settings, history, delegate) = makeMocks()
        let home = makeSut(settings: settings, history: history, delegate: delegate)
        XCTAssertEqual(home.boardSize, 8, "initial default from mock")

        let boardSheet = BoardSheetViewModel(
            settingsService: settings,
            homeCoordinatorDelegate: delegate
        )
        Self.leakBag.append(boardSheet)

        boardSheet.handle(.selectSize(6))

        XCTAssertEqual(home.boardSize, 6, "after selecting in sheet Home shows new size")
        XCTAssertEqual(delegate.actions.count, 1)
        guard case .dismissSheet = delegate.actions[0] else {
            XCTFail("Expected .dismissSheet after selectSize, got \(delegate.actions)")
            return
        }
    }

    func test_totalGames_returnsCountFromHistory() {
        let (settings, history, delegate) = makeMocks()
        history.games = [Sample.game(), Sample.game()]
        let sut = makeSut(settings: settings, history: history, delegate: delegate)
        XCTAssertEqual(sut.totalGames, 2)
    }

    func test_streakCount_returnsValueFromHistory() {
        let (settings, history, delegate) = makeMocks()
        history.streakCount = 5
        let sut = makeSut(settings: settings, history: history, delegate: delegate)
        XCTAssertEqual(sut.streakCount, 5)
    }

    // MARK: - Actions → delegate

    func test_handleOpenGame_sendsOpenGameNewToDelegate() {
        let (settings, history, delegate) = makeMocks()
        let sut = makeSut(settings: settings, history: history, delegate: delegate)
        sut.handle(.openGame)
        XCTAssertEqual(delegate.actions.count, 1)
        guard case .openGame(let type) = delegate.actions[0], case .new = type else {
            XCTFail("Expected .openGame(.new), got \(delegate.actions)")
            return
        }
    }

    func test_handlePresentGameHistory_sendsPresentGameHistoryToDelegate() {
        let (settings, history, delegate) = makeMocks()
        let sut = makeSut(settings: settings, history: history, delegate: delegate)
        sut.handle(.presentGameHistory)
        XCTAssertEqual(delegate.actions.count, 1)
        guard case .presentGameHistory = delegate.actions[0] else {
            XCTFail("Expected .presentGameHistory, got \(delegate.actions)")
            return
        }
    }

    func test_handleOpenBoardSizeSheet_sendsOpenBoardSizeSheetToDelegate() {
        let (settings, history, delegate) = makeMocks()
        let sut = makeSut(settings: settings, history: history, delegate: delegate)
        sut.handle(.openBoardSizeSheet)
        XCTAssertEqual(delegate.actions.count, 1)
        guard case .openBoardSizeSheet = delegate.actions[0] else {
            XCTFail("Expected .openBoardSizeSheet, got \(delegate.actions)")
            return
        }
    }

    func test_handleWithNilDelegate_doesNotCrash() {
        let (settings, history) = makeMocksWithoutDelegate()
        let sut = makeSut(settings: settings, history: history, delegate: nil)
        sut.handle(.openGame)
        sut.handle(.presentGameHistory)
        sut.handle(.openBoardSizeSheet)
    }
}
