//
//  Cobalt.swift
//  Library
//
//  Created by Bas van Kuijck on 10/11/2016.
//  Copyright © 2016 E-sites. All rights reserved.
//

import Foundation
import Cobalt

extension Logger: Cobalt.Logger {
    public func verbose(_ items: Any...) {
        self.verbose(items.map { "\($0)" }.joined(separator: " "), file: #file)
    }

    public func warning(_ items: Any...) {
        self.warning(items.map { "\($0)" }.joined(separator: " "), file: #file)
    }

    public func debug(_ items: Any...) {
        self.debug(items.map { "\($0)" }.joined(separator: " "), file: #file)
    }

    public func success(_ items: Any...) {
        self.success(items.map { "\($0)" }.joined(separator: " "), file: #file)
    }

    public func log(_ items: Any...) {
        self.log(items.map { "\($0)" }.joined(separator: " "), file: #file)
    }

    public func info(_ items: Any...) {
        self.info(items.map { "\($0)" }.joined(separator: " "), file: #file)
    }

    public func error(_ items: Any...) {
        self.error(items.map { "\($0)" }.joined(separator: " "), file: #file)
    }

    public func request(_ items: Any...) {
        if items.count < 3 {
            return
        }
        let stringItems = items.map { "\($0)" }
        self.request(stringItems.first!, stringItems[1], stringItems[2], file: #file)
    }

    public func response(_ items: Any...) {
        if items.count < 3 {
            return
        }
        let stringItems = items.map { "\($0)" }
        self.response(stringItems.first!, stringItems[1], stringItems[2], file: #file)
    }
}
