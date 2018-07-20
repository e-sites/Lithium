//
//  DefaultLightLogTheme.swift
//  ESLog
//
//  Created by Bas van Kuijck on 26-04-16.
//  Copyright © 2016 E-sites. All rights reserved.
//

import Foundation
import SwiftHEXColors
import UIKit

public class NoColorsLogTheme : LogTheme {
    public init() { }

	
    class LightLogStyle : LogStyle {
        override init() {
            super.init()
        }
    }
	
	public var formatter = LogFormatter(format: "%@ %@ [t:%@] %@%@", components: [
		.date(format: "yyyy-MM-dd HH:mm:ss.SSS"),
		.targetName,
		.threadNumber,
		.prefix(format: "▋ %@ ► "),
		.message
		])
	
	public var contextForegroundColor = UIColor.black
	public var lineColor = UIColor.black
    
    public var defaultStyle:LogStyle = LightLogStyle()
    public var tableStyle: TableStyle = {
        let style = TableStyle()
        style.lineColor = UIColor.black
        return style
    }()
    
    public var errorStyle:LogStyle = {
        let style = LightLogStyle()
        style.prefixText = "ERR"
        return style
    }()
    
    public var executeStyle:LogStyle = {
        let style = LightLogStyle()
        style.prefixText = "EXE"
        return style
    }()
    
    public var debugStyle:LogStyle = {
        let style = LightLogStyle()
        style.prefixText = "DEB"
        return style
    }()
    
    public var infoStyle:LogStyle = {
        let style = LightLogStyle()
        style.prefixText = "INF"
        return style
    }()
    
    public var warningStyle:LogStyle = {
        let style = LightLogStyle()
        style.prefixText = "WAR"
        return style
    }()
    
    public var successStyle:LogStyle = {
        let style = LightLogStyle()
        style.prefixText = "SUC"
        return style
    }()
    
    public var verboseStyle:LogStyle = {
        let style = LightLogStyle()
        style.prefixText = "VER"
        return style
    }()
}
