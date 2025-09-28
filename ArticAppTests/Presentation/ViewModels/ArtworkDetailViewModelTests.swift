//
//  ArtworkDetailViewModelTests.swift
//  ArticAppTests
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import XCTest
@testable import ArticApp

final class ArtworkDetailViewModelTests: XCTestCase {
    
    // MARK: - Initialization Tests
    func testViewModelInitialState() {
        // Test that we can create a mock artwork for detail view
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
    
    // MARK: - Detail Properties Tests
    func testArtworkDetailProperties() {
        let artwork = Artwork(
            id: 1,
            title: "Test Artwork",
            date: "1900",
            description: "Test Description",
            artistTitle: "Test Artist",
            imageID: "test-id"
        )
        
        // Test properties that would be used in detail view
        XCTAssertEqual(artwork.id, 1)
        XCTAssertEqual(artwork.title, "Test Artwork")
        XCTAssertEqual(artwork.date, "1900")
        XCTAssertEqual(artwork.description, "Test Description")
        XCTAssertEqual(artwork.artistTitle, "Test Artist")
        XCTAssertEqual(artwork.imageID, "test-id")
    }
    
    // MARK: - Nil Value Tests
    func testArtworkDetailWithNilValues() {
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
    
    // MARK: - HTML Processing Tests
    func testArtworkDetailHtmlStripped() {
        let artwork = Artwork(
            id: 1,
            title: "Test",
            date: "1900",
            description: "<p>This is <b>bold</b> text.</p>",
            artistTitle: "Test Artist",
            imageID: "test-id"
        )
        
        XCTAssertEqual(artwork.htmlStripped, "This is bold text.")
    }
}


