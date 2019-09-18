//
//  DefaultLogTheme.swift
//  Lithium
//
//  Created by Bas van Kuijck on 12/09/2019.
//

import Foundation

public class DefaultLogTheme: LogTheme {
    public init() {

    }

    private class LightLogStyle: LogStyle {
        override init() {
            super.init()
        }
    }

    public var formatter = LogFormatter(format: "%@ %@ [t:%@] %@%@", components: [
        .date(format: "yyyy-MM-dd HH:mm:ss.SSS"),
        .targetName,
        .threadNumber,
        .prefix(format: "%@: "),
        .message
    ])

    public var defaultStyle: LogStyle = LightLogStyle()

    public var errorStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "Error"
        return style
    }

    public var executeStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "Execute"
        return style
    }

    public var debugStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "Debug"
        return style
    }

    public var infoStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "Info"
        return style
    }

    public var warningStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "Warning"
        return style
    }

    public var successStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "Sucess"
        return style
    }

    public var verboseStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "Verbose"
        return style
    }

    public var requestStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "Request"
        return style
    }

    public var responseStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "Response"
        return style
    }
}
