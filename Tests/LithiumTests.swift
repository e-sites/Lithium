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
    var logger: Logger {
        let l = Logger()
        l.theme = EmojiLogTheme()
        return l
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
}
