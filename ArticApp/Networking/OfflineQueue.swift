//
//  OfflineQueue.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import Foundation
import Combine

// MARK: - Offline Queue Manager
// Added offline queue to handle requests when network is unavailable
actor OfflineQueue: OfflineQueueService {
    private var pendingRequests: [QueuedRequest] = []
    private let maxRetries = AppConstants.maxRetries
    private let loggingService: LoggingService
    
    struct QueuedRequest: Codable {
        let id: UUID
        let artist: String
        let page: Int
        let retryCount: Int
        let timestamp: Date
        
        init(artist: String, page: Int, retryCount: Int = 0) {
            self.id = UUID()
            self.artist = artist
            self.page = page
            self.retryCount = retryCount
            self.timestamp = Date()
        }
    }
    
    init(loggingService: LoggingService = AppLogger()) {
        self.loggingService = loggingService
    }
    
    // MARK: - Queue Management
    // Add request to offline queue when network is unavailable
    func enqueue(artist: String, page: Int) async {
        let request = QueuedRequest(artist: artist, page: page)
        pendingRequests.append(request)
        loggingService.info("Queued offline request for \(artist), page \(page)", category: .offline)
    }
    
    // MARK: - Process Pending Requests
    // Process queued requests when network becomes available
    func processPendingRequests(with networkService: NetworkService) async {
        guard !pendingRequests.isEmpty else { return }
        
        loggingService.info("Processing \(pendingRequests.count) pending requests", category: .offline)
        
        var processedRequests: [UUID] = []
        
        for request in pendingRequests {
            do {
                let _ = try await networkService.searchArtworks(
                    query: request.artist,
                    limit: AppConstants.defaultPageSize,
                    page: request.page
                )
                processedRequests.append(request.id)
                loggingService.info("Successfully processed queued request for \(request.artist), page \(request.page)", category: .offline)
            } catch {
                if request.retryCount >= maxRetries {
                    processedRequests.append(request.id)
                    loggingService.error("Failed to process queued request after \(maxRetries) retries: \(error)", category: .offline)
                } else {
                    // Increment retry count
                    let updatedRequest = QueuedRequest(
                        artist: request.artist,
                        page: request.page,
                        retryCount: request.retryCount + 1
                    )
                    if let index = pendingRequests.firstIndex(where: { $0.id == request.id }) {
                        pendingRequests[index] = updatedRequest
                    }
                    loggingService.warning("Retrying queued request for \(request.artist), page \(request.page), attempt \(updatedRequest.retryCount)", category: .offline)
                }
            }
        }
        
        // Remove processed requests
        pendingRequests.removeAll { processedRequests.contains($0.id) }
    }
    
    // MARK: - Queue Status
    // Get current queue status for UI feedback
    var queueStatus: (count: Int, isEmpty: Bool) {
        (pendingRequests.count, pendingRequests.isEmpty)
    }
    
    // MARK: - Clear Queue
    // Clear all pending requests (useful for testing or manual reset)
    func clearQueue() async {
        pendingRequests.removeAll()
        loggingService.info("Offline queue cleared", category: .offline)
    }
}
