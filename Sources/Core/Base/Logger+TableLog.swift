import Foundation

extension Logger {
    
    // MARK: - Pretty print
    // ____________________________________________________________________________________________________________________

    // Object
    @discardableResult
    public func table<O>(object: O,
                         shouldPrint: Bool = true,
                         file: String = #file,
                         function: String = #function,
                         line: Int = #line,
                         column: Int = #column) -> [String] {
        let mirror = Mirror(reflecting: object)
        var dictionary: [String: Any] = [:]

        for attr in mirror.children {
            if let propertyName = attr.label {
                dictionary[propertyName] = attr.value
            }
        }

        return table(
            dictionary: dictionary,
            title: "\(type(of: object))",
            shouldPrint: shouldPrint,
            file: file,
            function: function,
            line: line,
            column: column)
    }
    
    
    @discardableResult
    public func table<O>(object: O?,
                         shouldPrint: Bool = true,
                         file: String = #file,
                         function: String = #function,
                         line: Int = #line,
                         column: Int = #column) -> [String] {
        guard let object = object else {
            return []
        }
        return table(object: object, shouldPrint: shouldPrint, file: file, function: function, line:line, column:column)
    }
    
    // Dictionary
    @discardableResult
    public func table<V>(dictionary: [String: V],
                         title: String = "Dictionary",
                         shouldPrint: Bool = true,
                         file: String = #file,
                         function: String = #function,
                         line: Int = #line,
                         column: Int = #column) -> [String] {
        return table(dictionary: dictionary as [String: V?], title: title, shouldPrint: shouldPrint, file: file, function: function, line:line, column:column)
    }
    
    
    @discardableResult
    public func table<V>(dictionary: [String: V?],
                         title: String = "Dictionary",
                         shouldPrint: Bool = true,
                         file: String = #file,
                         function: String = #function,
                         line: Int = #line,
                         column: Int = #column) -> [String] {
        return _prettyPrint(dictionary: dictionary,
                            title: title,
                            shouldPrint: shouldPrint,
                            context: (file: file, function: function, line:line,  column: column, thread: Thread.current)) {
                                return $0 > $1
        }
    }
    
    
    @discardableResult
    public func table<V>(array: [V],
                         title: String = "Array",
                         shouldPrint: Bool = true,
                         file: String = #file,
                         function: String = #function,
                         line: Int = #line,
                         column: Int = #column) -> [String] {
        return table(array: array as [V?], title: title, shouldPrint: shouldPrint, file: file, function: function, line:line, column:column)
    }
    
    @discardableResult
    public func table<V>(array: [V?],
                         title: String = "Array",
                         shouldPrint: Bool = true,
                         file: String = #file,
                         function: String = #function,
                         line: Int = #line,
                         column: Int = #column) -> [String] {
        return _table(array: array, title: title, shouldPrint: shouldPrint, file: file, function: function, line: line, column: column)
    }
    
    
    private func _table<V>(array: [V?],
                           title: String = "Array",
                           shouldPrint: Bool = true,
                           file: String = #file,
                           function: String = #function,
                           line: Int = #line,
                           column: Int = #column) -> [String] {
        let prevAlignment = prettyPrintKeyAlignment
        prettyPrintKeyAlignment = .right
        var dictionary: [String: V?] = [:]
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
    
    private func _prettyPrint<V>(dictionary: [String: V?],
                                 title: String?,
                                 shouldPrint: Bool,
                                 context: Logger.LogContext,
                                 sort: ((String, String) -> Bool)) -> [String] {
        if dictionary.keys.isEmpty {
            return []
        }

        var newDictionaryMap: [String: String] = [:]
        let longestKeyCount = dictionary.keys.sorted { $0.count > $1.count }.first!.count
        for key in dictionary.keys {
            var strKey = "\(key)"
            var str = "(nil)"
            let vv = dictionary[key]
            
            if let v = vv {
                var className = String(describing: type(of: v)).replacingOccurrences(of: "__", with: "")
                
                if v == nil {
                    str = "nil"
                } else {
                    str = "\(String(describing: v))"
                    if v is String || v is NSString {
                        className = "String"
                        str = "\"\(String(describing: v))\""
                        
                    } else if className == "NSCFBoolean" {
                        className = "Bool"
                        str = (v as! Bool) ? "true": "false"

                    } else if className == "NSCFNumber" {
                        className = "Number"
                    }
                }
                
            }
            switch prettyPrintKeyAlignment {
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
            
            newDictionaryMap[strKey] = str.trimWhitespaces()
        }
        let longestVal = newDictionaryMap.values.sorted { $0.count > $1.count }
        
        let maximumValueCharactersCount = prettyPrintMaximumTableWidth - (longestKeyCount + 7)
        let longestValCount: Int = max(6, min(maximumValueCharactersCount, longestVal.first!.count))
        var lines: [String] = []
        let c = longestKeyCount + longestValCount + 5
        if let title = title {
            let l = "-" * c
            lines.append("+\(l)+")
            var spacesLeft = c - title.count
            let spacesRight = spacesLeft / 2
            spacesLeft -= spacesRight
            let sLeft = " " * spacesLeft
            let sRight = " " * spacesRight
            
            lines.append("|" + sLeft + title + sRight + "|")
            
        }
        
        var l = "-" * (longestKeyCount + 2)
        l += "+"
        l += "-" * (longestValCount + 2)
        
        lines.append("+\(l)+")
        let keys = newDictionaryMap.keys.sorted { (o1,o2) in
            return sort(o1, o2)
        }
        
        keys.forEach { key in
            let spacesKey = " " * (longestKeyCount - key.count)
            var valueString = "(nil)"
            if let value = newDictionaryMap[key] {
                valueString = value
            }
            
            if valueString.count > maximumValueCharactersCount {
                let endIndex = valueString.index(valueString.startIndex, offsetBy: maximumValueCharactersCount - 3)
                valueString = String(valueString[...endIndex])
            }
            let spacesValue = " " * (longestValCount - valueString.count)
            
            lines.append("| " + key + spacesKey + " | " +  valueString + spacesValue + " |")
        }
        
        lines.append("+\(l)+")        
        
        if shouldPrint {
            let level = LogLevel.info
            lines.forEach {
                log(level: level, style: theme.defaultStyle, [ "\($0)" ], file: context.file, function: context.function, line:context.line, column:context.column)
            }
        }
        return lines
    }
}
