//
//  DefaultLightLogTheme.swift
//  Lithium
//
//  Created by Bas van Kuijck on 26-04-16.
//  Copyright © 2016 E-sites. All rights reserved.
//

import Foundation

class ColoredFontLogStyle: LogStyle {
    private var _colorTag: String = "\u{0001f3fb}"

    convenience init(colorTag: String) {
        self.init()
        _colorTag = colorTag

    }
    override func render(text: String) -> String {
        return Array(text).map { "\($0)\(_colorTag)" }.joined()
    }
}

public class EsitesColoredFontDarkLogTheme: LogTheme {
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
        .prefix(format: "[ %@ ] "),
        .message
        ])

    public var defaultStyle: LogStyle = LightLogStyle()

    public var errorStyle: LogStyle {
        let style = ColoredFontLogStyle(colorTag: "\u{0001f3fb}")
        style.prefixText = "ERR"
        return style
    }

    public var executeStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "EXE"
        return style
    }

    public var debugStyle: LogStyle {
        let style = ColoredFontLogStyle(colorTag: "\u{0001f3ff}")
        style.prefixText = "DEB"
        return style
    }

    public var infoStyle: LogStyle {
        let style = ColoredFontLogStyle(colorTag: "\u{0001f3fe}")
        style.prefixText = "INF"
        return style
    }

    public var warningStyle: LogStyle {
        let style = ColoredFontLogStyle(colorTag: "\u{0001f3fd}")
        style.prefixText = "WAR"
        return style
    }

    public var successStyle: LogStyle {
        let style = ColoredFontLogStyle(colorTag: "\u{0001f3fc}")
        style.prefixText = "SUC"
        return style
    }

    public var verboseStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "VER"
        return style
    }

    public var requestStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "REQ"
        return style
    }

    public var responseStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "RES"
        return style
    }
}
