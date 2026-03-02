//
//  SettingsService.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import Foundation

protocol ISettingsService {
    var availableSizes: [Int] { get }

    var boardSize: Int { get }
    var queenStyle: QueenStyle { get }

    func updateBoardSize(_ size: Int)
    func updateQueenStyle(_ style: QueenStyle)
}

@Observable
final class SettingsService: ISettingsService {

    // MARK: - Properties

    private enum SettingsStorage {
        static let boardSizeKey = "settings.boardSize"
        static let queenStyleKey = "settings.queenStyle"
    }

    private(set) var boardSize: Int
    private(set) var queenStyle: QueenStyle

    let availableSizes: [Int] = [4, 6, 8, 10]

    init() {
        let storedSize = UserDefaults.standard.object(forKey: SettingsStorage.boardSizeKey) as? Int
        self.boardSize = storedSize ?? .defaultBoardSize

        let storedStyle = UserDefaults.standard.string(forKey: SettingsStorage.queenStyleKey)
        self.queenStyle = (storedStyle.flatMap(QueenStyle.init(rawValue:)) ?? .queen_1)
    }

    // MARK: - Public

    func updateBoardSize(_ size: Int) {
        boardSize = size
        UserDefaults.standard.set(boardSize, forKey: SettingsStorage.boardSizeKey)
    }

    func updateQueenStyle(_ style: QueenStyle) {
        queenStyle = style
        UserDefaults.standard.set(queenStyle.rawValue, forKey: SettingsStorage.queenStyleKey)
    }
}

// MARK: - Constants

private extension Int {
    static let defaultBoardSize: Int = 8
}
