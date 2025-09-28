//
//  LoggingService.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import Foundation

protocol LoggingService {
    func log(_ message: String, category: LogCategory, level: LogLevel)
    func debug(_ message: String, category: LogCategory)
    func info(_ message: String, category: LogCategory)
    func warning(_ message: String, category: LogCategory)
    func error(_ message: String, category: LogCategory)
}

enum LogCategory: String, CaseIterable {
    case api = "API"
    case cache = "Cache"
    case network = "Network"
    case offline = "OfflineQueue"
    case ui = "UI"
    case general = "General"
    
    var emoji: String {
        switch self {
        case .api: return "🌐"
        case .cache: return "💾"
        case .network: return "📡"
        case .offline: return "📱"
        case .ui: return "🎨"
        case .general: return "📝"
        }
    }
}

enum LogLevel {
    case debug
    case info
    case warning
    case error
    
    var prefix: String {
        switch self {
        case .debug: return "🔍"
        case .info: return "ℹ️"
        case .warning: return "⚠️"
        case .error: return "❌"
        }
    }
}
