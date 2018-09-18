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
import SwiftHEXColors

protocol DysprosiumDeallocStyleable {
    var deallocStyle: LogStyle { get }
}

extension EsitesDarkLogTheme: DysprosiumDeallocStyleable {
    var deallocStyle: LogStyle {
        let style = LogStyle()
        style.foregroundColor = UIColor(hex: 0xff5a00)!
        style.prefixBackgroundColor = style.foregroundColor
        style.prefixText = " DEALLOC "
        return style
    }
}

extension EsitesLightLogTheme: DysprosiumDeallocStyleable {
    var deallocStyle: LogStyle {
        let style = LogStyle()
        style.foregroundColor = UIColor(hex: 0xff5a00)!
        style.prefixBackgroundColor = style.foregroundColor
        style.prefixText = " DEALLOC "
        return style
    }
}

extension DefaultDarkLogTheme: DysprosiumDeallocStyleable {
    var deallocStyle: LogStyle {
        let style = LogStyle()
        style.foregroundColor = UIColor(hex: 0xC5C8C6)!
        style.prefixForegroundColor = UIColor(hex: 0xff5a00)
        style.prefixText = "Dealloc"
        return style
    }
}

extension DefaultLightLogTheme: DysprosiumDeallocStyleable {
    var deallocStyle: LogStyle {
        let style = LogStyle()
        style.foregroundColor = UIColor(hex: 0x404040)!
        style.prefixForegroundColor = UIColor(hex: 0xff5a00)
        style.prefixText = "Dealloc"
        return style
    }
}

extension EmojiLogTheme: DysprosiumDeallocStyleable {
    var deallocStyle: LogStyle {
        let style = LogStyle()
        style.prefixText = "☠️ DEA"
        return style
    }
}

extension NoColorsLogTheme: DysprosiumDeallocStyleable {
    var deallocStyle: LogStyle {
        let style = LogStyle()
        style.prefixText = "DEALLOC"
        return style
    }
}

extension Logger {
    
    private func _colorWrap(color: String, string:String) -> String  {
        if !theme.hasColors {
            return string
        }
        return String(format: "\u{001b}[fg%@;%@\u{001b}[;", color, string)
    }
    
    public func setupWithDysprosium() {
        Dysprosium.shared.isEnabled = true
        Dysprosium.shared.onDealloc { models in
            var strArray:[String] = []
            var classesDone:[String] = []
            let priColor = "80,80,80"
            let secColor = "160,160,160"
            
            // Iterate through the current deallocated models
            // To find any double classnames
            // So you will get <x> <Classname> instances
            for model in models {
                let filteredArray = models.filter { filterModel -> Bool in
                    return model.className == filterModel.className
                }
                
                let count = filteredArray.count
                if (count == 1) {
                    strArray.append(self._colorWrap(color: priColor, string: model.description))
                    
                } else {
                    if (!classesDone.contains(model.className)) {
                        
                        strArray.append(String(format: "%@ %@ %@", self._colorWrap(color: secColor, string: String(count)), self._colorWrap(color: priColor, string: model.classNameDescription), self._colorWrap(color: secColor, string: "instances")))
                        classesDone.append(model.className)
                    }
                }
            }
            var str:String?
            if (strArray.count > 1) {
                let lastObject:String = strArray.last!
                strArray.removeLast()
                str = String(format: "%@ %@ %@", strArray.joined(separator: self._colorWrap(color: secColor, string: ", ")), self._colorWrap(color: secColor, string: "and"), self._colorWrap(color: priColor, string: lastObject))
                
            } else {
                str = strArray.joined(separator: self._colorWrap(color: secColor, string: ", "))
                
            }
            if let deallocTheme = self.theme as? DysprosiumDeallocStyleable {
                self.log(level: .info, style: deallocTheme.deallocStyle, [ str! ])
            }
            
        }
        
        Dysprosium.shared.onExpectedDeallocation { obj, reason in
            let str = self._colorWrap(color: "134,0,0", string: "\(obj)") +
                self._colorWrap(color: "255,0,0", string: " not being deallocated \(reason)")

            if let deallocTheme = self.theme as? DysprosiumDeallocStyleable {
                self.log(level: .info, style: deallocTheme.deallocStyle, [ str ])
            }
            
        }
    }
}
