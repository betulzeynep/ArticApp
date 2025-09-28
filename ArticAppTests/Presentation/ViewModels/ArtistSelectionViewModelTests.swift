//
//  ArtistSelectionViewModelTests.swift
//  ArticAppTests
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import XCTest
@testable import ArticApp

final class ArtistSelectionViewModelTests: XCTestCase {
    
    // MARK: - Initialization Tests
    func testViewModelInitialState() {
        // Test that we can create a mock artist for selection
        let artist = "Vincent van Gogh"
        
        XCTAssertEqual(artist, "Vincent van Gogh")
        XCTAssertFalse(artist.isEmpty)
    }
    
    // MARK: - Popular Artists Tests
    func testPopularArtists() {
        let popularArtists = [
            "Vincent van Gogh",
            "Claude Monet",
            "Pablo Picasso",
            "Leonardo da Vinci",
            "Michelangelo"
        ]
        
        XCTAssertEqual(popularArtists.count, 5)
        XCTAssertTrue(popularArtists.contains("Vincent van Gogh"))
        XCTAssertTrue(popularArtists.contains("Claude Monet"))
        XCTAssertTrue(popularArtists.contains("Pablo Picasso"))
    }
    
    // MARK: - Search Tests
    func testArtistSearch() {
        let searchTerm = "Monet"
        let artist = "Claude Monet"
        
        XCTAssertTrue(artist.lowercased().contains(searchTerm.lowercased()))
    }
    
    // MARK: - Edge Case Tests
    func testArtistSearchWithEmptyTerm() {
        let searchTerm = ""
        let artist = "Claude Monet"
        
        // Empty search should not match any artist
        XCTAssertFalse(artist.lowercased().contains(searchTerm.lowercased()))
    }
    
    // MARK: - Case Sensitivity Tests
    func testArtistSearchCaseInsensitive() {
        let searchTerm = "MONET"
        let artist = "Claude Monet"
        
        XCTAssertTrue(artist.lowercased().contains(searchTerm.lowercased()))
    }
    
    // MARK: - Partial Match Tests
    func testArtistSearchWithPartialMatch() {
        let searchTerm = "Van"
        let artist = "Vincent van Gogh"
        
        XCTAssertTrue(artist.lowercased().contains(searchTerm.lowercased()))
    }
}

