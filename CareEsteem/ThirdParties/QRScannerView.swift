//
//  QRScannerView.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 10/03/25.
//


import UIKit
import AVFoundation

class QRScannerView: UIView, AVCaptureMetadataOutputObjectsDelegate {
    
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    var onQRCodeScanned: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScanner()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupScanner()
    }

    private func setupScanner() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to access camera")
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession!.canAddInput(videoInput) {
                captureSession!.addInput(videoInput)
            } else {
                print("Could not add camera input")
                return
            }
        } catch {
            print("Error setting up video input: \(error)")
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession!.canAddOutput(metadataOutput) {
            captureSession!.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr] // Only detect QR codes
        } else {
            print("Could not add metadata output")
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = self.layer.bounds
        self.layer.addSublayer(previewLayer!)
        
        DispatchQueue.main.async { [weak self] in
            self?.captureSession!.startRunning()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = self.bounds
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let scannedString = metadataObject.stringValue else { return }
        
        onQRCodeScanned?(scannedString)
        
        captureSession?.stopRunning() // Stop scanning after detecting a QR code
    }
    
    func startScanning() {
        if !(captureSession?.isRunning ?? false) {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession?.startRunning()
            }
        }
    }

    func stopScanning() {
        if captureSession?.isRunning ?? false {
            captureSession?.stopRunning()
        }
    }
}
