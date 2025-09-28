//
//  ArtworkCardView.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import SwiftUI
import Kingfisher

// MARK: - Artwork Card Component
// Extracted artwork card into separate component for better organization
struct ArtworkCardView: View {
    let artwork: Artwork
    @State private var showPlaceholder = false
    @State private var timeoutTimer: Timer?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // MARK: - Enhanced Image Display
            // Improved image loading with better placeholder and animations
            if let url = IIIF.imageURL(for: artwork.imageID, sizeSegment: "full/200,") {
                KFImage(url)
                    .resizable()
                    .placeholder {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.secondaryBackground)
                            .overlay(
                                ProgressView()
                                    .scaleEffect(0.8)
                            )
                    }
                    .cancelOnDisappear(true)
                    .aspectRatio(1, contentMode: .fill)
                    .clipped()
                    .cornerRadius(12)
                    .shadow(color: AppColors.shadow, radius: 4, x: 0, y: 2)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.secondaryBackground)
                    .aspectRatio(1, contentMode: .fill)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(AppColors.secondaryText)
                            .font(AppFonts.Display.title2)
                    )
            }
            
            // MARK: - Enhanced Text Display
            // Improved typography and layout for artwork information
            VStack(alignment: .leading, spacing: 4) {
                Text(artwork.title ?? "Untitled")
                    .font(AppFonts.Card.title)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                
                if let artist = artwork.artistTitle {
                    Text(artist)
                        .font(AppFonts.Card.subtitle)
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(1)
                }
            }
        }
        .background(AppColors.surface)
    }
}

#Preview {
    ArtworkCardView(artwork: Artwork(
        id: 1,
        title: "Sample Artwork",
        date: "1888",
        description: "This is a sample artwork description.",
        artistTitle: "Sample Artist",
        imageID: "sample-id"
    ))
    .padding()
}
