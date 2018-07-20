//
//  Logger-Dysprosium.swift
//  iOS Suite
//
//  Created by Bas van Kuijck on 14-06-16.
//  Copyright © 2016 E-sites. All rights reserved.
//

import Foundation
import Dysprosium
import UIKit

private class DeallocStyle {
    static var sharedStyle: LogStyle {
        let style = LogStyle()
        style.foregroundColor = UIColor(hex: 0xff5a00)!
        style.prefixBackgroundColor = style.foregroundColor
        style.prefixText = " DEALLOC "
        return style
    }

    static var sharedNoColorsStyle: LogStyle {
        let style = LogStyle()
        style.foregroundColor = UIColor.black
        style.prefixForegroundColor = UIColor.white
        style.prefixText = "DEALLOC"
        return style
    }
}

extension Logger {
    
    private func _colorWrap(colors:Bool, color: String, string:String) -> String  {
        if (!colors) {
            return string
        }
        return String(format: "\u{001b}[fg%@;%@\u{001b}[;", color, string)
    }
    
    public func setupWithDysprosium(useColors colors:Bool=true) {
        Dysprosium.shared.onDealloc { models in
            var strArray:[String] = []
            var classesDone:[String] = []
            let priColor = colors ? "80,80,80" : "0,0,0"
            let secColor = colors ? "160,160,160" : "0,0,0"
            
            // Iterate through the current deallocated models
            // To find any double classnames
            // So you will get <x> <Classname> instances
            for model in models {
                let filteredArray = models.filter { filterModel -> Bool in
                    return model.className == filterModel.className
                }
                
                let count = filteredArray.count
                if (count == 1) {
                    strArray.append(self._colorWrap(colors: colors, color: priColor, string: model.description))
                    
                } else {
                    if (!classesDone.contains(model.className)) {
                        
                        strArray.append(String(format: "%@ %@ %@", self._colorWrap(colors: colors, color: secColor, string: String(count)), self._colorWrap(colors: colors, color: priColor, string: model.classNameDescription), self._colorWrap(colors: colors, color: secColor, string: "instances")))
                        classesDone.append(model.className)
                    }
                }
            }
            var str:String?
            if (strArray.count > 1) {
                let lastObject:String = strArray.last!
                strArray.removeLast()
                str = String(format: "%@ %@ %@", strArray.joined(separator: self._colorWrap(colors: colors, color: secColor, string: ", ")), self._colorWrap(colors: colors, color: secColor, string: "and"), self._colorWrap(colors: colors, color: priColor, string: lastObject))
                
            } else {
                str = strArray.joined(separator: self._colorWrap(colors: colors, color: secColor, string: ", "))
                
            }
            
            self.log(level: .info, style: colors ? DeallocStyle.sharedStyle : DeallocStyle.sharedNoColorsStyle, [ str! ])
            
        }
        
        Dysprosium.shared.onExpectedDeallocation { obj, reason in
            let str = self._colorWrap(colors: colors, color: "134,0,0", string: "\(obj)") +
                self._colorWrap(colors: colors, color: "255,0,0", string: " not being deallocated \(reason)")
            self.log(level: .info, style: DeallocStyle.sharedStyle, [ str ])
            
        }
    }
}
