//
//  NetworkService.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import Foundation
import Combine

protocol NetworkService {
    func searchArtworks(query: String, limit: Int, page: Int) async throws -> ArtworksResponse
}

protocol NetworkMonitorService {
    var isConnected: Bool { get }
    var connectionPublisher: AnyPublisher<Bool, Never> { get }
}
