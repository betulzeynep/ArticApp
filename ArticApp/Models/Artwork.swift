//
//  Artwork.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import Foundation

struct Artwork: Identifiable, Codable, Equatable, Hashable {
    let id: Int
    let title: String?
    let date: String?
    let description: String?
    let artistTitle: String?
    let imageID: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case date = "date_display"
        case description = "short_description"
        case artistTitle = "artist_title"
        case imageID = "image_id"
    }
}

struct ArtworksResponse: Codable {
    let data: [Artwork]
    let pagination: PaginationInfo?
}

// MARK: - Pagination Support
// Added pagination info to support infinite scroll
struct PaginationInfo: Codable {
    let currentPage: Int?
    let totalPages: Int?
    let totalItems: Int?
    let limit: Int?
    let offset: Int?
    let nextURL: String?
    let prevURL: String?
    
    // Alternative field names that Art Institute API might use
    let pagination: PaginationDetails?
    let info: PaginationDetails?
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case totalItems = "total"
        case limit, offset
        case nextURL = "next_url"
        case prevURL = "prev_url"
        case pagination, info
    }
}

struct PaginationDetails: Codable {
    let page: Int?
    let pages: Int?
    let total: Int?
    let limit: Int?
    let next: String?
    let prev: String?
}

// MARK: - Artwork Extensions
extension Artwork {
    var htmlStripped: String {
        guard let description = description?.trimmingCharacters(in: .whitespacesAndNewlines),
              !description.isEmpty else {
            return "No description available"
        }
        return description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
