//
//  View+CardStyle.swift
//  NQueens
//
//  Created by Anton Makarov on 02.03.2026.
//

import SwiftUI

extension View {

    func cardStyle() -> some View {
        background(ColorToken.backgroundCard, in: RoundedRectangle(cornerRadius: LayoutToken.cornerRadius16))
            .overlay(
                RoundedRectangle(cornerRadius: LayoutToken.cornerRadius16)
                    .stroke(ColorToken.backgroundElevated, lineWidth: LayoutToken.borderWidth)
            )
    }
}
