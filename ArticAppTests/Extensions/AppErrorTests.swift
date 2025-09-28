//
//  AppErrorTests.swift
//  ArticAppTests
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import XCTest
@testable import ArticApp

final class AppErrorTests: XCTestCase {
    
    // MARK: - Network Error Tests
    func testNetworkUnavailableError() {
        let error = AppError.networkUnavailable
        XCTAssertEqual(error.localizedDescription, "No internet connection available")
    }
    
    func testServerError() {
        let error = AppError.serverError(500)
        XCTAssertTrue(error.localizedDescription.contains("Server error"))
        XCTAssertTrue(error.localizedDescription.contains("500"))
    }
    
    // MARK: - Data Error Tests
    func testInvalidDataError() {
        let error = AppError.invalidData
        XCTAssertEqual(error.localizedDescription, "Invalid data received from server")
    }
    
    func testInvalidURLError() {
        let error = AppError.invalidURL
        XCTAssertEqual(error.localizedDescription, "Invalid URL")
    }
    
    // MARK: - Decoding Error Tests
    func testDecodingError() {
        let error = AppError.decodingError("Test decoding error")
        XCTAssertTrue(error.localizedDescription.contains("decoding error"))
        XCTAssertTrue(error.localizedDescription.contains("Test decoding error"))
    }
    
    // MARK: - Transport Error Tests
    func testTransportError() {
        let nsError = NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test transport error"])
        let error = AppError.transport(nsError)
        XCTAssertTrue(error.localizedDescription.contains("Network error"))
    }
    
    // MARK: - Cache Error Tests
    func testCacheError() {
        let error = AppError.cacheError("Test cache error")
        XCTAssertTrue(error.localizedDescription.contains("cache error"))
        XCTAssertTrue(error.localizedDescription.contains("Test cache error"))
    }
    
    // MARK: - Unknown Error Tests
    func testUnknownError() {
        let error = AppError.unknown("Test unknown error")
        XCTAssertTrue(error.localizedDescription.contains("Unknown error"))
        XCTAssertTrue(error.localizedDescription.contains("Test unknown error"))
    }
}
