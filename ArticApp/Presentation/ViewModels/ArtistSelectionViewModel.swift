//
//  ArtistSelectionViewModel.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import Foundation
import Combine

@MainActor
final class ArtistSelectionViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var isSearching: Bool = false
    @Published var searchResults: [Artwork] = []
    @Published var errorMessage: String?
    
    private let searchArtworksUseCase: SearchArtworksUseCase
    private let loggingService: LoggingService
    
    // Popular artists for quick selection
    let popularArtists = [
        "Vincent van Gogh",
        "Claude Monet",
        "Pablo Picasso",
        "Henri Matisse",
        "Georgia O'Keeffe",
        "Andy Warhol",
        "Jackson Pollock",
        "Frida Kahlo",
        "Salvador Dalí",
        "Wassily Kandinsky",
        "Paul Cézanne",
        "Edgar Degas",
        "Pierre-Auguste Renoir",
        "Henri de Toulouse-Lautrec",
        "Gustav Klimt"
    ]
    
    init(searchArtworksUseCase: SearchArtworksUseCase, loggingService: LoggingService) {
        self.searchArtworksUseCase = searchArtworksUseCase
        self.loggingService = loggingService
    }
    
    // MARK: - Public Methods
    func searchArtists(query: String) async {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        errorMessage = nil
        
        do {
            let results = try await searchArtworksUseCase.execute(query: query, page: 1)
            searchResults = results
            loggingService.info("Found \(results.count) artworks for query: \(query)", category: .ui)
        } catch {
            errorMessage = "Failed to search artists: \(error.localizedDescription)"
            loggingService.error("Search failed for query: \(query)", category: .ui)
        }
        
        isSearching = false
    }
    
    func clearSearch() {
        searchText = ""
        searchResults = []
        errorMessage = nil
    }
    
    // MARK: - Computed Properties
    var hasSearchResults: Bool {
        !searchResults.isEmpty
    }
    
}
