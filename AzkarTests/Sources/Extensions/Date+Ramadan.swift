//
//
//  AzkarTests
//  
//  Created on 04.04.2021
//  Copyright © 2021 Al Jawziyya. All rights reserved.
//  

import XCTest
@testable import Azkar

class RamadanDateTests: XCTestCase {

    let calendar = Calendar(identifier: .islamicUmmAlQura)

    func getDate(_ month: Int, day: Int) -> Date {
        calendar.date(from: DateComponents(month: month, day: day))!
    }

    func testBeginningOfRamadanIsCorrect() {
        XCTAssertTrue(getDate(shaban, day: 27).isBeginningOfRamadan)
        XCTAssertTrue(getDate(shaban, day: 30).isBeginningOfRamadan)
        XCTAssertTrue(getDate(ramadan, day: 1).isBeginningOfRamadan)
        XCTAssertTrue(getDate(ramadan, day: 3).isBeginningOfRamadan)
    }

    func testEndOrRamadanIsCorrect() {
        XCTAssertTrue(getDate(ramadan, day: 27).isEndOfRamadan)
        XCTAssertTrue(getDate(ramadan, day: 30).isEndOfRamadan)
        XCTAssertTrue(getDate(shawwal, day: 1).isEndOfRamadan)
        XCTAssertTrue(getDate(shawwal, day: 3).isEndOfRamadan)
    }

    func testRamadanEidDaysIsCorrect() {
        XCTAssertFalse(getDate(ramadan, day: 28).isRamadanEidDays)
        XCTAssertTrue(getDate(ramadan, day: 29).isRamadanEidDays)
        XCTAssertTrue(getDate(ramadan, day: 30).isRamadanEidDays)
        XCTAssertTrue(getDate(shawwal, day: 1).isRamadanEidDays)
        XCTAssertTrue(getDate(shawwal, day: 3).isRamadanEidDays)
    }

}
