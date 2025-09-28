//
//  APIEndpointsTests.swift
//  ArticAppTests
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import XCTest
@testable import ArticApp

final class APIEndpointsTests: XCTestCase {
    
    // MARK: - Base URL Tests
    func testBaseURL() {
        XCTAssertEqual(APIEndpoints.baseURL, "https://api.artic.edu/api/v1")
        XCTAssertTrue(APIEndpoints.baseURL.hasPrefix("https://"))
    }
    
    // MARK: - Endpoint Tests
    func testArtworksSearchEndpoint() {
        XCTAssertEqual(APIEndpoints.artworksSearch, "/artworks/search")
        XCTAssertTrue(APIEndpoints.artworksSearch.hasPrefix("/"))
    }
    
    // MARK: - URL Composition Tests
    func testCompleteURL() {
        let completeURL = APIEndpoints.baseURL + APIEndpoints.artworksSearch
        XCTAssertEqual(completeURL, "https://api.artic.edu/api/v1/artworks/search")
    }
}
