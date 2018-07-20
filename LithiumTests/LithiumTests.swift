//
//  LithiumTests.swift
//  LithiumTests
//
//  Created by Bas van Kuijck on 17-08-16.
//  Copyright © 2016 E-sites. All rights reserved.
//

import XCTest
@testable import Lithium

class LithiumTests: XCTestCase {
    var logger: Logger = {
        let l = Logger()
        l.theme = EsitesDarkLogTheme()
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
        logger.verbose("Log line -> verbose")
        logger.debug("Log line -> verbose")
        logger.info("Log line -> verbose")
        logger.error("Log line -> verbose")
        logger.warning("Log line -> verbose")
        logger.success("Log line -> verbose")
    }
}
