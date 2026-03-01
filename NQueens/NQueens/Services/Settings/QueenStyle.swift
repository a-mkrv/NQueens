//
//  QueenStyle.swift
//  NQueens
//
//  Created by makarovant on 01.03.2026.
//

import SwiftUI

enum QueenStyle: String, CaseIterable, Identifiable {
    case queen_1
    case queen_2
    case queen_3
    case queen_4
    
    var id: String { rawValue }
    var imageName: String {
        self.rawValue
    }
}
