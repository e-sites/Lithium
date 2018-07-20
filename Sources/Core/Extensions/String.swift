//
//  String.swift
//  Pods
//
//  Created by Bas van Kuijck on 26-04-16.
//
//

import Foundation
import UIKit

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
    
    func color() -> UIColor? {
        let s = self.components(separatedBy: ",")
        
        let spl = s.map { CGFloat(($0 as NSString).doubleValue / 255.0) }
        if (spl.count == 3 || spl.count == 4) {
            return UIColor(red: spl[0], green:spl[1], blue: spl[2], alpha: 1)
        }
        return nil
    }
}

func * (string: String, repeatCount: Int) -> String {
    var str = ""
    for _ in 0..<repeatCount {
        str = str + string
    }
    return str
}
