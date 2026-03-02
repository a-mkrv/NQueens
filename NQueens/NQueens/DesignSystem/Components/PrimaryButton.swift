//
//  PrimaryButton.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

struct PrimaryButton: View {

    // MARK: - Properties

    enum Size {
        case large
        case compact
    }

    private let size: Size
    private let title: String
    private let imageName: String?
    private let onTapAction: () -> Void

    private var cornerRadius: CGFloat {
        switch size {
        case .large:
            return LayoutToken.cornerRadius16
        case .compact:
            return LayoutToken.cornerRadius12
        }
    }

    private var verticalPadding: CGFloat {
        switch size {
        case .large:
            return LayoutToken.padding20
        case .compact:
            return LayoutToken.padding14
        }
    }

    // MARK: - Init

    init(
        size: Size = .large,
        title: String,
        imageName: String? = nil,
        onTapAction: @escaping () -> Void
    ) {
        self.size = size
        self.title = title
        self.imageName = imageName
        self.onTapAction = onTapAction
    }

    // MARK: - Body

    var body: some View {
        Button {
            onTapAction()
        } label: {
            HStack(spacing: LayoutToken.spacing8) {
                if let imageName {
                    Image(systemName: imageName)
                }
                Text(title)
                    .font(size == .large ? TextToken.titleL : TextToken.titleS)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, verticalPadding)
            .background(ColorToken.green, in: RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                LinearGradient(
                    colors: [.white.opacity(0.12), .clear],
                    startPoint: .top,
                    endPoint: .center
                )
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            )
            .shadow(color: ColorToken.green.opacity(0.4), radius: LayoutToken.shadowRadiusM, y: LayoutToken.spacing2)
        }
    }
}
