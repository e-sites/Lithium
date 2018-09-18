//
//  Logger.swift
//  ESLog
//
//  Created by Bas van Kuijck on 25-04-16.
//  Copyright © 2016 E-sites. All rights reserved.
//

import Foundation
import UIKit

public class Logger {
    
    public init() {
        
    }
    
    public var prettyPrintMaximumTableWidth = 140
    
    public var prettyPrintKeyAlignment:NSTextAlignment = .left
    public var logProxy:((_ level: LogLevel, _ line:String, _ message: String, _ style: LogStyle) -> Void)?
    public typealias LogContext = (file: String, function: String, line: Int, column:Int, thread:Thread)
    //	private let _queue = dispatch_queue_create("com.esites.eslog", DISPATCH_QUEUE_SERIAL)
    public var minimumLogLevel:LogLevel = .verbose
    
    
    public var theme:LogTheme = DefaultThemes.light()
    public var formatter:LogFormatter {
        return theme.formatter
    }
    
    
    public func error(_ items:Any..., file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) {
        log(level: .error, items, file: file, function: function, line:line, column: column)
    }
    
    public func warning(_ items:Any..., file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) {
        log(level: .warning, items, file: file, function: function, line:line, column: column)
    }
    
    public func exe(_ items:Any..., file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) {
        let s = items.map { "\($0)" }.joined(separator: formatter.separator)
        let fileName = formatter.format(component: .file(fullPath: false, showExtension: true), style: theme.executeStyle, level: .info, items: items, context: (file: file, function: function, line: line, column: column, thread: Thread.current))
        
        let str = "\(fileName):\(line) \(function) \(s)"
        log(level: .info, style: theme.executeStyle, [ str ], file: file, function: function, line:line, column: column)
    }
    
    public func debug(_ items:Any..., file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) {
        log(level: .debug, items, file: file, function: function, line:line, column: column)
    }
    
    public func info(_ items:Any..., file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) {
        log(level: .info, items, file: file, function: function, line:line, column: column)
    }
    
    public func success(_ items:Any..., file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) {
        log(level: .info, style: theme.successStyle, items, file: file, function: function, line:line, column: column)
    }
    
    public func verbose(_ items:Any..., file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) {
        log(level: .verbose, style: theme.verboseStyle, items, file: file, function: function, line:line, column: column)
    }
    
    public func log(_ items:Any..., file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) {
        log(level: .verbose, style: theme.defaultStyle, items, file: file, function: function, line:line, column: column)
    }
    
    public func colorLog(_ foregroundColor: String, backgroundColor:String?=nil, _ items:Any..., file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) {
        _colorLog(foregroundColor: foregroundColor, backgroundColor: backgroundColor, items: items, file:file, function: function, line: line, column: column)
    }
    
    public func colorLog(tag: String, _ foregroundColor: String, _ items:Any..., file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) {
        colorLog(foregroundColor, backgroundColor: nil, (items.map { String(describing: $0) }).joined(separator: formatter.separator), file: file, function: function, line:line, column: column)
    }
    
    public func request(_ method: String, _ url:String, _ parameters:String?=nil, file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) {
        var items: [Any] = [ method, url ]
        if let parameters = parameters {
            items.append(parameters)
        }
        log(level: .verbose, style: theme.requestStyle, items, file: file, function: function, line:line, column: column)
    }

    public func response(_ method: String, _ url:String, _ parameters:String?=nil, file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) {
        var items: [Any] = [ method, url ]
        if let parameters = parameters {
            items.append(parameters)
        }
        log(level: .verbose, style: theme.responseStyle, items, file: file, function: function, line:line, column: column)
    }
    
    private func _colorLog(foregroundColor: String, backgroundColor:String?, items:[Any], file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) {
        let style = LogStyle()
        style.foregroundColor = foregroundColor.color() ?? theme.defaultStyle.foregroundColor

        if let backgroundColor = backgroundColor {
            style.backgroundColor = backgroundColor.color() ?? theme.defaultStyle.backgroundColor
        }
   
        log(level: LogLevel.verbose, style: style, items, file: file, function: function, line:line, column: column)
    }
    
    
    public var enabled = true
}

// MARK: - Internal
// ____________________________________________________________________________________________________________________

extension Logger {
    
    public func log(level:LogLevel, style: LogStyle, _ items: [Any], file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) {
        _log(level: level, style: style, items: items, file:file, function:function, line:line, column:column)
    }
    
    public func log(level: LogLevel, _ items: [Any], file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) {
        _log(level: level, items: items, file:file, function:function, line:line, column:column)
    }
    
    
    private func _log(level:LogLevel, style: LogStyle, items: [Any], file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) {
        let thread = Thread.current
        
        let context = (file: file, function: function, line: line, column: column, thread: thread)
        var str = self.formatter.parse(level: level, style: style, items: items, context: context)
        
        let fgColor = self.theme.contextForegroundColor.rgbString()
        str = LogFormatter.colorWrap(text: str, foregroundColor: fgColor)
        
        if let logProxy = self.logProxy {
            
            var prefix = ""
            
            switch (level) {
            case .verbose:
                prefix = "VER"
            case .debug:
                prefix = "DEB"
            case .info:
                prefix = "INF"
            case .warning:
                prefix = "WAR"
            case .error:
                prefix = "ERR"
            }
            if (style.prefixText != nil) {
                prefix = self.formatter.format(component: .prefix(format: "%@"), style: style, level: level, items: items, context: context).replacingOccurrences(of: " ", with: "")
            }
            
            
            if (prefix != "") {
                prefix = "[ \(prefix) ] "
            }
            var rawMessage = (items.map { "\($0)" }).joined(separator: self.formatter.separator)
            rawMessage = self.parse(line: prefix + rawMessage, to: .plainText)
            logProxy(level, str, rawMessage, style)
            
        }
        guard self.enabled == true else {
            return
        }
        guard level.rawValue >= self.minimumLogLevel.rawValue else {
            return
        }
        
        print(str)
        
    }
    
    private func _log(level: LogLevel, items: [Any], file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) {
        var style:LogStyle?
        
        
        switch (level) {
        case .verbose:
            style = theme.verboseStyle
        case .debug:
            style = theme.debugStyle
        case .info:
            style = theme.infoStyle
        case .warning:
            style = theme.warningStyle
        case .error:
            style = theme.errorStyle
        }
        log(level: level, style: style!, items, file: file, function: function, line:line, column: column)
    }
}


public enum LogLevel : Int {
    case verbose = 0
    case debug = 100
    case info = 200
    case warning = 300
    case error = 400
}
