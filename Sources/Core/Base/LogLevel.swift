//
//  LogLevel.swift
//  Lithium
//
//  Created by Bas van Kuijck on 12/09/2019.
//

import Foundation

public enum LogLevel : Int {
    case verbose = 0
    case debug = 100
    case info = 200
    case warning = 300
    case error = 400

    var prefix: String {
        switch self {
        case .verbose:
            return "VER"
        case .debug:
            return "DEB"
        case .info:
            return "INF"
        case .warning:
            return "WAR"
        case .error:
            return "ERR"
        }
    }
}

