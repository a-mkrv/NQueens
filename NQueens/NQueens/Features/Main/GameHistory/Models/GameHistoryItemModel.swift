//
//  GameHistoryItemModel.swift
//  NQueens
//
//  Created by Anton Makarov on 01.03.2026.
//

import Foundation

struct GameHistoryItemModel: Identifiable, Equatable, Hashable {
    
    let id: UUID
    let boardSize: Int
    let moveCount: Int
    let placements: [QueenPosition]
    let durationSeconds: Int
    let date: Date
    let solvedWithHint: Bool

    var efficiency: Int {
        guard moveCount > 0 else { return 0 }
        return min(100, Int(Double(boardSize) / Double(moveCount) * 100))
    }
    
    var formattedDuration: String {
        let m = durationSeconds / 60
        let s = durationSeconds % 60
        return String(format: "%d:%02d", m, s)
    }

    var formattedDate: String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        f.locale = Locale(identifier: "en_US")
        return f.string(from: date)
    }
}

// MARK: - Mocks

extension GameHistoryItemModel {
    static let mocks: [GameHistoryItemModel] = [
        .init(
            id: UUID(),
            boardSize: 10,
            moveCount: 215,
            placements : [
                .init(row: 0, col: 4), .init(row: 1, col: 7),
                .init(row: 2, col: 1), .init(row: 3, col: 9)
            ],
            durationSeconds: 10,
            date: .now - 86400 * 2,
            solvedWithHint: false
        ),
        .init(
            id: UUID(),
            boardSize: 8,
            moveCount: 95,
            placements: [
                .init(row: 0, col: 4), .init(row: 1, col: 0),
                .init(row: 2, col: 7), .init(row: 3, col: 5),
                .init(row: 4, col: 2), .init(row: 5, col: 6),
                .init(row: 6, col: 1), .init(row: 7, col: 3)
            ],
            durationSeconds: 83,
            date: .now - 86400 * 3,
            solvedWithHint: true
        ),
    ]
}
