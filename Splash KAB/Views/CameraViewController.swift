//
//  CameraViewController.swift
//  Splash KAB
//
//  Created by Shamam Alkafri on 30/12/2024.
//

import SwiftUI
import AVFoundation
import Foundation
import Vision
import UIKit

class CameraViewController: UIViewController {
    var cameraModel: CameraModel?
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var speechSynthesizer = AVSpeechSynthesizer()
    private var lastInstructionTime: Date?
    private var visualFeedbackLayer: CAShapeLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupVisualFeedback()
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    private func setupVisualFeedback() {
        visualFeedbackLayer = CAShapeLayer()
        visualFeedbackLayer.strokeColor = UIColor.green.cgColor
        visualFeedbackLayer.lineWidth = 4.0
        visualFeedbackLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(visualFeedbackLayer)
    }

    private func drawVisualFeedback(for boundingBox: CGRect) {
        let frameWidth = view.frame.width
        let frameHeight = view.frame.height

        let boxX = boundingBox.minX * frameWidth
        let boxY = (1 - boundingBox.maxY) * frameHeight
        let boxWidth = boundingBox.width * frameWidth
        let boxHeight = boundingBox.height * frameHeight

        let boxRect = CGRect(x: boxX, y: boxY, width: boxWidth, height: boxHeight)

        DispatchQueue.main.async {
            self.visualFeedbackLayer.path = UIBezierPath(rect: boxRect).cgPath
        }
    }

    private func clearVisualFeedback() {
        DispatchQueue.main.async {
            self.visualFeedbackLayer.path = nil
        }
    }

    private func speakMessage(_ message: String) {
        if let lastTime = lastInstructionTime, Date().timeIntervalSince(lastTime) < 3 {
            return
        }

        lastInstructionTime = Date()
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(utterance)
    }

    private func handleDetectedBox(boundingBox: CGRect) {
        let frameWidth = view.frame.width
        let frameHeight = view.frame.height

        let boxMinX = boundingBox.minX * frameWidth
        let boxMaxX = boundingBox.maxX * frameWidth
        let boxMinY = (1 - boundingBox.maxY) * frameHeight
        let boxMaxY = (1 - boundingBox.minY) * frameHeight

        let boxWidth = boxMaxX - boxMinX
        let boxHeight = boxMaxY - boxMinY

        let screenWidth = frameWidth
        let screenHeight = frameHeight

        var needsGuidance = false

        if boxMinX < 0 {
            speakMessage("Move right")
            needsGuidance = true
        } else if boxMaxX > screenWidth {
            speakMessage("Move left")
            needsGuidance = true
        }

        if boxMinY < 0 {
            speakMessage("Move down")
            needsGuidance = true
        } else if boxMaxY > screenHeight {
            speakMessage("Move up")
            needsGuidance = true
        }

        if boxWidth < frameWidth * 0.2 {
            speakMessage("Move the box closer")
            needsGuidance = true
        } else if boxWidth > frameWidth * 0.8 {
            speakMessage("Move the box further away")
            needsGuidance = true
        }

        if !needsGuidance && boxWidth > frameWidth * 0.2 && boxHeight > frameHeight * 0.2 {
            speakMessage("Box fully detected")
        }

        drawVisualFeedback(for: boundingBox)
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])

        let request = VNDetectRectanglesRequest { (request, error) in
            guard let results = request.results as? [VNRectangleObservation], !results.isEmpty else {
                self.speakMessage("No box detected")
                self.clearVisualFeedback()
                return
            }

            if let largestBox = results.max(by: { $0.boundingBox.width * $0.boundingBox.height < $1.boundingBox.width * $1.boundingBox.height }) {
                self.handleDetectedBox(boundingBox: largestBox.boundingBox)
            }
        }

        request.minimumAspectRatio = 0.5
        request.maximumAspectRatio = 2.0
        request.minimumSize = 0.2
        request.maximumObservations = 5
        request.minimumConfidence = 0.5

        do {
            try requestHandler.perform([request])
        } catch {
            print("Failed to perform Vision request: \(error)")
        }
    }
}
