//
//  ArtworkRepository.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import Foundation

class ArtworkRepositoryImpl: ArtworkRepository {
    private let networkService: NetworkService
    private let cacheService: CacheService
    private let offlineQueueService: OfflineQueueService
    private let loggingService: LoggingService
    
    init(networkService: NetworkService,
         cacheService: CacheService,
         offlineQueueService: OfflineQueueService,
         loggingService: LoggingService) {
        self.networkService = networkService
        self.cacheService = cacheService
        self.offlineQueueService = offlineQueueService
        self.loggingService = loggingService
    }
    
    func getArtworks(artist: String, page: Int) async throws -> [Artwork] {
        let cacheKey = "artist:\(artist.lowercased()):page:\(page)"
        
        // Try cache first
        if let cached: [Artwork] = try? await cacheService.load([Artwork].self, for: cacheKey, maxAge: AppConstants.cacheTTL) {
            loggingService.info("Loaded \(cached.count) artworks from cache for \(artist)", category: .cache)
            return cached
        }
        
        // Check if offline
        if let networkMonitor = networkService as? NetworkMonitorService, !networkMonitor.isConnected {
            // Try to get any cached data
            if let cached: [Artwork] = try? await cacheService.load([Artwork].self, for: cacheKey, maxAge: .infinity), !cached.isEmpty {
                loggingService.info("Using stale cache data for \(artist)", category: .cache)
                return cached
            }
            
            // Queue request for when online
            await offlineQueueService.enqueue(artist: artist, page: page)
            throw AppError.networkUnavailable
        }
        
        // Fetch from network
        do {
            let response = try await networkService.searchArtworks(query: artist, limit: AppConstants.defaultPageSize, page: page)
            
            // Cache the results
            try await cacheService.save(response.data, for: cacheKey)
            loggingService.info("Cached \(response.data.count) artworks for \(artist)", category: .cache)
            
            return response.data
        } catch {
            loggingService.error("Failed to fetch artworks for \(artist): \(error.localizedDescription)", category: .api)
            throw AppError.invalidData
        }
    }
    
    func searchArtworks(query: String, page: Int) async throws -> [Artwork] {
        return try await getArtworks(artist: query, page: page)
    }
    
    func getArtworkDetails(id: Int) async throws -> Artwork {
        let cacheKey = "artwork:\(id)"
        
        // Try cache first
        if let cached: Artwork = try? await cacheService.load(Artwork.self, for: cacheKey, maxAge: AppConstants.cacheTTL) {
            return cached
        }
        
        // For now, return a placeholder - in a real app, you'd have a separate endpoint
        throw AppError.unknown("Artwork details not implemented")
    }
}
