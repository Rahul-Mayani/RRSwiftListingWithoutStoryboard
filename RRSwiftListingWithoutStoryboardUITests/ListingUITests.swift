//
//  ListingUITests.swift
//  RRSwiftListingWithoutStoryboardUITests
//
//  Created by Rahul Mayani on 13/08/20.
//  Copyright © 2020 RR. All rights reserved.
//

import XCTest

class ListingUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    override func tearDown() {
    }

    func testScrollTable() {
        let app = XCUIApplication()
        app.launch()
        
        let table = app.tables.element(boundBy: 0)
        let lastCell = table.cells.element(boundBy: table.cells.count-1)
        table.scrollToElement(lastCell)
        
        XCTAssertTrue(app.staticTexts["101"].exists)
        //XCTAssertFalse(app.staticTexts["1091"].exists)
    }
    
    func testDetailsVCNavigation() {
        let app = XCUIApplication()
        app.launch()
        
        // showing listing view
        XCTAssertTrue(app.isShowingListingVC)
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["1112"].tap()
        
        // Listing view disapeear
        //XCTAssertFalse(app.isShowingListingVC)
        
        app.navigationBars["1112"].buttons["Data Listing"].tap()
    }
    
    // Sorting UI testing
    func testSortingButtonTapping() {
        let app = XCUIApplication()
        app.launch()
        
        let sortButton = app.navigationBars["Data Listing"].buttons["Sort"]
        sortButton.tap()
        
        let elementsQuery = app.sheets.scrollViews.otherElements
        elementsQuery.buttons["Other"].tap()
    }
}


