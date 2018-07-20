import Foundation
import UIKit

extension Logger {
    
    // MARK: - Pretty print
    // ____________________________________________________________________________________________________________________
    
    private func _colorWrap(color:String, string:String) -> String {
        return LogFormatter.colorWrap(text: string, foregroundColor: color)
    }
    
    // Object
    @discardableResult public func table<O>(object:O, shouldPrint:Bool=true, file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) -> [String] {
        let mirror = Mirror(reflecting: object)
        var dictionary:[String:Any] = [:]
        for (_, attr) in mirror.children.enumerated() {
            if let propertyName = attr.label {
                dictionary[propertyName] = attr.value
            }
        }
        return table(dictionary: dictionary, title: "\(type(of: object))", shouldPrint: shouldPrint, file: file, function: function, line:line, column:column)
    }
    
    
    @discardableResult public func table<O>(object:O?, shouldPrint:Bool=true, file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) -> [String] {
        guard let object = object else {
            return []
        }
        return table(object: object, shouldPrint: shouldPrint, file: file, function: function, line:line, column:column)
    }
    
    // Dictionary
    @discardableResult public func table<V>(dictionary: [String: V], title:String="Dictionary", shouldPrint:Bool=true, file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) -> [String] {
        var transformDic:[String:V?] = [:]
        dictionary.keys.forEach { key in
            transformDic[key] = dictionary[key]
        }
        return table(dictionary: transformDic, title: title, shouldPrint: shouldPrint, file: file, function: function, line:line, column:column)
    }
    
    
    @discardableResult public func table<V>(dictionary: [String: V?], title:String="Dictionary", shouldPrint:Bool=true, file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) -> [String] {
        return _prettyPrint(dictionary: dictionary, title: title, shouldPrint: shouldPrint, context: (file: file, function: function, line:line, column: column, thread: Thread.current)) {
            return $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
        }
    }
    
    
    @discardableResult public func table<V>(array: [V], title:String="Array", shouldPrint:Bool=true, file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) -> [String] {
        var ar:[V?] = []
        array.forEach {
            ar.append($0)
        }
        
        return table(array: ar, title: title, shouldPrint: shouldPrint, file: file, function: function, line:line, column:column)
    }
    
    @discardableResult public func table<V>(array: [V?], title:String="Array", shouldPrint:Bool=true, file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) -> [String] {
        return _table(array: array, title: title, shouldPrint: shouldPrint, file: file, function: function, line: line, column: column)
    }
    
    
    private func _table<V>(array: [V?], title:String="Array", shouldPrint:Bool=true, file:String=#file, function:String=#function, line:Int=#line, column:Int=#column) -> [String] {
        let prevAlignment = prettyPrintKeyAlignment
        prettyPrintKeyAlignment = .right
        var dictionary:[String:V?] = [:]
        var i = 0
        array.forEach {
            dictionary["\(i)"] = $0
            i += 1
        }
        defer {
            prettyPrintKeyAlignment = prevAlignment
        }
        
        
        return _prettyPrint(dictionary: dictionary, title: title, shouldPrint: shouldPrint, context: (file: file, function: function, line:line, column: column, thread: Thread.current)) { (o1, o2) in
            let s1 = o1.replacingOccurrences(of: " ", with: "")
            let s2 = o2.replacingOccurrences(of: " ", with: "")
            return Int64(s1) ?? 0 < Int64(s2) ?? 0
        }
        
    }
    
