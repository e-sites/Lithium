//
//  Logger+Line.swift
//  Lithium
//
//  Created by Bas van Kuijck on 26-04-16.
//  Copyright © 2016 E-sites. All rights reserved.
//

import Foundation

extension Logger {
    
    public func logDivider(_ char: String,
                           length: Int = 100,
                           file: String = #file,
                           function: String = #function,
                           line: Int = #line,
                           column: Int = #column) {
        log(char * length, file: file, function: function, line: line, column: column)
    }    
    
    public func singleLine(file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        logDivider("-", file: file, function: function, line: line, column: column)
    }
    
    public func doubleLine(file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        logDivider("=", file: file, function: function, line: line, column: column)
    }
    
    public func plusLine(file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        logDivider("+", file: file, function: function, line: line, column: column)
    }
    
    public func dotsLine(file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        logDivider("·", file: file, function: function, line: line, column: column)
    }
    
    public func doubleDotsLine(file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        logDivider(":", file: file, function: function, line: line, column: column)
    }
}
