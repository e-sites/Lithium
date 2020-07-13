//
//  DefaultLogTheme.swift
//  Lithium
//
//  Created by Bas van Kuijck on 12/09/2019.
//

import Foundation

public class DefaultLogTheme: LogTheme {
    public var formatter = LogFormatter(format: "%@ %@ [t:%@] [%@] %@%@", components: [
        .date(format: "yyyy-MM-dd HH:mm:ss.SSS"),
        .targetName,
        .threadNumber,
        .prefix,
        .message,
        .metadata(format: " -- %@")
    ])

    public var errorStyle: LogStyle {
        let style = LogStyle()
        style.prefixText = "ERR"
        return style
    }

    public var criticalStyle: LogStyle {
        let style = LogStyle()
        style.prefixText = "CRI"
        return style
    }

    public var traceStyle: LogStyle {
        let style = LogStyle()
        style.prefixText = "TRA"
        return style
    }

    public var debugStyle: LogStyle {
        let style = LogStyle()
        style.prefixText = "DEB"
        return style
    }

    public var infoStyle: LogStyle {
        let style = LogStyle()
        style.prefixText = "INF"
        return style
    }

    public var warningStyle: LogStyle {
        let style = LogStyle()
        style.prefixText = "WAR"
        return style
    }

    public var noticeStyle: LogStyle {
        let style = LogStyle()
        style.prefixText = "NOT"
        return style
    }

    public var requestStyle: LogStyle {
        let style = LogStyle()
        style.prefixText = "REQ"
        return style
    }

    public var responseStyle: LogStyle {
        let style = LogStyle()
        style.prefixText = "RES"
        return style
    }
}
