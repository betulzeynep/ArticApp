//
//  AppDependencies.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import Foundation
import Combine

class AppDependencies {
    static let shared = AppDependencies()
    
    private init() {}
    
    // MARK: - Core Services
    lazy var loggingService: LoggingService = AppLogger()
    lazy var networkService: NetworkService = APIClient(loggingService: loggingService)
    lazy var networkMonitorService: NetworkMonitorService = NetworkMonitor()
    lazy var cacheService: CacheService = {
        do {
            return try JSONDiskCache(name: "ArticCache", loggingService: loggingService)
        } catch {
            fatalError("Cache initialization failed: \(error)")
        }
    }()
    lazy var offlineQueueService: OfflineQueueService = OfflineQueue(loggingService: loggingService)
    
    // MARK: - Repositories
    lazy var artworkRepository: ArtworkRepository = ArtworkRepositoryImpl(
        networkService: networkService,
        cacheService: cacheService,
        offlineQueueService: offlineQueueService,
        loggingService: loggingService
    )
    
    // MARK: - Use Cases
    lazy var getArtworksUseCase: GetArtworksUseCase = GetArtworksUseCase(
        repository: artworkRepository,
        loggingService: loggingService
    )
    
    lazy var loadMoreArtworksUseCase: LoadMoreArtworksUseCase = LoadMoreArtworksUseCase(
        repository: artworkRepository,
        loggingService: loggingService
    )
    
    lazy var searchArtworksUseCase: SearchArtworksUseCase = SearchArtworksUseCase(
        repository: artworkRepository,
        loggingService: loggingService
    )
    
    // MARK: - ViewModels
    @MainActor
    func createArtworksViewModel() -> ArtworksViewModel {
        return ArtworksViewModel(
            getArtworksUseCase: getArtworksUseCase,
            loadMoreArtworksUseCase: loadMoreArtworksUseCase,
            networkMonitorService: networkMonitorService,
            loggingService: loggingService
        )
    }
    
    @MainActor
    func createArtworkDetailViewModel(artwork: Artwork) -> ArtworkDetailViewModel {
        return ArtworkDetailViewModel(
            artwork: artwork,
            loggingService: loggingService
        )
    }
    
    @MainActor
    func createArtistSelectionViewModel() -> ArtistSelectionViewModel {
        return ArtistSelectionViewModel(
            searchArtworksUseCase: searchArtworksUseCase,
            loggingService: loggingService
        )
    }
}
