//
//  LoadMoreArtworksUseCase.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import Foundation

class LoadMoreArtworksUseCase {
    private let repository: ArtworkRepository
    private let loggingService: LoggingService
    
    init(repository: ArtworkRepository, loggingService: LoggingService) {
        self.repository = repository
        self.loggingService = loggingService
    }
    
    func execute(artist: String, page: Int) async throws -> [Artwork] {
        loggingService.info("Loading more artworks for artist: \(artist), page: \(page)", category: .api)
        
        do {
            let artworks = try await repository.getArtworks(artist: artist, page: page)
            loggingService.info("Successfully loaded \(artworks.count) more artworks", category: .api)
            return artworks
        } catch {
            loggingService.error("Failed to load more artworks: \(error.localizedDescription)", category: .api)
            throw error
        }
    }
}
