//
//  LogTheme.swift
//  Lithium
//
//  Created by Bas van Kuijck on 26-04-16.
//  Copyright © 2016 E-sites. All rights reserved.
//

import Foundation

public protocol LogTheme {
    var defaultStyle: LogStyle { get }
    var errorStyle: LogStyle { get }
    var debugStyle: LogStyle { get }
    var infoStyle: LogStyle { get }
    var warningStyle: LogStyle { get }
    var successStyle: LogStyle { get }
    var verboseStyle: LogStyle { get }
    var executeStyle: LogStyle { get }
    var requestStyle: LogStyle { get }
    var responseStyle: LogStyle { get }
    var formatter: LogFormatter { get }
}
