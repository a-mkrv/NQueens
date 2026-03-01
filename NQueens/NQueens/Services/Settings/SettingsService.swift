//
//  SettingsService.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

protocol ISettingsService {
    var boardSize: Int { get }
    var availableSizes: [Int] { get }
    var queenStyle: QueenStyle { get set }
    
    func updateBoardSize(_ size: Int)
}

@Observable
final class SettingsService: ISettingsService {
    
    var boardSize: Int = .defaultBoardSize
    var queenStyle: QueenStyle = .queen_1
    
    let availableSizes: [Int] = [4, 6, 8, 10]

    func updateBoardSize(_ size: Int) {
        boardSize = size
    }
}

// MARK: - Constants

private extension Int {
    static let defaultBoardSize: Int = 8
}
