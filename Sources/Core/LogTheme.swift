//
//  LogTheme.swift
//  ESLog
//
//  Created by Bas van Kuijck on 26-04-16.
//  Copyright © 2016 E-sites. All rights reserved.
//

import Foundation
import UIKit
import UIKit

public class LogStyle: Equatable {
    private var uuid = UUID().uuidString
    
	public var foregroundColor = UIColor.black
	
    public var backgroundColor:UIColor?
    public var prefixBackgroundColor:UIColor?
    public var prefixForegroundColor:UIColor?
    
    public var prefixText:String?
    
    public init() {
        
    }
    
    public static func == (lhs: LogStyle, rhs: LogStyle) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

public class TableStyle {
    public var lineColor:UIColor?
    public var keyColor:UIColor?
    public var defaultValueColor:UIColor?
	public var titleColor:UIColor?
	public var classColors:[String:UIColor] = ["String": UIColor.black]
}

public protocol LogTheme {
    var defaultStyle:LogStyle { get set }
    var errorStyle:LogStyle { get set }
    var debugStyle:LogStyle { get set }
    var infoStyle:LogStyle { get set }
    var warningStyle:LogStyle { get set }
    var successStyle:LogStyle { get set }
    var verboseStyle:LogStyle { get set }
    var executeStyle:LogStyle { get set }
    var tableStyle:TableStyle { get set }
    
    var lineColor:UIColor { get set }
    var contextForegroundColor:UIColor { get set }
    
    var formatter:LogFormatter { get set }
}


public class DefaultThemes {
    public static func light() -> DefaultLightLogTheme {
        return DefaultLightLogTheme()
    }
    
    public static func dark() -> DefaultDarkLogTheme {
        return DefaultDarkLogTheme()
    }
}
