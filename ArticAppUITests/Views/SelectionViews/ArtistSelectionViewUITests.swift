//
//  ArtistSelectionViewUITests.swift
//  ArticAppUITests
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import XCTest

final class ArtistSelectionViewUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Navigation Tests
    @MainActor
    func testArtistSelectionNavigation() throws {
        // Given
        app.launch()
        
        // When
        let changeArtistButton = app.buttons["Change Artist"]
        XCTAssertTrue(changeArtistButton.waitForExistence(timeout: 5))
        changeArtistButton.tap()
        
        // Then
        let artistSelectionNavigationBar = app.navigationBars["Select Artist"]
        XCTAssertTrue(artistSelectionNavigationBar.waitForExistence(timeout: 5))
        
        let cancelButton = app.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists)
        cancelButton.tap()
        
        // Verify we're back to main view
        let mainNavigationBar = app.navigationBars["Art Institute"]
        XCTAssertTrue(mainNavigationBar.waitForExistence(timeout: 5))
    }
    
    // MARK: - Popular Artists Tests
    @MainActor
    func testPopularArtistsList() throws {
        // Given
        app.launch()
        
        // When
        let changeArtistButton = app.buttons["Change Artist"]
        XCTAssertTrue(changeArtistButton.waitForExistence(timeout: 5))
        changeArtistButton.tap()
        
        // Then
        let popularArtistsSection = app.staticTexts["Popular Artists"]
        XCTAssertTrue(popularArtistsSection.waitForExistence(timeout: 5))
        
        // Check for some popular artists
        let vanGogh = app.staticTexts["Vincent van Gogh"]
        XCTAssertTrue(vanGogh.waitForExistence(timeout: 5))
        
        let monet = app.staticTexts["Claude Monet"]
        XCTAssertTrue(monet.waitForExistence(timeout: 5))
        
        // Cancel
        let cancelButton = app.buttons["Cancel"]
        cancelButton.tap()
    }
    
    // MARK: - Performance Tests
    @MainActor
    func testArtistSelectionPerformance() throws {
        // Given
        app.launch()
        
        // When
        let changeArtistButton = app.buttons["Change Artist"]
        XCTAssertTrue(changeArtistButton.waitForExistence(timeout: 5))
        
        // Then
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            changeArtistButton.tap()
            
            let cancelButton = app.buttons["Cancel"]
            cancelButton.tap()
        }
    }
}

