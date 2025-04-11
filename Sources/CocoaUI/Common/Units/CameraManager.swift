//
//  File.swift
//  
//
//  Created by nenhall on 4/11/25.
//

import Foundation
import AVFoundation
import Combine

public class CameraManager: ObservableObject {
    public static let shared = CameraManager.init()
    
    @Published public var connectedMobleDevice: Bool = false
    private lazy var discoverySession: AVCaptureDevice.DiscoverySession = {
        AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .externalUnknown],
            mediaType: .video,
            position: .unspecified
        )
    }()
    
    private init() {
        updateDevices()
        setupNotifications()
    }
    
    private func setupDiscoverySession() {
        
    }
    
    public func updateDevices() {
        discoverySession.devices.forEach { device in
            let modelID = device.modelID
            debugPrint("设备名称: \(device.localizedName), 唯一ID: \(device.uniqueID), 类型: \(modelID), 位置: \(positionDescription(device.position))")
            if modelID.hasPrefix("iPhone") {
                connectedMobleDevice = true
                return
            } else if modelID.hasPrefix("iPad") {
                connectedMobleDevice = true
                return
            } else if modelID.hasPrefix("iPod") {
                connectedMobleDevice = true
                return
            } else {
                connectedMobleDevice = false
            }
        }
    }
    
    private func positionDescription(_ position: AVCaptureDevice.Position) -> String {
        switch position {
        case .front: return "前置"
        case .back: return "后置"
        default: return "未知"
        }
    }
    
    private func setupNotifications() {
        [NSNotification.Name.AVCaptureDeviceWasConnected, .AVCaptureDeviceWasDisconnected].forEach {
             NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleDeviceChange),
                name: $0,
                object: nil
             )
         }
    }
    
    @objc private func handleDeviceChange(_ notification: Notification) {
        debugPrint("设备状态变化，当前可用 \(discoverySession.devices.count) 个设备")
        updateDevices()
    }
}