    private func _prettyPrint<V>(dictionary: [String: V?], title:String?, shouldPrint:Bool, context:Logger.LogContext, sort: ((String, String) -> Bool)) -> [String] {
        if (dictionary.keys.isEmpty) {
            return []
        }
        let lineColor = theme.tableStyle.lineColor ?? theme.lineColor
        let keyColor = theme.tableStyle.keyColor ?? theme.defaultStyle.foregroundColor
        let defaultValueColor = theme.tableStyle.defaultValueColor ?? theme.defaultStyle.foregroundColor
        let titleColor = theme.tableStyle.titleColor ?? theme.successStyle.foregroundColor
        
        var newDictionaryMap:[String:(String, String)] = [:]
        
        let longestKeyCount:Int = dictionary.keys.sorted { $0.count > $1.count }.first!.count
        let enumerated = dictionary.keys.enumerated()
        
        for (_, key) in enumerated {
            var strKey = "\(key)"
            var c = defaultValueColor.rgbString()
            var str = "(nil)"
            let vv = dictionary[key]
            
            if let v = vv {
                c = defaultValueColor.rgbString()
                var className = String(describing: type(of: v)).replacingOccurrences(of: "__", with: "")
                
                if v == nil {
                    str = "nil"
                } else {
                    str = "\(String(describing: v))"
                    if (v is String || v is NSString) {
                        className = "String"
                        str = "\"\(String(describing: v))\""
                    } else if (className == "NSCFBoolean") {
                        className = "Bool"
                        str = (v as! Bool) ? "true": "false"

                    } else if (className == "NSCFNumber") {
                        className = "Number"
                    }
                }
                
                if let vk = theme.tableStyle.classColors[className] {
                    c = vk.rgbString()
                }
                
            }
            switch (prettyPrintKeyAlignment) {
            case .right:
                let p = " " * (longestKeyCount - strKey.count)
                strKey = "\(p)\(key)"
                
            case .center:
                var lp = longestKeyCount - strKey.count
                let rp = lp / 2
                lp -= rp
                let llp = " " * lp
                let lrp = " " * rp
                strKey = "\(llp)\(key)\(lrp)"
            default:
                break
            }
            
            newDictionaryMap[strKey] = (str.trimWhitespaces(), c)
        }
        let longestVal = newDictionaryMap.values.sorted { $0.0.count > $1.0.count }
        let color = lineColor.rgbString()
        
        
        let maximumValueCharactersCount = prettyPrintMaximumTableWidth - (longestKeyCount + 7)
        let longestValCount:Int = max(6, min(maximumValueCharactersCount, longestVal.first!.0.count))
        var lines:[String] = []
        let c = (longestKeyCount + longestValCount + 5)
        if let title = title {
            let l = "-" * c
            lines.append(_colorWrap(color: color, string: "+\(l)+"))
            var spacesLeft = c - title.count
            let spacesRight = spacesLeft / 2
            spacesLeft -= spacesRight
            let sLeft = " " * spacesLeft
            let sRight = " " * spacesRight
            
            lines.append(_colorWrap(color: color, string: "|") + sLeft + _colorWrap(color: titleColor.rgbString(), string: title) + sRight + _colorWrap(color: color, string: "|"))
            
        }
        
        var l = "-" * (longestKeyCount + 2)
        l += "+"
        l += "-" * (longestValCount + 2)
        
        lines.append(_colorWrap(color: color, string: "+\(l)+"))
        let keys = newDictionaryMap.keys.sorted { (o1,o2) in
            return sort(o1, o2)
        }
        
        keys.forEach { key in
            let spacesKey = " " * (longestKeyCount - key.count)
            var valueString = _colorWrap(color: color, string: "(nil)")
            var colorString = defaultValueColor.rgbString()
            if let value = newDictionaryMap[key] {
                valueString = value.0
                colorString = value.1
            }
            
            if (valueString.count > maximumValueCharactersCount) {
                let endIndex = valueString.index(valueString.startIndex, offsetBy: maximumValueCharactersCount - 3)
                valueString = String(valueString[...endIndex])
            }
            let spacesValue = " " * (longestValCount - valueString.count)
            
            lines.append(_colorWrap(color: color, string: "| ") + _colorWrap(color: keyColor.rgbString(), string: key) + spacesKey + _colorWrap(color: color, string: " | ") + _colorWrap(color: colorString, string: valueString) + spacesValue + _colorWrap(color: color, string: " |"))
            
        }
        
        lines.append(_colorWrap(color: color, string: "+\(l)+"))
        
        
        if (shouldPrint) {
            let level = LogLevel.info
            lines.forEach {
                log(level: level, style: theme.defaultStyle, [ "\($0)" ], file: context.file, function: context.function, line:context.line, column:context.column)
            }
        }
        return lines
    }
}
