//
//  AppLogger.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import Foundation
import OSLog

// MARK: - App Logger
// Simple and thread-safe logging utility for the app
struct AppLogger: LoggingService {
    
    // MARK: - LoggingService Implementation
    func log(_ message: String, category: LogCategory, level: LogLevel) {
        let timestamp = DateFormatter.logFormatter.string(from: Date())
        let logMessage = "\(timestamp) \(category.emoji) [\(category.rawValue)] \(level.prefix) \(message)"
        
        // Console output
        print(logMessage)
        
        // OSLog for system logging (only in debug builds)
        #if DEBUG
        let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "ArticApp", category: category.rawValue)
        
        switch level {
        case .debug:
            logger.debug("\(message)")
        case .info:
            logger.info("\(message)")
        case .warning:
            logger.warning("\(message)")
        case .error:
            logger.error("\(message)")
        }
        #endif
    }
    
    func debug(_ message: String, category: LogCategory) {
        log(message, category: category, level: .debug)
    }
    
    func info(_ message: String, category: LogCategory) {
        log(message, category: category, level: .info)
    }
    
    func warning(_ message: String, category: LogCategory) {
        log(message, category: category, level: .warning)
    }
    
    func error(_ message: String, category: LogCategory) {
        log(message, category: category, level: .error)
    }
    
}

// MARK: - DateFormatter Extension
extension DateFormatter {
    static let logFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
}
