//
//  AppConstantsTests.swift
//  ArticAppTests
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import XCTest
@testable import ArticApp

final class AppConstantsTests: XCTestCase {
    
    // MARK: - Page Size Tests
    func testDefaultPageSize() {
        XCTAssertEqual(AppConstants.defaultPageSize, 20)
        XCTAssertGreaterThan(AppConstants.defaultPageSize, 0)
        XCTAssertLessThanOrEqual(AppConstants.defaultPageSize, 100)
    }
    
    // MARK: - Cache Tests
    func testCacheTTL() {
        XCTAssertEqual(AppConstants.cacheTTL, 300) // 5 minutes
        XCTAssertGreaterThan(AppConstants.cacheTTL, 0)
        XCTAssertLessThan(AppConstants.cacheTTL, 3600) // Less than 1 hour
    }
    
    // MARK: - Retry Tests
    func testMaxRetries() {
        XCTAssertEqual(AppConstants.maxRetries, 3)
        XCTAssertGreaterThan(AppConstants.maxRetries, 0)
        XCTAssertLessThanOrEqual(AppConstants.maxRetries, 10)
    }
}
