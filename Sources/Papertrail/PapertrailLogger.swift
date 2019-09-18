//
//  PapertrailLogger.swift
//  Library
//
//  Created by Bas van Kuijck on 10/11/2016.
//  Copyright © 2016 E-sites. All rights reserved.
//

import Foundation
import CocoaAsyncSocket
import Erbium

public var logTag: String?

extension Logger {
    
    public func setupWithPapertrail(host: String, port: UInt16) {
        PapertrailLogger.default.setup(logger: self, host: host, port: port)
    }
    
    public func error(tag: String, _ items: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        let originalLogTag = logTag
        logTag = tag
        error(items.map { "\($0)" }.joined(separator: formatter.separator), file: file, function: function, line: line, column: column)
        logTag = originalLogTag
    }
    
    public func warning(tag: String, _ items: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        let originalLogTag = logTag
        logTag = tag
        warning(items.map { "\($0)" }.joined(separator: formatter.separator), file: file, function: function, line: line, column: column)
        logTag = originalLogTag
    }
    
    public func exe(tag: String, _ items: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        let originalLogTag = logTag
        logTag = tag
        exe(items.map { "\($0)" }.joined(separator: formatter.separator), file: file, function: function, line: line, column: column)
        logTag = originalLogTag
    }
    
    public func debug(tag: String, _ items: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        let originalLogTag = logTag
        logTag = tag
        debug(items.map { "\($0)" }.joined(separator: formatter.separator), file: file, function: function, line: line, column: column)
        logTag = originalLogTag
    }
    
    public func info(tag: String, _ items: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        let originalLogTag = logTag
        logTag = tag
        info(items.map { "\($0)" }.joined(separator: formatter.separator), file: file, function: function, line: line, column: column)
        logTag = originalLogTag
    }
    
    public func success(tag: String, _ items: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        let originalLogTag = logTag
        logTag = tag
        success(items.map { "\($0)" }.joined(separator: formatter.separator), file: file, function: function, line: line, column: column)
        logTag = originalLogTag
    }
    
    public func verbose(tag: String, _ items: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        let originalLogTag = logTag
        logTag = tag
        verbose(items.map { "\($0)" }.joined(separator: formatter.separator), file: file, function: function, line: line, column: column)
        logTag = originalLogTag
    }
    
    public func log(tag: String, _ items: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        let originalLogTag = logTag
        logTag = tag
        log(items.map { "\($0)" }.joined(separator: formatter.separator), file: file, function: function, line: line, column: column)
        logTag = originalLogTag
    }

    public func request(tag: String, _ method: String, _ url: String, _ parameters: String? = nil, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        let originalLogTag = logTag
        logTag = tag
        request(method, url, parameters, file: file, function: function, line: line, column: column)
        logTag = originalLogTag
    }
    
    public func response(tag: String, _ method: String, _ url: String, _ parameters: String? = nil, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        let originalLogTag = logTag
        logTag = tag
        response(method, url, parameters, file: file, function: function, line: line, column: column)
        logTag = originalLogTag
    }
    
}

public class PapertrailLogger : NSObject {
    fileprivate var _tcpSocket: GCDAsyncSocket!
    
    lazy private var _dateFormat:DateFormatter = {
        let fm = DateFormatter()
        fm.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return fm
    }()
    
    private var _firstLaunch = true
    
    public static let `default` = PapertrailLogger()
    
    override private init() {
        super.init()
    }
    
    private(set) public var host: String = ""
    private(set) public var port: UInt16 = 0
    fileprivate var _connecting = false
    public var logger: Lithium.Logger!
    public var programName: String?
    
    public var shouldColorizePrefixTags = true
    
