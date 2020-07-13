//
//  LithiumLogger.swift
//  Lithium
//
//  Created by Bas van Kuijck on 10/07/2020.
//  Copyright © 2020 E-sites. All rights reserved.
//

import Foundation
import Logging

@available(OSX 10.12, *)
@available(iOS 10.0, *)
@available(tvOS 10.0, *)
@available(watchOS 3.0, *)
public struct LithiumLogger: LogHandler {
    public var logLevel: Logger.Level = .trace
    public var theme: LogTheme = DefaultLogTheme()
    public let label: String

    public init(label: String) {
        self.label = label
    }

    public func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, file: String, function: String, line: UInt) {
        if level < logLevel {
            return
        }

        var metadata = metadata
        var logMessage = message.description
        var style = theme.noticeStyle

        switch level {
        case .critical:
            style = theme.criticalStyle
        case .error:
            style = theme.errorStyle
        case .debug:
            style = theme.debugStyle
        case .info:
            style = theme.infoStyle
        case .notice:
            style = theme.noticeStyle
        case .warning:
            style = theme.warningStyle
        case .trace:
            style = theme.traceStyle
            if metadata?["tag"] == "api" {
                if logMessage.starts(with: "[REQ] ") {
                    metadata?.removeValue(forKey: "tag")
                    style = theme.requestStyle
                    logMessage = logMessage.replacingOccurrences(of: "[REQ] ", with: "")
                } else if logMessage.starts(with: "[RES] ") {
                    metadata?.removeValue(forKey: "tag")
                    style = theme.responseStyle
                    logMessage = logMessage.replacingOccurrences(of: "[RES] ", with: "")
                }
            } else if metadata?["tag"] == "dealloc" {
                if let metadataValue = metadata?["_prefixText"],
                    case let Logger.MetadataValue.string(prefixText) = metadataValue {
                    style = LogStyle()
                    style.prefixText = prefixText
                }
                metadata?.removeValue(forKey: "_prefixText")
                metadata?.removeValue(forKey: "tag")
            }
        }

        var metadataString: String?
        if let strongMetadata = metadata, let metadataStringTmp = prettify(strongMetadata) {
            metadataString = metadataStringTmp
        }
        let context = LogContext(thread: Thread.current, file: file, function: function, line: line)
        print(theme.formatter.parse(style: style, message: logMessage, context: context, metadata: metadataString))
    }

    private var prettyMetadata: String?
    public var metadata = Logger.Metadata() {
        didSet {
            self.prettyMetadata = self.prettify(self.metadata)
        }
    }

    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return self.metadata[metadataKey]
        }
        set {
            self.metadata[metadataKey] = newValue
        }
    }

    private func prettify(_ metadata: Logger.Metadata) -> String? {
        if metadata.isEmpty {
            return nil
        }
        return metadata.map { "\($0)=\($1)" }.joined(separator: " ")
    }
}
