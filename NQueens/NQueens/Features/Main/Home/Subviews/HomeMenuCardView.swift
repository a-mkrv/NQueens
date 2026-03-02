//
//  HomeMenuCardView.swift
//  NQueens
//
//  Created by makarovant on 02.03.2026.
//

import SwiftUI

struct HomeMenuCardView: View {
    
    // MARK: - Properties
    
    enum ImageType {
        case emoji(name: String)
        case resource(name: String)
    }
    
    private let image: ImageType
    private let title: String
    private let subtitle: String
    private let showsDisclosure: Bool
    
    // MARK: - Init

    init(
        image: ImageType,
        title: String,
        subtitle: String,
        showsDisclosure: Bool = true
    ) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.showsDisclosure = showsDisclosure
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: LayoutToken.spacing12) {
            
            switch image {
            case .emoji(let name):
                ZStack {
                    RoundedRectangle(cornerRadius: LayoutToken.cornerRadius12)
                        .fill(ColorToken.backgroundGray.opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: LayoutToken.cornerRadius12)
                                .stroke(ColorToken.backgroundGray.opacity(0.2), lineWidth: LayoutToken.borderWidth)
                        )
                    Text(name)
                }
                .frame(squared: .imageSize)
                
            case .resource(let name):
                Image(name)
                    .resizable()
                    .frame(squared: .imageSize)
                    .clipRounded(with: LayoutToken.cornerRadius12)
            }
            
            VStack(alignment: .leading, spacing: LayoutToken.spacing2) {
                Text(title)
                    .font(TextToken.titleS)
                    .foregroundStyle(ColorToken.textPrimary)
                Text(subtitle)
                    .font(TextToken.captionM)
                    .foregroundStyle(ColorToken.textSecondary)
            }
            
            Spacer()
            
            if showsDisclosure {
                Image(systemName: "chevron.down")
                    .font(TextToken.titleS)
                    .foregroundStyle(ColorToken.textSecondary)
            }
        }
        .padding(LayoutToken.padding16)
        .cardStyle()
    }
}

// MARK: - Constants

private extension CGFloat {
    static let imageSize: CGFloat = 44
}