    fileprivate func setup(logger: Lithium.Logger, host:String, port:UInt16) {
         _tcpSocket = GCDAsyncSocket(delegate: self,
                                     delegateQueue: DispatchQueue(label: "com.esites.library.lithium.papertrail.delegate"),
                                     socketQueue: DispatchQueue(label: "com.esites.library.lithium.papertrail.socket"))
        self.host = host
        self.logger = logger
        self.port = port
        
        _connectTCPSocket()
        
        NotificationCenter.default.addObserver(self, selector: #selector(_appBecomesActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_appEntersBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc private func _appBecomesActive() {
        logger.info(tag: "application", "Application did become active")
    }
    
    @objc private func _appEntersBackground() {
        logger.info(tag: "application", "Application did enter background")
    }
    
    
    private func _connectTCPSocket() {
        do {
            try _tcpSocket.connect(toHost: host, onPort:port, withTimeout: -1)
            _connecting = true
        } catch {
//            print("Error connecting to tcp socket: \(error)")
        }
    }
    
    public func log(_ msg:String, level: LogLevel, style: LogStyle? = nil, theme: LogTheme? = nil) {
        if host == "" || port == 0 {
            return
        }
        if _firstLaunch {
            _firstLaunch = false
            logTag = "launch"
            log("[ INF ] ==================================================", level: .info)
            log("[ INF ]  - Device name: \(UIDevice.current.name)", level: .info)
            log("[ INF ]  - Device: \(Device.platform)", level: .info)
            log("[ INF ]  - iOS: \(UIDevice.current.systemVersion)", level: .info)
            log("[ INF ]  - App version: \(Bundle.main.version) (build \(Bundle.main.build))", level: .info)
            log("[ INF ] ==================================================", level: .info)
            logTag = nil
        }
        
        let senderName = Bundle.main.bundleIdentifier ?? "com.esites.unknown"
        let date = _dateFormat.string(from: Date())
        var lTag = logTag ?? "default"
        if msg.hasPrefix("[ DEALLOC ]") {
            lTag = "dealloc"
        }
        let o = "\u{00A0}" * max(1, (16 - lTag.count))
        let tag = _wrap(text: "\(lTag) »", inColor: "1;36") + o
        
        let programName = self.programName ?? "anonymous"
        
        if !_tcpSocket.isConnected {
            if _connecting {
                return
            }
            self._connectTCPSocket()
        }

        let logLines = msg.components(separatedBy: "\n")
        for ll in logLines {
            var msg = ll
            if msg.hasPrefix("[ REQ ]") && shouldColorizePrefixTags {
                msg = _wrap(text: msg, inColor: "36")
                
            } else if msg.hasPrefix("[ RES ]") && shouldColorizePrefixTags {
                msg = _wrap(text: msg, inColor: "35")
                
            } else {
                switch level {
                case .error:
                    msg = _wrap(text: msg, inColor: "31")
                case .warning:
                    msg = _wrap(text: msg, inColor: "33")
                default:
                    if theme?.successStyle.prefixText == style?.prefixText {
                        msg = _wrap(text: msg, inColor: "32")
                    }
                }
            }
            
            let line = "<22>1 \(date) ios:\(senderName) \(programName) - - - \(tag)\(ll)\n"
            guard let data = line.data(using: .utf8) else {
                continue
            }

            _tcpSocket.write(data, withTimeout: -1, tag: 1)
        }
    }
    
    private func _wrap(text: String, inColor colorCode:String) -> String {
        let escape = "\u{001B}["
        return "\(escape)\(colorCode)m\(text)\(escape)0m"
    }
}

extension PapertrailLogger : GCDAsyncSocketDelegate {
    

    public func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
//        print("didConnectToHost: \(host)")
        _connecting = false
    }

    public func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
//        print("socketDidDisconnect")
        _connecting = false
    }

    public func socket(_ sock: GCDAsyncSocket, didConnectTo url: URL) {
//        print("didConnectTo: \(url)")
        _connecting = false
    }

    public func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
//        print("didAcceptNewSocket: \(newSocket)")
        _tcpSocket = newSocket
    }
}
