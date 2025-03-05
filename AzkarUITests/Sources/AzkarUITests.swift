//
//  AzkarUITests.swift
//  AzkarUITests
//
//  Created by Akhrorkhuja on 27/02/23.
//  Copyright © 2023 Al Jawziyya. All rights reserved.
//

import XCTest

@MainActor
class AzkarUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func setUp() async throws {
        try await super.setUp()
        let app = XCUIApplication()
        setupSnapshot(app, waitForAnimations: false)
        app.launch()
    }
    
    func testTakeScreenshot() async throws {
        let app = XCUIApplication()
        snapshot("01_HOME")
        let elementsQuery = app.scrollViews.otherElements
        
        // Morning
        let morningButton = elementsQuery.buttons[localized("category.morning")]
        XCTAssertTrue(morningButton.exists)
        morningButton.tap()
        snapshot("02_MORNING_AZKAR")
        
        // Back
        tapNavbarBackButton(app: app)
        
        // Evening
        let eveningButton = elementsQuery.buttons[localized("category.evening")]
        XCTAssertTrue(eveningButton.exists)
        eveningButton.tap()
        snapshot("03_EVENING_AZKAR")
        
        // Back
        tapNavbarBackButton(app: app)
        
        // After-Salah
        let afterSalahButton = elementsQuery.buttons[localized("category.after-salah")]
        XCTAssertTrue(afterSalahButton.exists)
        afterSalahButton.tap()
        snapshot("04_AFTER_SALAH")
        
        // Back
        tapNavbarBackButton(app: app)
        
        // Other
        let otherButton = elementsQuery.buttons[localized("category.other")]
        XCTAssertTrue(otherButton.exists)
        otherButton.tap()
        snapshot("05_OTHER")
        
        // Back
        tapNavbarBackButton(app: app)
        
        // Settings
        XCUIApplication().navigationBars.firstMatch/*@START_MENU_TOKEN@*/.buttons["gear"]/*[[".otherElements[\"Settings\"]",".buttons[\"Settings\"]",".buttons[\"gear\"]",".otherElements[\"gear\"]"],[[[-1,2],[-1,1],[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("06_SETTINGS")
        
        tapNavbarBackButton(app: app)
        
        elementsQuery.buttons[localized("category.morning")].tap()
        let scrollViewsQuery = app.scrollViews.otherElements.scrollViews
        scrollViewsQuery.element.swipeLeft()
        
        app.navigationBars.firstMatch.buttons[
            "square.and.arrow.up"].tap()
        
        // Wait for 3 seconds to load backrounds.
        sleep(3)
        
        elementsQuery.scrollViews.firstMatch.swipeUp()
        
        snapshot("07_SHARE")
    }
    
    
    private func tapNavbarBackButton(app: XCUIApplication) {
        app.navigationBars.element(boundBy: 0).buttons.element(boundBy: 0).tap()
    }
    
    func localized(_ key: String) -> String {
        let resource = Locale(identifier: Snapshot.deviceLanguage).languageCode
        let path = Bundle(for: AzkarUITests.self).path(forResource: resource, ofType: "lproj")!
        let localizationBundle = Bundle(path: path)!
        let result = NSLocalizedString(key, bundle: localizationBundle, comment: "")
        return result
    }
}
