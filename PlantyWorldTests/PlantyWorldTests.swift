//
//  PlantyWorldTests.swift
//  PlantyWorldTests
//
//  Created by Yushan Yang on 2022/7/20.
//

import XCTest
@testable import PlantyWorld

class PlantyWorldTests: XCTestCase {
    var sut: DetailSunCell!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DetailSunCell()
        // given
        let newLevel = sut.sunLevel + 1
        // when
        sut.delegate?.passSunLevel(newLevel)
        // then
        XCTAssertNotEqual(sut.sunLevel, newLevel)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
