//
//  Camera1ViewModel.swift
//  Splash KAB
//
//  Created by Shamam Alkafri on 30/12/2024.
//

import SwiftUI
import AVFoundation
import Vision
import UIKit

class Camera1ViewModel: ObservableObject {
    var onFrameCaptured: ((CGImage) -> Void)?
    private var session: AVCaptureSession?

    func startSession(onFrame: @escaping (CGImage) -> Void) {
        onFrameCaptured = onFrame
    }

    func stopSession() {
        session?.stopRunning()
    }

    func processFrame(pixelBuffer: CVPixelBuffer) {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()

        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            DispatchQueue.main.async {
                print("Captured Image: \(cgImage)") 
                self.onFrameCaptured?(cgImage)
            }
        }
    }
}
