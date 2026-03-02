//
//  View+FrameSquared.swift
//  NQueens
//
//  Created by Anton Makarov on 02.03.2026.
//

import SwiftUI

extension View {

    func frame(squared size: CGFloat) -> some View {
        frame(width: size, height: size)
    }
}
