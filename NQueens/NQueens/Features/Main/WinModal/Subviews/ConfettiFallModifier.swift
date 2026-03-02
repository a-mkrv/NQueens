//
//  ConfettiFallModifier.swift
//  NQueens
//
//  Created by makarovant on 02.03.2026.
//

import SwiftUI

struct ConfettiFallModifier: ViewModifier {
    
    // MARK: - Properties
    
    let delay: Double
    let duration: Double
    let height: CGFloat

    @State private var hasTriggered = false
    @State private var rotationDegrees: Double = 0

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .offset(y: hasTriggered ? height + 40 : 0)
            .opacity(hasTriggered ? 0 : 1)
            .rotationEffect(.degrees(rotationDegrees))
            .onAppear {
                rotationDegrees = Double.random(in: 180...360)
                guard !hasTriggered else { return }
                
                withAnimation(
                    .easeIn(duration: duration)
                    .delay(delay)
                ) {
                    hasTriggered = true
                }
            }
    }
}
