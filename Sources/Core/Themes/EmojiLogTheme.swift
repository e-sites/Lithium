//
//  EmojiLogTheme.swift
//  Lithium
//
//  Created by Bas van Kuijck on 17/09/2018.
//  Copyright © 2018 E-sites. All rights reserved.
//

import Foundation

public class EmojiLogTheme: LogTheme {
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
        .prefix(format: "%@ 𝌀 "),
        .message
    ])

    public var defaultStyle: LogStyle = LightLogStyle()

    public var errorStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "❌ ERR"
        return style
    }

    public var executeStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "⚙️ EXE"
        return style
    }

    public var debugStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "🐝 DEB"
        return style
    }

    public var infoStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "🔰 INF"
        return style
    }

    public var warningStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "⚠️ WAR"
        return style
    }

    public var successStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "✅ SUC"
        return style
    }

    public var verboseStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "💬 VER"
        return style
    }

    public var requestStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "➡️ REQ"
        return style
    }

    public var responseStyle: LogStyle {
        let style = LightLogStyle()
        style.prefixText = "⬅️ RES"
        return style
    }
}
