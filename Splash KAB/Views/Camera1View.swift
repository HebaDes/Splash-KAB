//
//  Camera1View.swift
//  Splash KAB
//
//  Created by Shamam Alkafri on 30/12/2024.
//

import SwiftUI
import AVFoundation
import Vision
import UIKit


// MARK: - cameraview
struct Camera1View: UIViewControllerRepresentable {
    @ObservedObject var cameraModel: Camera1ViewModel

    func makeUIViewController(context: Context) -> Camera1ViewController {
        let controller = Camera1ViewController()
        controller.cameraModel = cameraModel
        return controller
    }

    func updateUIViewController(_ uiViewController: Camera1ViewController, context: Context) {}
}


// MARK: - controller
class Camera1ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var cameraModel: Camera1ViewModel?
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo

        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoInput) else {
            print("Failed to access the camera.")
            return
        }
        captureSession.addInput(videoInput)

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        guard captureSession.canAddOutput(videoOutput) else { return }
        captureSession.addOutput(videoOutput)

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    
    // MARK: - capture
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()

        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            DispatchQueue.main.async {
                self.cameraModel?.onFrameCaptured?(cgImage)
            }
        }
    }
}
