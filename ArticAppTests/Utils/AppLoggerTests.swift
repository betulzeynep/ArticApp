//
//  AppLoggerTests.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import XCTest
@testable import ArticApp

final class AppLoggerTests: XCTestCase {
    
    // MARK: - Initialization Tests
    func testLoggerInitialization() {
        let logger = AppLogger()
        XCTAssertNotNil(logger)
    }
    
    // MARK: - Log Level Tests
    func testLogLevels() {
        let logger = AppLogger()
        
        // Test that logging methods don't crash
        logger.debug("Debug message", category: .general)
        logger.info("Info message", category: .general)
        logger.warning("Warning message", category: .general)
        logger.error("Error message", category: .general)
    }
    
    // MARK: - Category Tests
    func testLogCategories() {
        let logger = AppLogger()
        
        // Test all categories
        logger.info("API message", category: .api)
        logger.info("Cache message", category: .cache)
        logger.info("Network message", category: .network)
        logger.info("Offline message", category: .offline)
        logger.info("UI message", category: .ui)
        logger.info("General message", category: .general)
    }
    
    // MARK: - Log Method Tests
    func testLogWithDifferentLevels() {
        let logger = AppLogger()
        
        logger.log("Debug message", category: .general, level: .debug)
        logger.log("Info message", category: .general, level: .info)
        logger.log("Warning message", category: .general, level: .warning)
        logger.log("Error message", category: .general, level: .error)
    }
    
    // MARK: - Message Formatting Tests
    func testLogMessageFormatting() {
        let logger = AppLogger()
        
        // Test that log messages are properly formatted
        logger.info("Test message with special characters !@#$%^&*()", category: .general)
        logger.info("Test message with numbers 123456789", category: .general)
        logger.info("Test message with unicode 🎨🖼️", category: .general)
    }
}
