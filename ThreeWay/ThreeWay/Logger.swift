//
//  Logger.swift
//  RemoteCast
//
//  Created by Phaninder Kumar on 20/02/21.
//

import Cocoa
import os.log

// lowest to production log level
enum LogLevel {
    case debug
    case info
    case warn
    case error
    case none
}

struct LogConfig {
    #if DEBUG
    static let consoleLoggingEnabled: LogLevel = .debug
    #else
    static let consoleLoggingEnabled: LogLevel = .debug
    #endif
}

class Logger {

    var logFileName = "logs-\(Date().getLocalStringLogFile()).log"

    func info(_ value: Any) {
        if let stringValue = value as? String {
            os_log("[🔷 Info]  %{public}@", log: OSLog.viewCycle, type: .info, stringValue)
        }
    }

    func debug(_ value: Any) {
        if let stringValue = value as? String {
            os_log("[🚀 Debug] %{public}@", log: OSLog.viewCycle, type: .debug, stringValue)
        }
    }

    func error(_ value: Any) {
        if let stringValue = value as? String {
            os_log("[❌ Error] %{public}@", log: OSLog.viewCycle, type: .error, stringValue)
        }
    }

    func warn(_ value: Any) {
        if let stringValue = value as? String {
            os_log("[🔶 Warn] %{public}@", log: OSLog.viewCycle, type: .fault, stringValue)
        }
    }

}

var logger = Logger()
