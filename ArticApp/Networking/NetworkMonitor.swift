//
//  NetworkMonitor.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import Network
import Combine

// MARK: - Network Monitoring Service
// Added network connectivity monitoring for offline queue functionality
final class NetworkMonitor: ObservableObject, NetworkMonitorService {
    @Published private(set) var isConnected = true
    
    var connectionPublisher: AnyPublisher<Bool, Never> {
        $isConnected.eraseToAnyPublisher()
    }
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private let loggingService: LoggingService

    init(loggingService: LoggingService = AppLogger()) {
        self.loggingService = loggingService
        startMonitoring()
    }
    
    deinit {
        monitor.cancel()
    }
    
    private func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let wasConnected = self.isConnected
                self.isConnected = path.status == .satisfied
                
                if wasConnected != self.isConnected {
                    self.loggingService.info("Network status changed: \(self.isConnected ? "Connected" : "Disconnected")", category: .network)
                }
            }
        }
    }
}
