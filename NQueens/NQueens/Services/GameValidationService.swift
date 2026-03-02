//
//  GameValidationService.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import Foundation

protocol IGameValidationService {
    func conflictLines(placements: Set<QueenPosition>, boardSize: Int) -> Set<QueenPosition>
    func conflictPositions(placements: Set<QueenPosition>) -> Set<QueenPosition>
    func hintPositions(placements: Set<QueenPosition>, boardSize: Int) -> Set<QueenPosition>
    func isWon(placements: Set<QueenPosition>, boardSize: Int) -> Bool
}

final class GameValidationService: IGameValidationService {

    func conflictLines(placements: Set<QueenPosition>, boardSize: Int) -> Set<QueenPosition> {
        
        let queens = Array(placements)
        var lines = Set<QueenPosition>()
        let n = boardSize

        for i in 0..<queens.count {
            for j in (i + 1)..<queens.count {
                let p = queens[i], q = queens[j]

                if p.row == q.row {
                    for c in 0..<n { lines.insert(QueenPosition(row: p.row, col: c)) }
                }
                if p.col == q.col {
                    for r in 0..<n { lines.insert(QueenPosition(row: r, col: p.col)) }
                }
                if abs(p.row - q.row) == abs(p.col - q.col) {
                    let dr = q.row > p.row ? 1 : -1
                    let dc = q.col > p.col ? 1 : -1
                    addDiagonalLine(from: p, dr: dr, dc: dc, n: n, into: &lines)
                    addDiagonalLine(from: p, dr: -dr, dc: -dc, n: n, into: &lines)
                }
            }
        }
        return lines
    }

    func conflictPositions(placements: Set<QueenPosition>) -> Set<QueenPosition> {
        
        let queens = Array(placements)
        var result = Set<QueenPosition>()
        
        for i in 0..<queens.count {
            for j in (i + 1)..<queens.count {
                if attacking(queens[i], queens[j]) {
                    result.insert(queens[i])
                    result.insert(queens[j])
                }
            }
        }
        return result
    }

    func hintPositions(placements: Set<QueenPosition>, boardSize: Int) -> Set<QueenPosition> {
       
        var hintPos = Set<QueenPosition>()
        
        for q in placements {
            for r in 0..<boardSize {
                for c in 0..<boardSize {
                    let pos = QueenPosition(row: r, col: c)
                    if placements.contains(pos) { continue }
                    if attacking(q, pos) {
                        hintPos.insert(pos)
                    }
                }
            }
        }
        return hintPos
    }

    func isWon(placements: Set<QueenPosition>, boardSize: Int) -> Bool {
        placements.count == boardSize && conflictPositions(placements: placements).isEmpty
    }

    // MARK: - Private

    private func attacking(_ p: QueenPosition, _ q: QueenPosition) -> Bool {
        p.row == q.row || p.col == q.col || abs(p.row - q.row) == abs(p.col - q.col)
    }

    private func addDiagonalLine(from p: QueenPosition, dr: Int, dc: Int, n: Int, into set: inout Set<QueenPosition>) {
        var r = p.row, c = p.col
        while r >= 0, r < n, c >= 0, c < n {
            set.insert(QueenPosition(row: r, col: c))
            r += dr
            c += dc
        }
    }
}
