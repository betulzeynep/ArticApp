//
//  GetArtworksUseCase.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import Foundation

class GetArtworksUseCase {
    private let repository: ArtworkRepository
    private let loggingService: LoggingService
    
    init(repository: ArtworkRepository, loggingService: LoggingService) {
        self.repository = repository
        self.loggingService = loggingService
    }
    
    func execute(artist: String, page: Int = 1) async throws -> [Artwork] {
        loggingService.info("Getting artworks for artist: \(artist), page: \(page)", category: .api)
        
        do {
            let artworks = try await repository.getArtworks(artist: artist, page: page)
            loggingService.info("Successfully retrieved \(artworks.count) artworks", category: .api)
            return artworks
        } catch {
            loggingService.error("Failed to get artworks: \(error.localizedDescription)", category: .api)
            throw error
        }
    }
}
