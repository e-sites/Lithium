![Lithium](Assets/logo.png)

Lithium is part of the **[E-sites iOS Suite](https://github.com/e-sites/iOS-Suite)**.

---

_The_ E-sites logging framework.

[![forthebadge](http://forthebadge.com/images/badges/made-with-swift.svg)](http://forthebadge.com) [![forthebadge](http://forthebadge.com/images/badges/built-with-swag.svg)](http://forthebadge.com)

[![Travis-ci](https://travis-ci.org/e-sites/Lithium.svg?branch=master&001)](https://travis-ci.org/e-sites/Lithium)


# Installation

## SwiftPM

**package.swift** dependency:

```swift
.package(url: "https://github.com/e-sites/lithium.git", from: "9.0.0"),
```

and to your application/library target, add `"Lithium"` to your `dependencies`, e.g. like this:

```swift
.target(name: "BestExampleApp", dependencies: ["Lithium"]),
```

# Implementation

## Initialization

```swift
import Lithium

let logger: Logger = {
    var ll = Logger(label: "com.swift-log.awesome-app")
    ll.logLevel = .trace
    return ll
}()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
		LoggingSystem.bootstrap { label -> LogHandler in
			var lithiumLogger = LithiumLogger(label: label)
			lithiumLogger.theme = EmojiLogTheme()
			return lithiumLogger
		}
	    
		return true
	}
}
```