//
//  Logger.swift
//  Lithium
//
//  Created by Bas van Kuijck on 25-04-16.
//  Copyright © 2016 E-sites. All rights reserved.
//

import Foundation

public enum TextAlignment: Int {
    case left
    case right
    case center
}

public class Logger {
    public typealias LogContext = (file: String, function: String, line: Int, column: Int, thread: Thread)

    public var isEnabled = true
    public var prettyPrintMaximumTableWidth = 140
    public var prettyPrintKeyAlignment: TextAlignment = .left
    public var minimumLogLevel: LogLevel = .verbose

    public var logProxy: ((_ level: LogLevel, _ line:String, _ message: String, _ style: LogStyle) -> Void)?
    
    public var theme: LogTheme = DefaultLogTheme()
    public var formatter: LogFormatter {
        return theme.formatter
    }

    public init() {

    }    
    
    public func error(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        log(level: .error, items, file: file, function: function, line:line, column: column)
    }
    
    public func warning(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        log(level: .warning, items, file: file, function: function, line:line, column: column)
    }
    
    public func exe(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        let s = items.map { "\($0)" }.joined(separator: formatter.separator)
        let fileName = formatter.format(component: .file(fullPath: false, showExtension: true),
                                        style: theme.executeStyle,
                                        level: .info,
                                        items: items,
                                        context: (file: file, function: function, line: line, column: column, thread: Thread.current)
        )
        
        let str = "\(fileName):\(line) \(function) \(s)"
        log(level: .info, style: theme.executeStyle, [ str ], file: file, function: function, line:line, column: column)
    }
    
    public func debug(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        log(level: .debug, items, file: file, function: function, line:line, column: column)
    }
    
    public func info(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        log(level: .info, items, file: file, function: function, line:line, column: column)
    }
    
    public func success(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        log(level: .info, style: theme.successStyle, items, file: file, function: function, line:line, column: column)
    }
    
    public func verbose(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        log(level: .verbose, style: theme.verboseStyle, items, file: file, function: function, line:line, column: column)
    }
    
    public func log(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        log(level: .verbose, style: theme.defaultStyle, items, file: file, function: function, line:line, column: column)
    }
    
    public func request(_ method: String,
                        _ url:String,
                        _ parameters:String? = nil,
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line,
                        column: Int = #column) {
        var items: [Any] = [ method, url ]
        if let parameters = parameters {
            items.append(parameters)
        }
        log(level: .verbose, style: theme.requestStyle, items, file: file, function: function, line:line, column: column)
    }

    public func response(_ method: String,
                         _ url: String,
                         _ parameters: String? = nil,
                         file: String = #file,
                         function: String = #function,
                         line: Int = #line,
                         column: Int = #column) {
        var items: [Any] = [ method, url ]
        if let parameters = parameters {
            items.append(parameters)
        }
        log(level: .verbose, style: theme.responseStyle, items, file: file, function: function, line:line, column: column)
    }

    
    public func log(level: LogLevel,
                    style: LogStyle,
                    _ items: [Any],
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line,
                    column: Int = #column) {
        _log(level: level, style: style, items: items, file:file, function:function, line:line, column:column)
    }
    
    public func log(level: LogLevel, _ items: [Any], file: String = #file, function: String = #function, line:Int = #line, column: Int = #column) {
        _log(level: level, items: items, file: file, function: function, line: line, column: column)
    }
    
    private func _log(level: LogLevel,
                      style: LogStyle,
                      items: [Any],
                      file: String = #file,
                      function: String = #function,
                      line: Int = #line,
                      column: Int = #column) {
        let thread = Thread.current
        
        let context = (file: file, function: function, line: line, column: column, thread: thread)
        let str = formatter.parse(level: level, style: style, items: items, context: context)

        if let logProxy = self.logProxy {
            var prefix = level.prefix
            if style.prefixText != nil {
                prefix = formatter.format(component: .prefix(format: "%@"),
                                          style: style,
                                          level: level,
                                          items: items,
                                          context: context)
                    .uppercased()
                    .components(separatedBy: CharacterSet.uppercaseLetters.inverted).joined()
            }
            
            
            if prefix != "" {
                prefix = "[ \(prefix) ] "
            }
            let rawMessage = items.map { "\($0)" }.joined(separator: formatter.separator)
            logProxy(level, str, prefix + rawMessage, style)
        }

        if isEnabled && level.rawValue >= minimumLogLevel.rawValue {
            print(str)
        }
    }
    
    private func _log(level: LogLevel, items: [Any], file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        var style: LogStyle?
        
        
        switch level {
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
