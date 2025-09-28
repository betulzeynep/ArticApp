//
//  SearchArtworksUseCase.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import Foundation

class SearchArtworksUseCase {
    private let repository: ArtworkRepository
    private let loggingService: LoggingService
    
    init(repository: ArtworkRepository, loggingService: LoggingService) {
        self.repository = repository
        self.loggingService = loggingService
    }
    
    func execute(query: String, page: Int = 1) async throws -> [Artwork] {
        loggingService.info("Searching artworks for query: \(query), page: \(page)", category: .api)
        
        do {
            let artworks = try await repository.searchArtworks(query: query, page: page)
            loggingService.info("Successfully found \(artworks.count) artworks for query: \(query)", category: .api)
            return artworks
        } catch {
            loggingService.error("Failed to search artworks: \(error.localizedDescription)", category: .api)
            throw error
        }
    }
}
