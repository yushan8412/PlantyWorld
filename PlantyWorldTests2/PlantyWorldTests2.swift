//
//  PlantyWorldTests2.swift
//  PlantyWorldTests2
//
//  Created by Yushan Yang on 2022/7/21.
//

import XCTest
@testable import PlantyWorld

class PlantyWorldTests2: XCTestCase {
    
    var sut: ProfileVC!

    override func setUpWithError() throws {
        sut = ProfileVC()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
