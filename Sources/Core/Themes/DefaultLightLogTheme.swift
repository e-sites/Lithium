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

public class DefaultLightLogTheme: LogTheme {
    public init() { }
    
    public var formatter = LogFormatter()
    
    class LightLogStyle : LogStyle {
        override init() {
            super.init()
            self.foregroundColor = UIColor(hex: 0x404040)!
        }
    }
	
	public var contextForegroundColor = UIColor(hex: 0x707070)!
	public var lineColor = UIColor(white: 0.5, alpha: 1)
	
    public var defaultStyle:LogStyle = LightLogStyle()
    public var tableStyle: TableStyle = {
        let style = TableStyle()
        style.lineColor = UIColor(white: 0.7, alpha: 1)
        return style
    }()
    
    public var errorStyle:LogStyle = {
        let style = LogStyle()
        style.prefixForegroundColor = UIColor(hex: 0xCC6666)
        style.prefixText = "Error"
        return style
    }()
    
    public var executeStyle:LogStyle = {
        let style = LogStyle()
        style.prefixForegroundColor = UIColor(hex: 0x4dc6e1)
        style.prefixText = "Execute"
        return style
    }()
    
    public var debugStyle:LogStyle = {
        let style = LogStyle()
        style.prefixForegroundColor = UIColor(hex: 0x81A2BE)
        style.prefixText = "Debug"
        return style
    }()
    
    public var infoStyle:LogStyle = {
        let style = LogStyle()
        style.prefixForegroundColor = UIColor(hex: 0xB5BD68)
        style.prefixText = "Info"
        return style
    }()
    
    public var warningStyle:LogStyle = {
        let style = LogStyle()
        style.prefixForegroundColor = UIColor(hex: 0xf6a506)
        style.prefixText = "Warning"
        return style
    }()
    
    public var successStyle:LogStyle = {
        let style = LogStyle()
        style.prefixForegroundColor = UIColor(hex: 0x6ec770)
        style.prefixText = "Success"
        return style
    }()
    
    public var verboseStyle:LogStyle = {
        let style = LogStyle()
        style.prefixForegroundColor = UIColor(hex: 0x9e9e9e)
        style.prefixText = "Verbose"
        return style
    }()
}
