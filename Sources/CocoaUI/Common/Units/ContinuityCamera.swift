//
//  File.swift
//  
//
//  Created by nenhall on 4/10/25.
//

import Foundation
import AVFoundation
//import AppKit  替换UIKit为AppKit

class ContinuityCamera: NSObject {
    // MARK: - 属性
    private var captureSession: AVCaptureSession?
    private var videoDevice: AVCaptureDevice?
    private var audioDevice: AVCaptureDevice?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var isCenterStageEnabled = false
    
    // MARK: - 初始化
     public override init() {
        super.init()
        setupDeviceDiscovery()
    }
    
    // MARK: - 设备发现与连接
    private func setupDeviceDiscovery() {
        // 视频设备发现会话（包含外接设备）
//        let videoDiscoverySession = AVCaptureDevice.DiscoverySession(
//            deviceTypes: [.builtInWideAngleCamera, .externalUnknown],
//            mediaType: .video,
//            position: .unspecified
//        )
        
        // 监听设备连接
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deviceConnected(_:)),
            name: .AVCaptureDeviceWasConnected,
            object: nil
        )
        
        // 监听设备断开
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deviceDisconnected(_:)),
            name: .AVCaptureDeviceWasDisconnected,
            object: nil
        )
    }
    
    // MARK: - 会话配置
//    public func configureSession(with previewView: UIView) { // 修改参数类型为NSView
//        captureSession = AVCaptureSession()
//        
//        // 获取首选设备
//        if #available(macOS 13.0, *) {
////            videoDevice = AVCaptureDevice.systemPreferredCamera
////            audioDevice = AVCaptureDevice.default(.builtInMicrophone, for: .audio, position: .unspecified)
//        } else {
//            // Fallback on earlier versions
//        }
//        
//        guard let videoDevice = videoDevice
//                , let audioDevice = audioDevice
//        else { return }
//        
//        do {
//            captureSession?.beginConfiguration()
//            
//            // 添加视频输入
//            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
//            captureSession?.addInput(videoInput)
//            
//            // 添加音频输入
//            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
//            captureSession?.addInput(audioInput)
//            
//            // 配置预览层
////            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
////            previewLayer?.frame = previewView.bounds
////            previewView.layer?.addSublayer(previewLayer!) // 使用NSView的layer属性
//            
//            captureSession?.commitConfiguration()
//            captureSession?.startRunning()
//        } catch {
//            print("会话配置失败: \(error.localizedDescription)")
//        }
//    }
    
    // MARK: - 特效控制
    public func toggleCenterStage(_ enabled: Bool) {
        guard let device = videoDevice else { return }
        
        do {
            try device.lockForConfiguration()
            if #available(macOS 12.3, iOS 14.5, *) {
                AVCaptureDevice.isCenterStageEnabled = enabled
            }
            device.unlockForConfiguration()
            isCenterStageEnabled = enabled
        } catch {
            print("切换中心舞台失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 设备事件处理
    @objc private func deviceConnected(_ notification: Notification) {
        guard let device = notification.object as? AVCaptureDevice,
              device.hasMediaType(.video) else { return }
        
        print("设备已连接: \(device.localizedName)")
        updatePreferredCamera()
    }
    
    @objc private func deviceDisconnected(_ notification: Notification) {
        guard let device = notification.object as? AVCaptureDevice,
              device.hasMediaType(.video) else { return }
        
        print("设备已断开: \(device.localizedName)")
        updatePreferredCamera()
    }
    
    private func updatePreferredCamera() {
        if #available(macOS 13.0, iOS 17.0, *) {
            videoDevice = AVCaptureDevice.systemPreferredCamera
        } else {
            // Fallback on earlier versions
        }
        // 此处可添加重新配置会话的逻辑
    }
    
    // MARK: - 清理
    deinit {
        NotificationCenter.default.removeObserver(self)
        captureSession?.stopRunning()
    }
}

// MARK: - 使用示例
/*
let cameraManager = ContinuityCameraManager()
// 在macOS中，通常通过Interface Builder连接视图
// 或在代码中创建NSView实例后传入
let previewView = NSView(frame: NSRect(x: 0, y: 0, width: 640, height: 480))
cameraManager.configureSession(with: previewView)

// 切换中心舞台
cameraManager.toggleCenterStage(true)
*/
