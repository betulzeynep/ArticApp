//
//  APIClient.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import Foundation

final class APIClient: NetworkService {
    private let base = APIEndpoints.baseURL
    private let session: URLSession
    private let loggingService: LoggingService

    init(session: URLSession = .shared, loggingService: LoggingService = AppLogger()) {
        self.session = session
        self.loggingService = loggingService
    }

    // MARK: - Updated API Method with Pagination Support
    // Added page parameter and return full response for pagination info
    func searchArtworks(query: String, limit: Int = 20, page: Int = 1) async throws -> ArtworksResponse {
        loggingService.info("Searching artworks for '\(query)', page \(page), limit \(limit)", category: .api)
        
        var comps = URLComponents(string: "\(base)\(APIEndpoints.artworksSearch)")
        comps?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "fields", value: "id,title,image_id,artist_title,date_display,short_description"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        guard let url = comps?.url else {
            loggingService.error("Invalid URL for API request", category: .api)
            throw AppError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                loggingService.error("API returned status \(http.statusCode)", category: .api)
                throw AppError.serverError(http.statusCode)
            }
            // Debug raw response for pagination
            if let jsonString = String(data: data, encoding: .utf8) {
                loggingService.debug("Raw API Response (first 500 chars): \(String(jsonString.prefix(500)))", category: .api)
            }
            
            let decoded = try JSONDecoder().decode(ArtworksResponse.self, from: data)
            loggingService.info("Successfully fetched \(decoded.data.count) artworks for '\(query)'", category: .api)
            
            // Debug pagination info
            if let pagination = decoded.pagination {
                loggingService.debug("Pagination: currentPage=\(pagination.currentPage ?? 0), totalPages=\(pagination.totalPages ?? 0), totalItems=\(pagination.totalItems ?? 0), nextURL=\(pagination.nextURL ?? "nil")", category: .api)
            } else {
                loggingService.debug("No pagination info in response", category: .api)
            }
            
            return decoded
        } catch let decode as DecodingError {
            loggingService.error("Decoding error: \(decode.localizedDescription)", category: .api)
            throw AppError.decodingError(decode.localizedDescription)
        } catch {
            loggingService.error("Network error: \(error.localizedDescription)", category: .api)
            throw AppError.transport(error)
        }
    }
}
