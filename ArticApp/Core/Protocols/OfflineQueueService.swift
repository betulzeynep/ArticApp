//
//  OfflineQueueService.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import Foundation

protocol OfflineQueueService {
    func enqueue(artist: String, page: Int) async
    func processPendingRequests(with networkService: NetworkService) async
    var queueStatus: (count: Int, isEmpty: Bool) { get async }
    func clearQueue() async
}
