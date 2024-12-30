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
}
