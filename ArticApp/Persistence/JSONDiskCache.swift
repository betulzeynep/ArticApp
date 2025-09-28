//
//  JSONDiskCache.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import Foundation
import OSLog

actor JSONDiskCache: CacheService {
    let folderURL: URL
    let fileManager = FileManager.default
    private let loggingService: LoggingService

    init(name: String = "ArticCache", loggingService: LoggingService = AppLogger()) throws {
        self.loggingService = loggingService
        let caches = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        folderURL = caches.appendingPathComponent(name, isDirectory: true)
        if !fileManager.fileExists(atPath: folderURL.path) {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
        }
    }

    func save<T: Codable>(_ value: T, for key: String) async throws {
        let url = fileURL(for: key)
        let wrapper = CacheWrapper(timestamp: Date(), payload: value)
        let data = try JSONEncoder().encode(wrapper)
        try data.write(to: url, options: .atomic)
        loggingService.info("Data saved to cache: \(url.lastPathComponent)", category: .cache)
    }

    func load<T: Codable>(_ type: T.Type, for key: String, maxAge: TimeInterval) async throws -> T? {
        let url = fileURL(for: key)
        guard fileManager.fileExists(atPath: url.path) else { return nil }
        let data = try Data(contentsOf: url)
        let wrapper = try JSONDecoder().decode(CacheWrapper<T>.self, from: data)
        loggingService.info("Data loaded from cache: \(url.lastPathComponent)", category: .cache)
        if Date().timeIntervalSince(wrapper.timestamp) > maxAge {
            try? fileManager.removeItem(at: url)
            return nil
        }
        return wrapper.payload
    }
    
    func remove(for key: String) async throws {
        let url = fileURL(for: key)
        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
            await loggingService.info("Removed cache item: \(url.lastPathComponent)", category: .cache)
        }
    }
    
    func clear() async throws {
        let contents = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
        for url in contents {
            try fileManager.removeItem(at: url)
        }
        await loggingService.info("Cleared all cache", category: .cache)
    }

    private func fileURL(for key: String) -> URL {
        let safe = key.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "\(key.hashValue)"
        return folderURL.appendingPathComponent(safe).appendingPathExtension("json")
    }

    private struct CacheWrapper<T: Codable>: Codable {
        let timestamp: Date
        let payload: T
    }
}
