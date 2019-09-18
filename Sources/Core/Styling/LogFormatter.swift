//
//  LogFormat.swift
//  Lithium
//
//  Created by Bas van Kuijck on 25-04-16.
//  Copyright © 2016 E-sites. All rights reserved.
//

import Foundation

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
    
    public var format = "%@ [%@] %@:%@ [t:%@] %@%@"
    fileprivate let dateFormatter = DateFormatter()
    
    
    public var components: [Component] = [
        .date(format: "yyyy-MM-dd HH:mm:ss.SSS"),
        .targetName,
        .file(fullPath: false, showExtension: false),
        .lineNumber,
        .threadNumber,
        .prefix(format: "%@: "),
        .message
        ] {
        didSet {
            _setDateFormatter()
        }
    }
    
    public var separator = " "
    
    init() {
        _setDateFormatter()
    }

    public init(format: String, components: [Component]) {
        self.format = format
        self.components = components
        _setDateFormatter()
    }
}

extension LogFormatter {
    
    func format(component: Component, style:LogStyle, level:LogLevel, items: [Any], context: Logger.LogContext) -> String {
        func _parseDate(format: String) -> String {
            return dateFormatter.string(from: Date())
        }
        
        func _parseMessage() -> String {
            return style.render(text: items.map{ "\($0)" }.joined(separator: separator))
        }
        
        func _parsePrefix(prefixFormat: String) -> String {
            guard let prefixText = style.prefixText else {
                return ""
            }
            
            return String(format: prefixFormat, prefixText)
        }
        
        func _parseThread() -> String {
            if !context.thread.isMainThread,
                let n = context.thread.value(forKeyPath: "private.seqNum") as? NSNumber {
                return "\(n)"
            }

            return "m"
        }
        
        func _parseFile(fullPath: Bool, ext: Bool) -> String {
            var str = context.file
            if !fullPath {
                str = str.components(separatedBy: "/").last ?? ""
            }

            if !ext {
                var s = str.components(separatedBy: ".")
                s.removeLast()
                str = s.joined(separator: ".")
                
            }
            return str
        }
        
        func _parseTargetName() -> String {
            return (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? ""
        }
        
        switch component {
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

    func parse(level: LogLevel, style: LogStyle, items: [Any], context: Logger.LogContext) -> String {
        return _parse(level: level, style: style, items: items, context: context)
    }
    
    
    private func _parse(level: LogLevel, style: LogStyle, items: [Any], context: Logger.LogContext) -> String {
        let arguments = components.map { component -> CVarArg in
            return self.format(component: component, style: style, level: level, items: items, context: context)
        }
        
        return String(format: format, arguments: arguments)
    }
}

extension LogFormatter {    
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
