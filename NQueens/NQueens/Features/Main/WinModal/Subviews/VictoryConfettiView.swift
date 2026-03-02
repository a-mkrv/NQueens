//
//  VictoryConfettiView.swift
//  NQueens
//
//  Created by Anton Makarov on 02.03.2026.
//

import SwiftUI

struct VictoryConfettiView: View {
    private static let colors: [Color] = [
        ColorToken.yellow,
        ColorToken.green,
        ColorToken.orange,
        ColorToken.white.opacity(0.9),
    ]

    private static let particleCount = 24

    let trigger: Bool

    var body: some View {
        GeometryReader { geo in
            if trigger {
                ForEach(0..<Self.particleCount, id: \.self) { i in
                    confettiParticle(index: i, width: geo.size.width, height: geo.size.height)
                }
                .allowsHitTesting(false)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func confettiParticle(index: Int, width: CGFloat, height: CGFloat) -> some View {
        let color = Self.colors[index % Self.colors.count]
        let size = CGFloat([6, 8, 10].randomElement() ?? 8)
        let startX = width * (0.2 + CGFloat(index % 10) / 12)
        let delay = Double(index % 6) * 0.06
        let duration = 1.2 + Double(index % 4) * 0.2

        return Circle()
            .fill(color)
            .frame(width: size, height: size)
            .position(x: startX + CGFloat((index % 5) * 4) - 10, y: -20)
            .modifier(ConfettiFallModifier(delay: delay, duration: duration, height: height))
    }
}
