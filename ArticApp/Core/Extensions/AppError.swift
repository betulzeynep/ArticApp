//
//  AppError.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import Foundation

enum AppError: Error, LocalizedError {
    case networkUnavailable
    case invalidData
    case cacheError(String)
    case offlineQueueFull
    case decodingError(String)
    case serverError(Int)
    case invalidURL
    case transport(Error)
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "No internet connection available"
        case .invalidData:
            return "Invalid data received from server"
        case .cacheError(let message):
            return "Cache operation failed: \(message)"
        case .offlineQueueFull:
            return "Offline queue is full. Please try again later."
        case .decodingError(let message):
            return "Data parsing error: \(message)"
        case .serverError(let code):
            return "Server error: \(code)"
        case .invalidURL:
            return "Invalid URL"
        case .transport(let e):
            return "Network error: \(e.localizedDescription)"
        case .unknown(let message):
            return "Unknown error: \(message)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkUnavailable:
            return "Check your internet connection and try again."
        case .invalidData, .decodingError:
            return "Try refreshing the data."
        case .cacheError:
            return "Clear app cache and try again."
        case .offlineQueueFull:
            return "Wait for pending requests to complete."
        case .serverError:
            return "The server is experiencing issues. Please try again later."
        case .invalidURL:
            return "Contact support if this issue persists."
        case .transport:
            return "Check your network and please try again"
        case .unknown:
            return "Please try again or contact support."
        }
    }
}
