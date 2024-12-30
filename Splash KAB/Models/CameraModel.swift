//
//  CameraModel.swift
//  Splash KAB
//
//  Created by Shamam Alkafri on 30/12/2024.
//

import SwiftUI
import AVFoundation
import Foundation
import Vision
import UIKit

class CameraModel: NSObject, ObservableObject {
    var onFrameCaptured: ((CGImage) -> Void)?
    private var captureSession: AVCaptureSession?

    func startSession(onFrame: @escaping (CGImage) -> Void) {
        onFrameCaptured = onFrame
        setupCamera()
    }

    func stopSession() {
        captureSession?.stopRunning()
        captureSession = nil
    }

    private func setupCamera() {
        let session = AVCaptureSession()
        session.sessionPreset = .photo

        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              session.canAddInput(videoInput) else { return }
        session.addInput(videoInput)

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        guard session.canAddOutput(videoOutput) else { return }
        session.addOutput(videoOutput)

        self.captureSession = session
        session.startRunning()
    }
}


extension CameraModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()

        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            DispatchQueue.main.async {
                self.onFrameCaptured?(cgImage)
            }
        }
    }
}

