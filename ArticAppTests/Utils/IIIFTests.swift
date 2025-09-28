//
//  IIIFTests.swift
//  ArticAppTests
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import XCTest
@testable import ArticApp

final class IIIFTests: XCTestCase {
    
    // MARK: - URL Generation Tests
    func testImageURLGeneration() {
        let url = IIIF.imageURL(for: "12345", sizeSegment: "full/300,")
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "https://www.artic.edu/iiif/2/12345/full/300,/0/default.jpg")
    }
    
    func testImageURLWithDefaultSize() {
        let url = IIIF.imageURL(for: "67890")
        XCTAssertNotNil(url)
        XCTAssertTrue(url!.absoluteString.contains("full/843,"))
        XCTAssertTrue(url!.absoluteString.contains("https://www.artic.edu/iiif/2/67890/"))
    }
    
    // MARK: - Edge Case Tests
    func testImageURLWithNilID() {
        let url = IIIF.imageURL(for: nil)
        XCTAssertNil(url)
    }
    
    func testImageURLWithSpecialCharacters() {
        let url = IIIF.imageURL(for: "test-image-id-123!@#$%")
        XCTAssertNotNil(url)
        XCTAssertTrue(url!.absoluteString.contains("test-image-id-123!@#$%"))
    }
    
    // MARK: - Size Variation Tests
    func testImageURLWithDifferentSizes() {
        let smallURL = IIIF.imageURL(for: "12345", sizeSegment: "full/200,")
        let mediumURL = IIIF.imageURL(for: "12345", sizeSegment: "full/500,")
        let largeURL = IIIF.imageURL(for: "12345", sizeSegment: "full/1000,")
        
        XCTAssertNotNil(smallURL)
        XCTAssertNotNil(mediumURL)
        XCTAssertNotNil(largeURL)
        
        XCTAssertTrue(smallURL!.absoluteString.contains("full/200,"))
        XCTAssertTrue(mediumURL!.absoluteString.contains("full/500,"))
        XCTAssertTrue(largeURL!.absoluteString.contains("full/1000,"))
    }
    
    // MARK: - Performance Tests
    func testImageURLPerformance() {
        self.measure {
            for i in 0..<1000 {
                _ = IIIF.imageURL(for: "image-\(i)")
            }
        }
    }
}
