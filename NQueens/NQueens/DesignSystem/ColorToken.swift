//
//  ColorToken.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

struct ColorToken {
    
    // MARK: - Background
    
    static let backgroundMain = Color(hex: "1C1C1E")
    static let backgroundCard = Color(hex: "2C2C2E")
    static let backgroundElevated = Color(hex: "3A3A3C")

    // MARK: - Accent
    
    static let green = Color(hex: "6AAE3A")
    static let greenDark = Color(hex: "3A7A1A")
    static let yellow = Color(hex: "FFD60A")

    // MARK: - Text
    
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.5)
}

// MARK: - Hex Extension

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
