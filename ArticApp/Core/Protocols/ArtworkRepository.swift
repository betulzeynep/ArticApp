//
//  ArtworkRepository.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

protocol ArtworkRepository {
    func getArtworks(artist: String, page: Int) async throws -> [Artwork]
    func searchArtworks(query: String, page: Int) async throws -> [Artwork]
    func getArtworkDetails(id: Int) async throws -> Artwork
}
