import Foundation
@testable import NQueens

// MARK: - Sample data

enum Sample {
    static let placement4x4: [QueenPosition] = [
        QueenPosition(row: 0, col: 1),
        QueenPosition(row: 1, col: 3),
        QueenPosition(row: 2, col: 0),
        QueenPosition(row: 3, col: 2),
    ]

    static func game(
        id: UUID = UUID(),
        boardSize: Int = 4,
        moveCount: Int = 4,
        placements: [QueenPosition] = placement4x4,
        durationSeconds: Int = 10,
        date: Date = Date(),
        solvedWithHint: Bool = false
    ) -> GameHistoryItemModel {
        GameHistoryItemModel(
            id: id,
            boardSize: boardSize,
            moveCount: moveCount,
            placements: placements,
            durationSeconds: durationSeconds,
            date: date,
            solvedWithHint: solvedWithHint
        )
    }
}

// MARK: - Struct mocks (optional: avoid existential class in @Observable to prevent malloc crash)

struct StructMockSettingsService: ISettingsService {
    var boardSize: Int = 8
    var queenStyle: QueenStyle = .queen_1
    let availableSizes: [Int] = [4, 6, 8, 10]

    func updateBoardSize(_ size: Int) {}
    func updateQueenStyle(_ style: QueenStyle) {}
}

struct StructMockGameHistoryService: IGameHistoryService {
    var gamesCount: Int { games.count }
    var streakCount: Int = 0
    var games: [GameHistoryItemModel] = Array(AnyIterator<GameHistoryItemModel> { nil })

    func addGame(_ item: GameHistoryItemModel) {}
    func clearAllGames() {}
}

// MARK: - Mock Settings Service (class)

final class MockSettingsService: ISettingsService {
    var boardSize: Int = 8
    var queenStyle: QueenStyle = .queen_1
    let availableSizes: [Int] = [4, 6, 8, 10]

    func updateBoardSize(_ size: Int) {
        boardSize = size
    }

    func updateQueenStyle(_ style: QueenStyle) {
        queenStyle = style
    }
}

// MARK: - Mock Game History Service

final class MockGameHistoryService: IGameHistoryService {
    private var storage: [GameHistoryItemModel]?

    var games: [GameHistoryItemModel] {
        get {
            guard let s = storage else { return Array(AnyIterator<GameHistoryItemModel> { nil }) }
            return s.map { $0 }
        }
        set { storage = newValue.isEmpty ? nil : newValue }
    }

    var gamesCount: Int { storage?.count ?? 0 }
    var streakCount: Int = 0

    var addedGames: [GameHistoryItemModel] = []
    var clearAllCalled = false

    func addGame(_ item: GameHistoryItemModel) {
        if storage == nil { storage = Array(AnyIterator<GameHistoryItemModel> { nil }) }
        storage!.insert(item, at: 0)
        addedGames.append(item)
    }

    func clearAllGames() {
        storage = nil
        clearAllCalled = true
    }
}

// MARK: - Mock Game Validation Service

@MainActor
final class MockGameValidationService: IGameValidationService {
    var conflictLinesResult: Set<QueenPosition> = []
    var conflictPositionsResult: Set<QueenPosition> = []
    var hintPositionsResult: Set<QueenPosition> = []
    var isWonResult = false

    func conflictLines(placements: Set<QueenPosition>, boardSize: Int) -> Set<QueenPosition> {
        conflictLinesResult
    }

    func conflictPositions(placements: Set<QueenPosition>) -> Set<QueenPosition> {
        conflictPositionsResult
    }

    func hintPositions(placements: Set<QueenPosition>, boardSize: Int) -> Set<QueenPosition> {
        hintPositionsResult
    }

    func isWon(placements: Set<QueenPosition>, boardSize: Int) -> Bool {
        isWonResult
    }
}

// MARK: - Mock Home Coordinator Delegate

final class MockHomeCoordinatorDelegate: HomeCoordinatorDelegate {
    var actions: [HomeCoordinator.Action] = Array(AnyIterator<HomeCoordinator.Action> { nil })

    func handle(_ action: HomeCoordinator.Action) {
        actions.append(action)
    }
}
