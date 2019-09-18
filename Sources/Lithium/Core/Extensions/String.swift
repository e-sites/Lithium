//
//  String.swift
//  Pods
//
//  Created by Bas van Kuijck on 26-04-16.
//
//

import Foundation

extension String {
    func trimWhitespaces() -> String {
        var str = self.replacingOccurrences(of: "\t", with: "")
        str = str.replacingOccurrences(of: "\n", with: "")
        str = str.replacingOccurrences(of: "\r", with: "")
        
        for _ in 0...5 {
            str = str.replacingOccurrences(of: "  ", with: " ")
            
        }
        return str
    }
}

func * (string: String, repeatCount: Int) -> String {
    var str = ""
    for _ in 0..<repeatCount {
        str = str + string
    }
    return str
}
