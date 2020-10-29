//
//  ZoomLinkTests.swift
//  AutoMoozTests
//
//  Created by Kyle Falconer on 10/28/20.
//

import XCTest
@testable import AutoMooz

class ZoomLinkTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testZoomUrl() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let zoomLink = ZoomEvent.zoomUrlFromEventDescription(desc : "some <a href=\"https://fullerton.zoom.us/j/93178729919\" target=\"_blank\">zoom link</a>")
        XCTAssertEqual(zoomLink, "https://fullerton.zoom.us/j/93178729919")
    }
    
    func testZoomUrlWithExtras() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let zoomLink = ZoomEvent.zoomUrlFromEventDescription(desc : "some <a href=\"https://fullerton.zoom.us/j/93178729919/something/else\" target=\"_blank\">zoom link</a>")
        XCTAssertEqual(zoomLink, "https://fullerton.zoom.us/j/93178729919/something/else")
    }
    
    func testZoomId() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let zoomLink = ZoomEvent.parseZoomIdFromUrl(desc: "some <a href=\"https://fullerton.zoom.us/j/93178729919\" target=\"_blank\">zoom link</a>")
        XCTAssertEqual(zoomLink, "93178729919")
    }
    
    func testZoomIdWithExtras() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let zoomLink = ZoomEvent.parseZoomIdFromUrl(desc: "some <a href=\"https://fullerton.zoom.us/j/93178729919/something/else\" target=\"_blank\">zoom link</a>")
        XCTAssertEqual(zoomLink, "93178729919")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
