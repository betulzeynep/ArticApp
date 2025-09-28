//
//  ArtworkDetailViewModel.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import Foundation
import Combine

@MainActor
final class ArtworkDetailViewModel: ObservableObject {
    @Published var artwork: Artwork
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let loggingService: LoggingService
    
    init(artwork: Artwork, loggingService: LoggingService) {
        self.artwork = artwork
        self.loggingService = loggingService
    }
    
    // MARK: - Computed Properties
    var imageURL: URL? {
        IIIF.imageURL(for: artwork.imageID, sizeSegment: "full/843,")
    }
    
    var displayTitle: String {
        artwork.title ?? "Untitled"
    }
    
    var displayArtist: String {
        artwork.artistTitle ?? "Unknown Artist"
    }
    
    var displayDate: String {
        artwork.date ?? "Unknown Date"
    }
    
    var displayDescription: String {
        artwork.description ?? "No description available"
    }
}
