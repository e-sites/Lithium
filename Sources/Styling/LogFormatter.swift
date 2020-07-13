//
//  LogFormat.swift
//  Lithium
//
//  Created by Bas van Kuijck on 25-04-16.
//  Copyright © 2016 E-sites. All rights reserved.
//

import Foundation
import Logging

struct LogContext {
    let thread: Thread
    let file: String
    let function: String
    let line: UInt
}

public class LogFormatter {
    public enum Component {
        case date(format: String)
        case prefix
        case message
        case targetName
        case lineNumber
        case file(fullPath: Bool, showExtension: Bool)
        case threadNumber
        case metadata(format: String)
    }
    
    public var format = "%@ [%@] %@:%@ [t:%@] %@: %@"
    fileprivate let dateFormatter = DateFormatter()
    
    
    public var components: [Component] = [
        .date(format: "yyyy-MM-dd HH:mm:ss.SSS"),
        .targetName,
        .file(fullPath: false, showExtension: false),
        .lineNumber,
        .threadNumber,
        .prefix,
        .message,
        .metadata(format: " -- %@")
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
    
    private func format(component: Component, style: LogStyle, message: String, context: LogContext, metadata: String?) -> String {
        func _parseDate(format: String) -> String {
            return dateFormatter.string(from: Date())
        }

        func _parseMessage() -> String {
            return style.render(text: message)
        }

        func _parseMetadata(format: String) -> String {
            guard let metadataString = metadata else {
                return ""
            }
            return String(format: format, metadataString)
        }
        
        func _parsePrefix() -> String {
            return style.prefixText ?? ""
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
            
        case .prefix:
            return _parsePrefix()
            
        case .threadNumber:
            return _parseThread()
            
        case .file(let fullPath, let ext):
            return _parseFile(fullPath: fullPath, ext: ext)
            
        case .lineNumber:
            return "\(context.line)"
            
        case .targetName:
            return _parseTargetName()

        case .metadata(let format):
            return _parseMetadata(format: format)
        }
        
    }

    func parse(style: LogStyle, message: String, context: LogContext, metadata: String?) -> String {
        return _parse(style: style, message: message, context: context, metadata: metadata)
    }
    
    
    private func _parse(style: LogStyle, message: String, context: LogContext, metadata: String?) -> String {
        let arguments = components.map { component -> CVarArg in
            return self.format(component: component, style: style, message: message, context: context, metadata: metadata)
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
