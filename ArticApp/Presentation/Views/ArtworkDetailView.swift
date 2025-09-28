//
//  ArtworkDetailView.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import SwiftUI
import Kingfisher

struct ArtworkDetailView: View {
    @StateObject private var viewModel: ArtworkDetailViewModel
    @State private var isImageLoaded = false
    
    init(artwork: Artwork) {
        let dependencies = AppDependencies.shared
        _viewModel = StateObject(wrappedValue: dependencies.createArtworkDetailViewModel(artwork: artwork))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // MARK: - Enhanced Image Display with Animation
                // Added image loading animation and full-screen view capability
                Group {
                    if let url = viewModel.imageURL {
                        KFImage(url)
                            .onSuccess { result in
                                // Image loaded successfully, trigger animation
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    isImageLoaded = true
                                }
                            }
                            .resizable()
                            .placeholder {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppColors.secondaryBackground)
                                    .overlay(
                                        ProgressView()
                                            .scaleEffect(1.2)
                                    )
                                    .frame(height: 300)
                            }
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(16)
                            .shadow(color: AppColors.shadowDark, radius: 8, x: 0, y: 4)
                            .scaleEffect(isImageLoaded ? 1.0 : 0.95)
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.secondaryBackground)
                            .frame(height: 300)
                            .overlay(
                                VStack(spacing: 8) {
                                    Image(systemName: "photo")
                                        .font(.system(size: 48))
                                        .foregroundColor(AppColors.secondaryText)
                                    Text("No Image Available")
                                        .font(AppFonts.Caption.regular)
                                        .foregroundColor(AppColors.secondaryText)
                                }
                            )
                    }
                }
                
                // MARK: - Enhanced Information Layout
                // Improved typography and layout for artwork information
                VStack(alignment: .leading, spacing: 16) {
                    // Title with animation
                    Text(viewModel.displayTitle)
                        .font(AppFonts.Display.title)
                        .foregroundColor(AppColors.text)
                        .opacity(isImageLoaded ? 1 : 0)
                        .offset(y: isImageLoaded ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.2), value: isImageLoaded)
                    
                    // Artist information
                    HStack(spacing: 8) {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(AppColors.primary)
                        Text(viewModel.displayArtist)
                            .font(AppFonts.Display.title2)
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .opacity(isImageLoaded ? 1 : 0)
                    .offset(y: isImageLoaded ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.4), value: isImageLoaded)
                    
                    // Date information
                    HStack(spacing: 8) {
                        Image(systemName: "calendar.circle.fill")
                            .foregroundColor(AppColors.secondary)
                        Text(viewModel.displayDate)
                            .font(AppFonts.Display.title3)
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .opacity(isImageLoaded ? 1 : 0)
                    .offset(y: isImageLoaded ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.6), value: isImageLoaded)
                    
                    Divider()
                        .opacity(isImageLoaded ? 1 : 0)
                        .animation(.easeOut(duration: 0.6).delay(0.8), value: isImageLoaded)
                    
                    // Description with enhanced styling
                    if !viewModel.displayDescription.isEmpty && viewModel.displayDescription != "No description available" {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("About This Artwork")
                                .font(AppFonts.Headline.regular)
                            
                            Text(viewModel.displayDescription)
                                .font(AppFonts.Body.regular)
                                .foregroundColor(AppColors.secondaryText)
                                .lineSpacing(4)
                        }
                        .opacity(isImageLoaded ? 1 : 0)
                        .offset(y: isImageLoaded ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(1.0), value: isImageLoaded)
                    }
                }
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .onAppear {
            // If no image URL, trigger animation immediately
            if viewModel.artwork.imageID == nil {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isImageLoaded = true
                }
            }
        }
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        NavigationStack {
            ArtworkDetailView(artwork: Artwork(
                id: 1,
                title: "Sample Artwork",
                date: "1888",
                description: "This is a sample artwork description that provides context and information about the piece.",
                artistTitle: "Sample Artist",
                imageID: "sample-id"
            ))
        }
    } else {
        NavigationView {
            ArtworkDetailView(artwork: Artwork(
                id: 1,
                title: "Sample Artwork",
                date: "1888",
                description: "This is a sample artwork description that provides context and information about the piece.",
                artistTitle: "Sample Artist",
                imageID: "sample-id"
            ))
        }
    }
}
