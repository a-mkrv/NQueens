//
//  GameValidationServiceTests.swift
//  NQueensTests
//

import XCTest
@testable import NQueens

@MainActor
final class GameValidationServiceTests: XCTestCase {

    private var sut: GameValidationService!

    override func setUp() {
        super.setUp()
        sut = GameValidationService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - conflictPositions

    func test_conflictPositions_empty_returnsEmpty() {
        XCTAssertTrue(sut.conflictPositions(placements: []).isEmpty)
    }

    func test_conflictPositions_singleQueen_returnsEmpty() {
        let result = sut.conflictPositions(placements: [QueenPosition(row: 0, col: 0)])
        XCTAssertTrue(result.isEmpty)
    }

    func test_conflictPositions_sameRow_returnsBoth() {
        let a = QueenPosition(row: 1, col: 0)
        let b = QueenPosition(row: 1, col: 3)
        let result = sut.conflictPositions(placements: [a, b])
        XCTAssertEqual(result, Set([a, b]))
    }

    func test_conflictPositions_sameColumn_returnsBoth() {
        let a = QueenPosition(row: 0, col: 2)
        let b = QueenPosition(row: 3, col: 2)
        let result = sut.conflictPositions(placements: [a, b])
        XCTAssertEqual(result, Set([a, b]))
    }

    func test_conflictPositions_sameDiagonal_returnsBoth() {
        let a = QueenPosition(row: 0, col: 0)
        let b = QueenPosition(row: 2, col: 2)
        let result = sut.conflictPositions(placements: [a, b])
        XCTAssertEqual(result, Set([a, b]))
    }

    func test_conflictPositions_valid4x4_returnsEmpty() {
        let placements: Set<QueenPosition> = Set(Sample.placement4x4)
        XCTAssertTrue(sut.conflictPositions(placements: placements).isEmpty)
    }

    // MARK: - isWon

    func test_isWon_empty_returnsFalse() {
        XCTAssertFalse(sut.isWon(placements: [], boardSize: 4))
    }

    func test_isWon_fewerQueensThanSize_returnsFalse() {
        let placements: Set<QueenPosition> = [
            QueenPosition(row: 0, col: 1),
            QueenPosition(row: 1, col: 3),
        ]
        XCTAssertFalse(sut.isWon(placements: placements, boardSize: 4))
    }

    func test_isWon_withConflict_returnsFalse() {
        let placements: Set<QueenPosition> = [
            QueenPosition(row: 0, col: 0),
            QueenPosition(row: 1, col: 1),
            QueenPosition(row: 2, col: 2),
            QueenPosition(row: 3, col: 3),
        ]
        XCTAssertFalse(sut.isWon(placements: placements, boardSize: 4))
    }

    func test_isWon_valid4x4_returnsTrue() {
        let placements: Set<QueenPosition> = Set(Sample.placement4x4)
        XCTAssertTrue(sut.isWon(placements: placements, boardSize: 4))
    }

    func test_isWon_valid8x8_returnsTrue() {
        let placements: Set<QueenPosition> = [
            QueenPosition(row: 0, col: 0),
            QueenPosition(row: 1, col: 4),
            QueenPosition(row: 2, col: 7),
            QueenPosition(row: 3, col: 5),
            QueenPosition(row: 4, col: 2),
            QueenPosition(row: 5, col: 6),
            QueenPosition(row: 6, col: 1),
            QueenPosition(row: 7, col: 3),
        ]
        XCTAssertTrue(sut.isWon(placements: placements, boardSize: 8))
    }

    // MARK: - conflictLines

    func test_conflictLines_empty_returnsEmpty() {
        XCTAssertTrue(sut.conflictLines(placements: [], boardSize: 4).isEmpty)
    }

    func test_conflictLines_twoSameRow_includesFullRow() {
        let a = QueenPosition(row: 2, col: 0)
        let b = QueenPosition(row: 2, col: 3)
        let result = sut.conflictLines(placements: [a, b], boardSize: 4)
        for col in 0..<4 {
            XCTAssertTrue(result.contains(QueenPosition(row: 2, col: col)))
        }
    }

    func test_conflictLines_twoSameColumn_includesFullColumn() {
        let a = QueenPosition(row: 0, col: 1)
        let b = QueenPosition(row: 3, col: 1)
        let result = sut.conflictLines(placements: [a, b], boardSize: 4)
        for row in 0..<4 {
            XCTAssertTrue(result.contains(QueenPosition(row: row, col: 1)))
        }
    }

    // MARK: - hintPositions

    func test_hintPositions_empty_returnsEmpty() {
        XCTAssertTrue(sut.hintPositions(placements: [], boardSize: 4).isEmpty)
    }

    func test_hintPositions_oneQueen_includesAttackedCells() {
        let queen = QueenPosition(row: 1, col: 1)
        let result = sut.hintPositions(placements: [queen], boardSize: 4)
        XCTAssertTrue(result.contains(QueenPosition(row: 1, col: 0)))
        XCTAssertTrue(result.contains(QueenPosition(row: 1, col: 2)))
        XCTAssertTrue(result.contains(QueenPosition(row: 0, col: 1)))
        XCTAssertTrue(result.contains(QueenPosition(row: 2, col: 1)))
        XCTAssertTrue(result.contains(QueenPosition(row: 0, col: 0)))
        XCTAssertTrue(result.contains(QueenPosition(row: 2, col: 2)))
        XCTAssertFalse(result.contains(queen))
    }
}
