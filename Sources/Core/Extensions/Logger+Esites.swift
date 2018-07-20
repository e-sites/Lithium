//
//  Logger+Esites.swift
//  ESLog
//
//  Created by Bas van Kuijck on 26-04-16.
//  Copyright © 2016 E-sites. All rights reserved.
//

import Foundation
import SwiftHEXColors
import UIKit

private class LoggerEsitesSharedStyles {
    static var requestStyle: LogStyle {
        let logStyle = LogStyle()
		logStyle.foregroundColor = UIColor(hex: 0x9600ff)!
		logStyle.prefixBackgroundColor = logStyle.foregroundColor
        logStyle.prefixForegroundColor = UIColor.white
        logStyle.prefixText = " REQ "
        return logStyle
	}

    static var responseStyle: LogStyle {
        let logStyle = LogStyle()
        logStyle.foregroundColor = UIColor(hex: 0xff00ff)!
        logStyle.prefixBackgroundColor = logStyle.foregroundColor
        logStyle.prefixForegroundColor = UIColor.white
        logStyle.prefixText = " RES "
        return logStyle
    }

	static var requestNoColorsStyle: LogStyle {
        let logStyle = LogStyle()
		logStyle.prefixText = "REQ"
        return logStyle
	}

    static var responseNoColorsStyle: LogStyle {
        let logStyle = LogStyle()
        logStyle.prefixText = "RES"
        return logStyle
    }
}

extension Logger {
    public func request(_ method: String, _ url:String, _ parameters:String?=nil, file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) {
		_request(method: method, url, parameters, file: file, function: function, line: line, column: column)
	}
	
    private func _request(method: String, _ url:String, _ parameters:String?=nil, file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) {
		let p = parameters ?? "nil"
		let style = (theme is NoColorsLogTheme ? LoggerEsitesSharedStyles.requestNoColorsStyle : LoggerEsitesSharedStyles.requestStyle)
		
		let level = LogLevel.info
		
		log(level: level, style: style, [ "\(method) \(url) \(p)" ], file: file, function: function, line: line, column: column)
    }
	
	public func response(_ method: String, _ url:String, _ parameters:String?=nil, file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) {
		_response(method: method, url, parameters, file: file, function: function, line: line, column: column)
	}


    private func _response(method: String, _ url:String, _ parameters:String?=nil, file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) {
		let p = parameters ?? "nil"
		let style = (theme is NoColorsLogTheme ? LoggerEsitesSharedStyles.responseNoColorsStyle : LoggerEsitesSharedStyles.responseStyle)
		
        let level = LogLevel.info		
		log(level: level, style: style, [ "\(method) \(url) \(p)" ], file: file, function: function, line: line, column: column)
	}
}
