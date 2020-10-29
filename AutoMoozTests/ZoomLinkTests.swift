//
//  ZoomLinkTests.swift
//  AutoMoozTests
//
//  Created by Kyle Falconer on 10/28/20.
//

import XCTest
import EventKit
@testable import AutoMooz

class ZoomLinkTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testContainsZoomUrlEmptyEvent() throws {
        let event = EKEvent()
        let zoomLink = ZoomEvent.eventContainsZoomLink(event: event)
        XCTAssertEqual(zoomLink, false)
    }
    
    func testContainsZoomUrlPlainTextNotes() throws {
        let event = EKEvent()
        event.notes = "some text"
        let zoomLink = ZoomEvent.eventContainsZoomLink(event: event)
        XCTAssertEqual(zoomLink, false)
    }
    
    func testContainsZoomUrlUrlNotes() throws {
        let event = EKEvent()
        event.notes = "https://fullerton.zoom.us/j/93178729919"
        let zoomLink = ZoomEvent.eventContainsZoomLink(event: event)
        XCTAssertEqual(zoomLink, true)
    }

    func testContainsZoomHtmlNotes() throws {
        let event = EKEvent()
        event.notes = "<a href=\"https://fullerton.zoom.us/j/93178729919\" target=\"_blank\">zoom link</a>"
        let zoomLink = ZoomEvent.eventContainsZoomLink(event: event)
        XCTAssertEqual(zoomLink, true)
    }

    func testZoomUrl() throws {
        let zoomLink = ZoomEvent.zoomUrlFromEventDescription(desc : "some <a href=\"https://fullerton.zoom.us/j/93178729919\" target=\"_blank\">zoom link</a>")
        XCTAssertEqual(zoomLink, "https://fullerton.zoom.us/j/93178729919")
    }
    
    func testZoomUrlWithExtras() throws {
        let zoomLink = ZoomEvent.zoomUrlFromEventDescription(desc : "some <a href=\"https://fullerton.zoom.us/j/93178729919/something/else\" target=\"_blank\">zoom link</a>")
        XCTAssertEqual(zoomLink, "https://fullerton.zoom.us/j/93178729919/something/else")
    }
    
    func testZoomId() throws {
        let zoomLink = ZoomEvent.parseZoomIdFromUrl(desc: "some <a href=\"https://fullerton.zoom.us/j/93178729919\" target=\"_blank\">zoom link</a>")
        XCTAssertEqual(zoomLink, "93178729919")
    }
    
    func testZoomIdWithExtras() throws {
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
