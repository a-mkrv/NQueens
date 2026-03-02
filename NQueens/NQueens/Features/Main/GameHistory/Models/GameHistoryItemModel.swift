//
//  GameHistoryItemModel.swift
//  NQueens
//
//  Created by Anton Makarov on 01.03.2026.
//

import Foundation

struct GameHistoryItemModel: Identifiable, Equatable, Hashable, Codable {
    
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

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        f.locale = Locale(identifier: "en_US")
        return f
    }()

    var formattedDate: String {
        Self.dateFormatter.string(from: date)
    }
}
