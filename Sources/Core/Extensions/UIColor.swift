//
//  UIColor.swift
//  Pods
//
//  Created by Bas van Kuijck on 26-04-16.
//
//

import Foundation
import UIKit

extension UIColor {
    func rgbString() -> String {
        var red:CGFloat = 0, green:CGFloat = 0, blue:CGFloat = 0, alpha:CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "%.0f,%.0f,%.0f", red * 255, green * 255, blue * 255)
    }
}