//
//  LithiumTests.swift
//  LithiumTests
//
//  Created by Bas van Kuijck on 17-08-16.
//  Copyright © 2016 E-sites. All rights reserved.
//

import XCTest
import Dysprosium
@testable import Lithium

class LithiumTests: XCTestCase {
    var logger: Logger = {
        let l = Logger()
        l.theme = EmojiLogTheme()
        return l
    }()

    override func setUp() {
        super.setUp()
		
    }
    
    override func tearDown() {
		super.tearDown()
    }

    func testLogging() {
        logger.log("Log line -> log")
        logger.exe("Log line -> exe")
        logger.verbose("Log line -> verbose")
        logger.debug("Log line -> debug")
        logger.info("Log line -> info")
        logger.error("Log line -> error")
        logger.warning("Log line -> warning")
        logger.success("Log line -> success")
        logger.request("GET", "https://e-sites.nl", "test=bla")
        logger.response("GET", "https://e-sites.nl", "{}")
    }

    fileprivate var object: DeallocObject?

    func testDeallocation() {
        logger.setupWithDysprosium()
        let exp = expectation(description: "dealloc")
        object = DeallocObject()
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + .seconds(1)) {
            self.object = nil
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + .seconds(3)) {
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}

private class DeallocObject: DysprosiumCompatible {
    deinit {
        deallocated()
    }
}
