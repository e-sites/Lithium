![Lithium](Assets/logo.png)

Lithium is part of the **[E-sites iOS Suite](https://github.com/e-sites/iOS-Suite)**.

---

_The_ E-sites logging framework.

[![forthebadge](http://forthebadge.com/images/badges/made-with-swift.svg)](http://forthebadge.com) [![forthebadge](http://forthebadge.com/images/badges/built-with-swag.svg)](http://forthebadge.com)

[![Platform](https://img.shields.io/cocoapods/p/Lithium.svg?style=flat)](http://cocoadocs.org/docsets/Lithium)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Lithium.svg)](http://cocoadocs.org/docsets/Lithium)
[![Quality](https://apps.e-sites.nl/cocoapodsquality/Lithium/badge.svg?004)](https://cocoapods.org/pods/Lithium/quality)
[![Travis-ci](https://travis-ci.org/e-sites/Lithium.svg?branch=master&001)](https://travis-ci.org/e-sites/Lithium)


# Installation

Podfile:

```ruby
pod 'Lithium'
```

And then

```
pod install
```

# Implementation

## Initialization

```swift
import Lithium
let logger = Lithium.Logger()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    logger.theme = DefaultDarkLogTheme()
    // logger.theme = NoColorsLogTheme() // If you don't have the XcodeColors plugin installed
    #if !DEBUG
    logger.enabled = false
    #endif
    
    // ... The rest of the launch stuff
    
    return true
}
```

## Logging

```swift
public func error(_ items:Any...)
public func warning(_ items:Any...,)    
public func exe(_ items:Any...)    
public func debug(_ items:Any...)    
public func info(_ items:Any...)    
public func success(_ items:Any...)    
public func verbose(_ items:Any...)
public func log(_ items:Any...)    
public func colorLog(_ foregroundColor: String, backgroundColor:String?=nil, _ items:Any...)
public func request(_ method: String, _ url:String, _ parameters:String?=nil)
public func response(_ method: String, _ url:String, _ parameters:String?=nil)

public func table<O>(object:O, shouldPrint:Bool=true)
public func table<O>(object: O, shouldPrint:Bool=true)
public func table<V>(array: [V], shouldPrint:Bool=true)
public func table<V>(dictionary: [String: V], title: String, shouldPrint: Bool)
```

## Crashlytics

You can also automatically log to crashlytics:

```swift
Fabric.with([Crashlytics.self])

logger.logProxy = { _, _, message, _ in
    CLSLogv("%@", getVaList([ message ]))
}
```