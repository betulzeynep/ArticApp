//
//  CacheService.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import Foundation

protocol CacheService {
    func save<T: Codable>(_ value: T, for key: String) async throws
    func load<T: Codable>(_ type: T.Type, for key: String, maxAge: TimeInterval) async throws -> T?
    func remove(for key: String) async throws
    func clear() async throws
}
