//
//  TapticEngine.swift
//  NQueens
//
//  Created by Anton Makarov on 02.03.2026.
//

import UIKit

enum TapticEngine {

    // MARK: - Types
    
    enum TapticType {
        case queenPlacement
        case victory
    }
    
    // MARK: - Public
    
    static func feedback(tapticType: TapticType) {
        switch tapticType {
        case .queenPlacement:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        case .victory:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
}
