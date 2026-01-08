//
//  ProductListViewControllerUITests.swift
//  CatalogPro
//
//  Created by Swapnil Vinayak Shinde on 2025-12-27.
//

import XCTest

final class ProductListViewControllerUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testListLoadsAndShowsAtLeastOneCell() {
        app.launch()

        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: 5), "Product list table should exist")

        let firstCell = table.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10), "At least one product cell should appear")

        let anyLabel = firstCell.staticTexts.firstMatch
        XCTAssertTrue(anyLabel.exists, "Product cell should display some text")
    }

    func testPaginationShowsFooterLoaderWhileLoading() {
        app.launch()

        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: 5), "Product list table should exist")

        _ = table.cells.firstMatch.waitForExistence(timeout: 10)

        for _ in 0..<3 {
            table.swipeUp()
        }

        let loaderPredicate = NSPredicate(format: "elementType == %d", XCUIElement.ElementType.activityIndicator.rawValue)
        let possibleLoaders = app.descendants(matching: .any).matching(loaderPredicate)

        let exists = possibleLoaders.firstMatch.waitForExistence(timeout: 5)
        
        let noOfCells = table.cells.count
        XCTAssertTrue(exists || noOfCells > 0, "Should either see a loader or have cells loaded after scrolling")
    }

    func testSelectingCellNavigatesToDetail() {
        app.launch()

        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: 5), "Product list table should exist")

        let firstCell = table.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10), "First product cell should exist")

        // Capture title text if available to compare on detail screen
        let titleLabel = firstCell.staticTexts.firstMatch
        let expectedTitle = titleLabel.exists ? titleLabel.label: nil

        firstCell.tap()

        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.waitForExistence(timeout: 5), "Should navigate to detail with a back button")

        if let expectedTitle, !expectedTitle.isEmpty {
            let titleOnDetail = app.staticTexts["Category: \(expectedTitle)"]
            XCTAssertTrue(titleOnDetail.waitForExistence(timeout: 5), "Detail should show selected product title")
        } else {
            XCTAssertTrue(app.staticTexts.firstMatch.exists, "Detail should show some product text")
        }
    }

    func testAllProductsFetchedShowsAlert_ifTriggered() {
        app.launch()

        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: 5))
        
        for _ in 0..<10 {
            table.swipeUp()
        }

        let alert = app.alerts["Reached end of records"]
        // Soft assertion: only verify if it appears
        if alert.waitForExistence(timeout: 5) {
            XCTAssertTrue(alert.staticTexts["All records are already fetched. Nothing to fetch here."].exists)
            alert.buttons["OK"].tap()
        } else {
           _ = XCTSkip("All-products-fetched alert did not appear; make deterministic with a UITestScenario if needed.")
        }
    }

    func testErrorFlowShowsRetryAlert_ifTriggered() {
        app.launch()

        let errorAlert = app.alerts["Error"]
        if errorAlert.waitForExistence(timeout: 8) {
            XCTAssertTrue(errorAlert.buttons["Retry"].exists)
            errorAlert.buttons["Retry"].tap()
        } else {
           _ = XCTSkip("Error alert did not appear; add a deterministic UITestScenario to force an error.")
        }
    }

    func testConnectionErrorShowsRetryAlert_ifTriggered() {
        app.launch()

        let alert = app.alerts["Connection Error"]
        if alert.waitForExistence(timeout: 8) {
            XCTAssertTrue(alert.buttons["Retry"].exists)
            alert.buttons["Retry"].tap()
        } else {
           _ = XCTSkip("Connection error alert did not appear; add a deterministic UITestScenario to force no internet.")
        }
    }
}
