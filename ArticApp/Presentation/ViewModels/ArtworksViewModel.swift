//
//  ArtworksViewModel.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import Foundation
import Combine

@MainActor
final class ArtworksViewModel: ObservableObject {
    @Published private(set) var artworks: [Artwork] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String?
    @Published var currentArtist: String = "Vincent van Gogh"
    @Published var isOnline: Bool = true
    @Published var pendingRequestsCount: Int = 0
    
    // MARK: - Pagination Support
    private var currentPage: Int = 1
    private var hasMorePages: Bool = true
    private var totalItems: Int = 0
    
    // MARK: - Dependencies
    private let getArtworksUseCase: GetArtworksUseCase
    private let loadMoreArtworksUseCase: LoadMoreArtworksUseCase
    private let networkMonitorService: NetworkMonitorService
    private let loggingService: LoggingService
    
    // MARK: - Combine
    private var cancellables = Set<AnyCancellable>()
    
    init(getArtworksUseCase: GetArtworksUseCase,
         loadMoreArtworksUseCase: LoadMoreArtworksUseCase,
         networkMonitorService: NetworkMonitorService,
         loggingService: LoggingService) {
        self.getArtworksUseCase = getArtworksUseCase
        self.loadMoreArtworksUseCase = loadMoreArtworksUseCase
        self.networkMonitorService = networkMonitorService
        self.loggingService = loggingService
        
        setupNetworkMonitoring()
    }
    
    // MARK: - Network Monitoring
    private func setupNetworkMonitoring() {
        networkMonitorService.connectionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                let wasOffline = !(self?.isOnline ?? true)
                self?.isOnline = isConnected
                
                if isConnected && wasOffline {
                    self?.errorMessage = nil
                    self?.loggingService.info("Network reconnected, refreshing data", category: .network)
                    Task {
                        await self?.load(artist: self?.currentArtist ?? "Vincent van Gogh", forceRefresh: true)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    func load(artist: String, forceRefresh: Bool = false) async {
        // Reset pagination state when loading new artist or force refresh
        if currentArtist != artist || forceRefresh {
            currentArtist = artist
            currentPage = 1
            hasMorePages = true
            artworks = []
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let newArtworks = try await getArtworksUseCase.execute(artist: artist, page: currentPage)
            
            if currentPage == 1 {
                self.artworks = newArtworks
            } else {
                self.artworks.append(contentsOf: newArtworks)
            }
            
            // Update pagination state
            hasMorePages = newArtworks.count >= AppConstants.defaultPageSize
            
            loggingService.info("Loaded \(newArtworks.count) artworks for \(artist)", category: .ui)
            
        } catch {
            handleError(error, for: artist)
        }
        
        isLoading = false
    }
    
    func loadMore() async {
        guard !isLoadingMore && hasMorePages else { return }
        
        isLoadingMore = true
        currentPage += 1
        
        do {
            let newArtworks = try await loadMoreArtworksUseCase.execute(artist: currentArtist, page: currentPage)
            self.artworks.append(contentsOf: newArtworks)
            
            // Update pagination state
            hasMorePages = newArtworks.count >= AppConstants.defaultPageSize
            
            loggingService.info("Loaded \(newArtworks.count) more artworks", category: .ui)
            
        } catch {
            // Revert page number on error
            currentPage -= 1
            handleError(error, for: currentArtist)
        }
        
        isLoadingMore = false
    }
    
    func refreshFromNetwork() async {
        await load(artist: currentArtist, forceRefresh: true)
    }
    
    // MARK: - Private Methods
    private func handleError(_ error: Error, for artist: String) {
        if let appError = error as? AppError {
            switch appError {
            case .networkUnavailable:
                errorMessage = "No internet connection. Showing cached data if available."
            case .invalidData:
                errorMessage = "Unable to load artworks. Please try again."
            case .cacheError(let message):
                errorMessage = "Cache error: \(message)"
            default:
                errorMessage = appError.localizedDescription
            }
        } else {
            errorMessage = "Failed to load artworks: \(error.localizedDescription)"
        }
        
        loggingService.error("Error loading artworks for \(artist): \(error.localizedDescription)", category: .ui)
    }
    
    // MARK: - Computed Properties
    var canLoadMore: Bool {
        hasMorePages && !isLoadingMore && !isLoading
    }
    
    var totalItemsText: String {
        guard totalItems > 0 else { return "" }
        return "\(artworks.count) of \(totalItems) artworks"
    }
    
    var isShowingCachedData: Bool {
        return !isOnline && !artworks.isEmpty
    }
}
