//
//  NavigationFlowTests.swift
//  NQueensTests
//

import XCTest
@testable import NQueens

/// Navigation/integration tests: real coordinator + real dependencies.
/// Coordinator and view models are kept in leakBag to avoid @Observable dealloc crash in tests.
@MainActor
final class NavigationFlowTests: XCTestCase {

    private static var leakBag: [Any] = []

    // MARK: - Open game

    func test_openGame_pushesGameDestination() {
        let deps = AppDependencies()
        deps.settingsService.updateBoardSize(4)
        let coordinator = HomeCoordinator(dependencies: deps)
        Self.leakBag.append(coordinator)

        coordinator.handle(.openGame(.new))

        XCTAssertEqual(coordinator.path, [.game(.new)])
    }

    func test_presentGameHistory_pushesGameHistoryDestination() {
        let deps = AppDependencies()
        let coordinator = HomeCoordinator(dependencies: deps)
        Self.leakBag.append(coordinator)

        coordinator.handle(.presentGameHistory)

        XCTAssertEqual(coordinator.path, [.gameHistory])
    }

    func test_openBoardSizeSheet_presentsSheet() {
        let deps = AppDependencies()
        let coordinator = HomeCoordinator(dependencies: deps)
        Self.leakBag.append(coordinator)

        coordinator.handle(.openBoardSizeSheet)

        XCTAssertEqual(coordinator.sheet, .boardSize)
    }

    // MARK: - Win flow: open game → place queens → win → counter increases

    func test_winGame_incrementsHistoryAndPresentsWinModal() {
        let deps = AppDependencies()
        deps.gameHistoryService.clearAllGames()
        deps.settingsService.updateBoardSize(4)
        let coordinator = HomeCoordinator(dependencies: deps)
        Self.leakBag.append(coordinator)

        coordinator.handle(.openGame(.new))
        let gameVM = coordinator.makeGameViewModel(for: .new)
        Self.leakBag.append(gameVM)

        for pos in Sample.placement4x4 {
            gameVM.handle(.tapCell(pos))
        }

        XCTAssertTrue(gameVM.isWon)
        XCTAssertEqual(deps.gameHistoryService.gamesCount, 1)
        if case .winModal = coordinator.sheet { /* ok */ } else {
            XCTFail("Expected winModal sheet, got \(String(describing: coordinator.sheet))")
        }
    }

    func test_afterWin_dismissSheet_homeShowsUpdatedTotalGames() {
        let deps = AppDependencies()
        deps.gameHistoryService.clearAllGames()
        deps.settingsService.updateBoardSize(4)
        let coordinator = HomeCoordinator(dependencies: deps)
        Self.leakBag.append(coordinator)

        coordinator.handle(.openGame(.new))
        let gameVM = coordinator.makeGameViewModel(for: .new)
        Self.leakBag.append(gameVM)
        for pos in Sample.placement4x4 { gameVM.handle(.tapCell(pos)) }
        coordinator.handle(.dismissSheet)

        let totalGames = coordinator.homeViewModel.totalGames
        XCTAssertEqual(totalGames, 1)
    }

    func test_afterWin_backToHome_pathIsEmpty() {
        let deps = AppDependencies()
        deps.settingsService.updateBoardSize(4)
        let coordinator = HomeCoordinator(dependencies: deps)
        Self.leakBag.append(coordinator)

        coordinator.handle(.openGame(.new))
        let gameVM = coordinator.makeGameViewModel(for: .new)
        Self.leakBag.append(gameVM)
        for pos in Sample.placement4x4 { gameVM.handle(.tapCell(pos)) }
        coordinator.handle(.dismissSheet)
        coordinator.handle(.back)

        XCTAssertTrue(coordinator.path.isEmpty)
    }

    // MARK: - Back / dismiss

    func test_backFromGame_popsPath() {
        let deps = AppDependencies()
        let coordinator = HomeCoordinator(dependencies: deps)
        Self.leakBag.append(coordinator)

        coordinator.handle(.openGame(.new))
        XCTAssertEqual(coordinator.path.count, 1)
        coordinator.handle(.back)

        XCTAssertTrue(coordinator.path.isEmpty)
    }

    func test_dismissSheet_clearsSheet() {
        let deps = AppDependencies()
        let coordinator = HomeCoordinator(dependencies: deps)
        Self.leakBag.append(coordinator)

        coordinator.handle(.openBoardSizeSheet)
        XCTAssertNotNil(coordinator.sheet)
        coordinator.handle(.dismissSheet)

        XCTAssertNil(coordinator.sheet)
    }

    // MARK: - Play again

    func test_playAgain_afterWin_popsAndPushesNewGame() {
        let deps = AppDependencies()
        deps.settingsService.updateBoardSize(4)
        let coordinator = HomeCoordinator(dependencies: deps)
        Self.leakBag.append(coordinator)

        coordinator.handle(.openGame(.new))
        let gameVM = coordinator.makeGameViewModel(for: .new)
        Self.leakBag.append(gameVM)
        for pos in Sample.placement4x4 { gameVM.handle(.tapCell(pos)) }
        coordinator.handle(.dismissSheet)
        coordinator.handle(.playAgain(boardSize: 4))

        XCTAssertEqual(coordinator.path, [.game(.new)])
        XCTAssertEqual(deps.settingsService.boardSize, 4)
    }

    // MARK: - Streak

    func test_streakCount_increasesWithConsecutiveDayGames() {
        let deps = AppDependencies()
        let coordinator = HomeCoordinator(dependencies: deps)
        Self.leakBag.append(coordinator)

        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        deps.gameHistoryService.addGame(Sample.game(date: yesterday))
        deps.gameHistoryService.addGame(Sample.game(date: today))

        let streak = coordinator.homeViewModel.streakCount
        XCTAssertGreaterThanOrEqual(streak, 2)
    }
}
