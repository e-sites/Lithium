//
//  Logger+Parse.swift
//  ESLog
//
//  Created by Bas van Kuijck on 26-04-16.
//  Copyright © 2016 E-sites. All rights reserved.
//

import Foundation

extension Logger {
    public enum ParseType : Int {
        case html = 0, plainText = 1
    }
    
    
    // MARK: - HTML
    // ____________________________________________________________________________________________________________________
    
    private func _convertSpecialCharacters(string: String) -> String {
        var string = string
        let charDictionary = [
            "&lt;": "<",
            "&gt;": ">",
            "&quot;": "\"",
            "&apos;": "'",
            "&#160;": " "
        ]
        
        for (escapedChar, unescapedChar) in charDictionary {
            string = string.replacingOccurrences(of: unescapedChar, with: escapedChar, options: .regularExpression, range: nil)
            
        }
        return string
    }
    
    /**
     Can be used in combination with the logProxy closure:
     
     ESLog.logProxy = { line in
     print(Logger.parse(line: line, to: .HTML))
     }
     
     - parameter line: String
     
     - returns: HTML formatted String of the line (e.g: `<span style='color:rgb(71,160,40)'>App&#160;successfully&#160;loaded</span>`)
     
     */
    public func parse(line: String, to parseType: ParseType) -> String {
        return _parse(line: line, to: parseType)
    }
    
    
    private func _parse(line: String, to parseType: ParseType) -> String {
        let escapeCharUnescaped = LogFormatter.ESCAPE
        
        let escapeChar = escapeCharUnescaped.replacingOccurrences(of: "[", with: "\\[")
        
        
        var str = line
        
        let htmlParseType:ParseType = .html
        let plainParseType:ParseType = .plainText
        
        
        if (parseType == htmlParseType) {
            str = _convertSpecialCharacters(string: str)
        }
        do {
            for type in [ "fg", "bg" ] {
                let wt = "\(escapeChar)\(type)"
                var attempts = 0
                while (true) {
                    let pattern = String(format: "%@([0-9]{1,3},[0-9]{1,3},[0-9]{1,3});(.+?)%@;", wt, wt)
                    let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
                    
                    var template = "$2"
                    if (parseType == htmlParseType) {
                        template = String(format: "<span style='%@:rgb($1)'>$2</span>", (type == "fg" ? "color" : "background-color"))
                    }
                    str = regex.stringByReplacingMatches(in: str,
                                                         options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                         range: NSMakeRange(0, str.count),
                                                         withTemplate: template)
                    if (!str.contains("\(escapeCharUnescaped)\(type)") || attempts == 10) {
                        break
                    }
                    
                    attempts += 1
                }
            }
            if (parseType == plainParseType) {
                if let regex = try? NSRegularExpression(pattern: "(\u{001b}\\[(|bg|fg)(|[0-9]{1,3},[0-9]{1,3},[0-9]{1,3});)", options: .caseInsensitive) {
                    str = regex.stringByReplacingMatches(in: str, options: .withTransparentBounds, range: NSMakeRange(0, str.count), withTemplate: "")
                }
            }
            return str
            
        } catch { }
        return line
    }
}
