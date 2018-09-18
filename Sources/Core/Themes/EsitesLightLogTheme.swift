//
//  EsitesLightLogTheme.swift
//  ESLog
//
//  Created by Bas van Kuijck on 26-04-16.
//  Copyright © 2016 E-sites. All rights reserved.
//

import Foundation

import SwiftHEXColors
import UIKit

public class EsitesLightLogTheme : LogTheme {
    public init() { }
	public var contextForegroundColor = UIColor.black
	
	
	public var formatter = LogFormatter(format: "%@ %@ [t:%@] %@%@", components: [
		.date(format: "yyyy-MM-dd HH:mm:ss.SSS"),
		.targetName,
		.threadNumber,
		.prefix(format: "%@ "),
		.message
		])
	
	
    public var tableStyle: TableStyle = {
        let style = TableStyle()
        style.lineColor = UIColor(white: 0.7, alpha: 1)
		style.keyColor = UIColor(hex: 0x666666)!
        style.classColors = [
            "NSDate": UIColor(hex: 0x5C2699)!,
            "Bool" : UIColor(hex: 0xAA0D91)!,
            "Number": UIColor(hex: 0x0000E0)!,
            "String": UIColor.black
        ]
        return style
    }()

    public var lineColor = UIColor(white: 0.5, alpha: 1)
    public var defaultStyle:LogStyle = LogStyle()
    
    public var errorStyle: LogStyle = {
        let style = LogStyle()
        style.foregroundColor = UIColor.red
        style.prefixForegroundColor = UIColor.white
        style.prefixBackgroundColor = style.foregroundColor
        style.prefixText = " ERR "
        return style
    }()
    
    public var executeStyle:LogStyle = {
        let style = LogStyle()
        style.foregroundColor = UIColor(hex: 0x4dc6e1)!
        style.prefixBackgroundColor = style.foregroundColor
        style.prefixForegroundColor = UIColor.white
        style.prefixText = " EXE "
        return style
    }()
    
    public var debugStyle: LogStyle = {
        let style = LogStyle()
        style.foregroundColor = UIColor(hex: 0x0017a6)!
        return style
    }()
    
    public var infoStyle: LogStyle = {
        let style = LogStyle()
        style.foregroundColor = UIColor(hex: 0x1b8fff)!
        return style
    }()
    
    public var warningStyle: LogStyle = {
        let style = LogStyle()
        style.foregroundColor = UIColor(hex: 0xff6006)!
        return style
    }()
    
    public var successStyle: LogStyle = {
        let style = LogStyle()
        style.foregroundColor = UIColor(hex: 0x47a028)!
        return style
    }()
    
    public var verboseStyle: LogStyle = {
        let style = LogStyle()
        style.foregroundColor = UIColor(hex: 0x7a7a7a)!
        return style
    }()

    public var requestStyle: LogStyle = {
        let logStyle = LogStyle()
        logStyle.foregroundColor = UIColor(hex: 0x9600ff)!
        logStyle.prefixBackgroundColor = logStyle.foregroundColor
        logStyle.prefixForegroundColor = UIColor.white
        logStyle.prefixText = " REQ "
        return logStyle
    }()

    public var responseStyle: LogStyle = {
        let logStyle = LogStyle()
        logStyle.foregroundColor = UIColor(hex: 0xff00ff)!
        logStyle.prefixBackgroundColor = logStyle.foregroundColor
        logStyle.prefixForegroundColor = UIColor.white
        logStyle.prefixText = " RES "
        return logStyle
    }()
    
    public var hasColors: Bool {
        return true
    }
}
