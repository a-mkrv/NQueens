//
//  View+ClipRounded.swift
//  NQueens
//

import SwiftUI

extension View {

    func clipRounded(with radius: CGFloat) -> some View {
        clipShape(RoundedRectangle(cornerRadius: radius))
    }
}
