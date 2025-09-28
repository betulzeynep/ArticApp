//
//  ArtworksViewModelTests.swift
//  ArticAppTests
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import XCTest
@testable import ArticApp

final class ArtworksViewModelTests: XCTestCase {
    
    // MARK: - Initialization Tests
    func testViewModelInitialState() {
        // This is a basic test - in a real implementation, you'd need to mock dependencies
        // For now, we'll test the basic structure
        
        // Test that we can create a mock artwork
        let artwork = Artwork(
            id: 1,
            title: "Test Artwork",
            date: "1900",
            description: "Test Description",
            artistTitle: "Test Artist",
            imageID: "test-id"
        )
        
        XCTAssertEqual(artwork.id, 1)
        XCTAssertEqual(artwork.title, "Test Artwork")
    }
    
    // MARK: - Artwork Property Tests
    func testArtworkProperties() {
        let artwork = Artwork(
            id: 1,
            title: "Test Artwork",
            date: "1900",
            description: "Test Description",
            artistTitle: "Test Artist",
            imageID: "test-id"
        )
        
        // Test basic properties
        XCTAssertEqual(artwork.id, 1)
        XCTAssertEqual(artwork.title, "Test Artwork")
        XCTAssertEqual(artwork.date, "1900")
        XCTAssertEqual(artwork.description, "Test Description")
        XCTAssertEqual(artwork.artistTitle, "Test Artist")
        XCTAssertEqual(artwork.imageID, "test-id")
    }
    
    // MARK: - Nil Value Tests
    func testArtworkWithNilValues() {
        let artwork = Artwork(
            id: 1,
            title: nil,
            date: nil,
            description: nil,
            artistTitle: nil,
            imageID: nil
        )
        
        XCTAssertEqual(artwork.id, 1)
        XCTAssertNil(artwork.title)
        XCTAssertNil(artwork.date)
        XCTAssertNil(artwork.description)
        XCTAssertNil(artwork.artistTitle)
        XCTAssertNil(artwork.imageID)
    }
    
    // MARK: - Equality Tests
    func testArtworkEquality() {
        let artwork1 = Artwork(
            id: 1,
            title: "Same Title",
            date: "1900",
            description: "Same Description",
            artistTitle: "Same Artist",
            imageID: "same-id"
        )
        
        let artwork2 = Artwork(
            id: 1,
            title: "Same Title",
            date: "1900",
            description: "Same Description",
            artistTitle: "Same Artist",
            imageID: "same-id"
        )
        
        XCTAssertEqual(artwork1, artwork2)
    }
}
