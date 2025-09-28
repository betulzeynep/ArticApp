//
//  ArtworkTests.swift
//  ArticAppTests
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import XCTest
@testable import ArticApp

final class ArtworkTests: XCTestCase {
    
    // MARK: - Basic Model Tests
    func testArtworkInitialization() {
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
    
    // MARK: - Inequality Tests
    func testArtworkInequality() {
        let artwork1 = Artwork(
            id: 1,
            title: "Title 1",
            date: "1900",
            description: "Description 1",
            artistTitle: "Artist 1",
            imageID: "id-1"
        )
        
        let artwork2 = Artwork(
            id: 2,
            title: "Title 2",
            date: "1901",
            description: "Description 2",
            artistTitle: "Artist 2",
            imageID: "id-2"
        )
        
        XCTAssertNotEqual(artwork1, artwork2)
    }
    
    // MARK: - HTML Stripping Tests
    func testHtmlStripped() {
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
    
    func testHtmlStrippedWithNilDescription() {
        let artwork = Artwork(
            id: 1,
            title: "Test",
            date: "1900",
            description: nil,
            artistTitle: "Test Artist",
            imageID: "test-id"
        )
        
        XCTAssertEqual(artwork.htmlStripped, "No description available")
    }
    
    func testHtmlStrippedWithEmptyDescription() {
        let artwork = Artwork(
            id: 1,
            title: "Test",
            date: "1900",
            description: "",
            artistTitle: "Test Artist",
            imageID: "test-id"
        )
        
        XCTAssertEqual(artwork.htmlStripped, "No description available")
    }
    
    // MARK: - JSON Tests
    func testJSONEncoding() throws {
        let artwork = Artwork(
            id: 1,
            title: "JSON Test",
            date: "1900",
            description: "JSON Description",
            artistTitle: "JSON Artist",
            imageID: "json-id"
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(artwork)
        
        XCTAssertFalse(data.isEmpty)
    }
    
    func testJSONDecoding() throws {
        let json = """
        {
            "id": 1,
            "title": "Decode Test",
            "date_display": "1900",
            "short_description": "Decode Description",
            "artist_title": "Decode Artist",
            "image_id": "decode-id"
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let artwork = try decoder.decode(Artwork.self, from: data)
        
        XCTAssertEqual(artwork.id, 1)
        XCTAssertEqual(artwork.title, "Decode Test")
        XCTAssertEqual(artwork.date, "1900")
        XCTAssertEqual(artwork.description, "Decode Description")
        XCTAssertEqual(artwork.artistTitle, "Decode Artist")
        XCTAssertEqual(artwork.imageID, "decode-id")
    }
}

