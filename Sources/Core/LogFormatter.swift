//
//  LogFormat.swift
//  ESLog
//
//  Created by Bas van Kuijck on 25-04-16.
//  Copyright © 2016 E-sites. All rights reserved.
//

import Foundation
import UIKit

public class LogFormatter {
    
    public enum Component {
        case date(format: String)
        case prefix(format: String)
        case message
        case targetName
        case file(fullPath: Bool, showExtension: Bool)
        case lineNumber
        case threadNumber
    }
    
    public var format:String = "%@ [%@] %@:%@ [t:%@] %@%@"
    fileprivate let dateFormatter = DateFormatter()
    
    
    public var components:[Component] = [
        .date(format: "yyyy-MM-dd HH:mm:ss.SSS"),
        .targetName,
        .file(fullPath: false, showExtension: false),
        .lineNumber,
        .threadNumber,
        .prefix(format: "%@: "),
        .message
        ] {
        didSet {
            self._setDateFormatter()
        }
    }
    
    public var separator = " "
    
    init() {
        _setDateFormatter()
    }
    
    init(format: String, components: [Component]) {
        self.format = format
        self.components = components
        _setDateFormatter()
    }
}

typealias LogFormatter_InternalHelpers = LogFormatter


extension UIColor {
    class func defaultForegroundColor() -> UIColor {
        return UIColor.black
    }
    
    func isDefaultForegroundColor() -> Bool {
        return self.rgbString() == UIColor.defaultForegroundColor().rgbString()
    }
}

extension LogFormatter_InternalHelpers {
    
    func format(component: Component, style:LogStyle, level:LogLevel, items: [Any], context: Logger.LogContext) -> String {
        func _parseDate(format: String) -> String {
            return dateFormatter.string(from: Date())
        }
        
        func _parseMessage() -> String {
            let clearString = items.map({ "\($0)" }).joined(separator: separator)
            if (style.backgroundColor == nil && style.foregroundColor.isDefaultForegroundColor()) {
                return clearString
            }
            var str = clearString
            if let bgColor = style.backgroundColor?.rgbString() {
                str = "\(type(of: self).ESCAPE)bg\(bgColor);\(str)\(type(of: self).RESET_BG)"
            }
            let fgColor = style.foregroundColor.rgbString()
            
            return "\(type(of: self).ESCAPE)fg\(fgColor);\(str)\(type(of: self).RESET_FG)"
        }
        
        func _parsePrefix(prefixFormat: String) -> String {
            guard let prefixText = style.prefixText else {
                return ""
            }
            if (style.backgroundColor == nil && style.foregroundColor.isDefaultForegroundColor()) {
                return String(format: prefixFormat, prefixText)
            }
            var ps = ""
            
            var foregroundColor = style.prefixForegroundColor
            let fgColor = (foregroundColor ?? UIColor.black).rgbString()
            var escape = type(of: self).RESET_FG
            if let bgColor = style.prefixBackgroundColor?.rgbString() {
                ps = "\(ps)\(type(of: self).ESCAPE)bg\(bgColor);"
                escape += type(of: self).RESET_BG
                if (foregroundColor == nil) {
                    foregroundColor = UIColor.white
                }
            }
            
            ps = "\(ps)\(type(of: self).ESCAPE)fg\(fgColor);\(prefixText)\(escape)"
            
            return String(format: prefixFormat, ps)
        }
        
        func _parseThread() -> String {
            var threadNum = "m"
            if (!context.thread.isMainThread) {
                if let n = context.thread.value(forKeyPath: "private.seqNum") as? NSNumber {
                    threadNum = "\(n)"
                }
                
            }
            return threadNum
        }
        
        func _parseFile(fullPath: Bool, ext: Bool) -> String {
            var str = context.file
            if (!fullPath) {
                str = str.components(separatedBy: "/").last ?? ""
                
            }
            if (!ext) {
                
                var s = str.components(separatedBy: ".")
                s.removeLast()
                str = s.joined(separator: ".")
                
            }
            return str
        }
        
        func _parseTargetName() -> String {
            return (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? ""
            
        }
        
        
        switch (component) {
        case .date(_):
            return _parseDate(format: format)
            
        case .message:
            return _parseMessage()
            
        case .prefix(let prefixFormat):
            return _parsePrefix(prefixFormat: prefixFormat)
            
        case .threadNumber:
            return _parseThread()
            
        case .file(let fullPath, let ext):
            return _parseFile(fullPath: fullPath, ext: ext)
            
            
        case .lineNumber:
            return "\(context.line)"
            
        case .targetName:
            return _parseTargetName()
        }
        
    }
    
    private typealias _CVarArgType = CVarArg
    func parse(level:LogLevel, style: LogStyle, items: [Any], context: Logger.LogContext) -> String {
        return _parse(level: level, style: style, items: items, context: context)
    }
    
    
    private func _parse(level:LogLevel, style: LogStyle, items: [Any], context: Logger.LogContext) -> String {
        let arguments = components.map { (component: Component) -> _CVarArgType in
            return self.format(component: component, style: style, level: level, items: items, context: context)
        }
        
        return String(format: format, arguments: arguments)
    }
}

typealias LogFormatter_PrivateHelpers = LogFormatter

extension LogFormatter_PrivateHelpers {
    
    fileprivate func _setDateFormatter() {
        for comp in components {
            switch comp {
            case .date(let dateFormat):
                dateFormatter.dateFormat = dateFormat
                return
            default:
                continue
            }
        }
    }
}

typealias LogFormatter_StaticHelpers = LogFormatter

extension LogFormatter_StaticHelpers {
    static let ESCAPE = "\u{001b}["
    static let RESET_FG = ESCAPE + "fg;"
    static let RESET_BG = ESCAPE + "bg;"
    static let RESET = ESCAPE + ";"
    
    static func colorWrap(text:String, foregroundColor:String, backgroundColor:String?=nil) -> String {
        return _colorWrap(text: text, foregroundColor: foregroundColor, backgroundColor: backgroundColor)
    }
    
    
    private static func _colorWrap(text:String, foregroundColor:String, backgroundColor:String?=nil) -> String {
        if (backgroundColor == nil && foregroundColor == UIColor.defaultForegroundColor().rgbString()) {
            return text
        }
        var str = "\(ESCAPE)fg\(foregroundColor);"
        var escape = RESET_FG
        if let backgroundColor = backgroundColor {
            str = "\(str)\(ESCAPE)bg\(backgroundColor);"
            escape = "\(RESET_BG)\(escape)"
        }
        return "\(str)\(text)\(escape)"
    }
}
