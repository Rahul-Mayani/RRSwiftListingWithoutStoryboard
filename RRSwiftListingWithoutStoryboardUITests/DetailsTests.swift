//
//  DetailsTests.swift
//  RRSwiftListingWithoutStoryboardUITests
//
//  Created by Rahul Mayani on 13/08/20.
//  Copyright © 2020 RR. All rights reserved.
//

import XCTest

class DetailsTests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    override func tearDown() {
    }

    func testLongTextScrolling() {
        let app = XCUIApplication()
        app.launch()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["1112"].tap()
        
        // Scrolling testing for long text
        swipeUpUntilElementFound(app: app, element: app.scrollViews.otherElements["Semd non"], isSwipeUp: true)
        swipeUpUntilElementFound(app: app, element: app.scrollViews.otherElements["Vivamus"], isSwipeUp: true)
        swipeUpUntilElementFound(app: app, element: app.scrollViews.otherElements["ante"])
        swipeUpUntilElementFound(app: app, element: app.scrollViews.otherElements["elit"])
    }
    
    func testBackFromDetailsVCToListingVC() {
        let app = XCUIApplication()
        app.launch()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["2639"].tap()
        
        // Showing details view
        XCTAssertTrue(app.isShowingDetailsVC)
        
        app.navigationBars["2639"].buttons["Data Listing"].tap()
        
        // Details view disapeear
        XCTAssertFalse(app.isShowingDetailsVC)
    }
}

// MARK: Long text scolling testing
extension DetailsTests {
    fileprivate func swipeUpUntilElementFound(app: XCUIApplication, element : XCUIElement, isSwipeUp: Bool = false) {
        if !element.exists{
            isSwipeUp ? app.swipeUp() : app.swipeDown()
        }
    }
}
