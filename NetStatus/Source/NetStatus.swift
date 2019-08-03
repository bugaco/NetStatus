//
//  NetStatus.swift
//  NetStatus
//
//  Created by 李懿哲 on 2019/8/2.
//  Copyright © 2019 zanyzephyr. All rights reserved.
//
public typealias Closure = () -> Void

import Foundation
import Network

public class NetStatus {
    public static let shared = NetStatus()
    
    private init() {
        
    }
    deinit {
        stopMonitor()
    }
    
    public var monitor: NWPathMonitor?
    public var isMonitoring = false
    
    public var didStartMonitoringHandler: Closure?
    public var didStopMonitoringHandler: Closure?
    public var netStatusChangeHandler: Closure?
    public var isConnected: Bool {
        guard let monitor = monitor else {
            return false
        }
        return monitor.currentPath.status == .satisfied
    }
    
    public func startMonitoring() {
        guard !isMonitoring else {
            return
        }
        
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetStatus_Monitor")
        monitor?.start(queue: queue)
        monitor?.pathUpdateHandler = { _ in
            self.netStatusChangeHandler?()
        }
        isMonitoring = true
        didStartMonitoringHandler?()
    }
    
    public func stopMonitor() {
        guard isMonitoring, let monitor = monitor else {
            return
        }
        monitor.cancel()
        self.monitor = nil
        isMonitoring = false
        didStopMonitoringHandler?()
    }
}
