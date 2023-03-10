//
//  AzkarUITests.swift
//  AzkarUITests
//
//  Created by Akhrorkhuja on 27/02/23.
//  Copyright © 2023 Al Jawziyya. All rights reserved.
//

import XCTest

class AzkarUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func setUp() {
        super.setUp()
        let app = XCUIApplication()
        setupSnapshot(app, waitForAnimations: false)
        app.launch()
    }
    
    func testTakeScreenshot() {
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
        
        // About
        let aboutButton = elementsQuery.buttons[localized("about.title")]
        XCTAssertTrue(aboutButton.exists)
        aboutButton.tap()
        snapshot("06_ABOUT")
        
        // Back
        tapNavbarBackButton(app: app)
        
        // Settings
        let settingsButton = elementsQuery.buttons[localized("settings.title")]
        XCTAssertTrue(settingsButton.exists)
        settingsButton.tap()
        snapshot("07_SETTINGS")
        
        // Back
        tapNavbarBackButton(app: app)
    }
    
    
    private func tapNavbarBackButton(app: XCUIApplication) {
        app.navigationBars.element(boundBy: 0).buttons.element(boundBy: 0).tap()
    }
    
    func localized(_ key: String) -> String {
        let resource = Locale(identifier: deviceLanguage).languageCode
        let path = Bundle(for: AzkarUITests.self).path(forResource: resource, ofType: "lproj")!
        let localizationBundle = Bundle(path: path)!
        let result = NSLocalizedString(key, bundle: localizationBundle, comment: "")
        return result
    }
}
