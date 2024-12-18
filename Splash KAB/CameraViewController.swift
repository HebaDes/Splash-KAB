import UIKit
import AVFoundation
import Vision

class CameraViewController: UIViewController {
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var speechSynthesizer = AVSpeechSynthesizer()
    private var lastInstructionTime: Date?
    private var visualFeedbackLayer: CAShapeLayer! // Visual feedback

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupVisualFeedback() //  visual feedback
    }

    /// Sets up the camera feed
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

    /// Sets up the visual feedback layer
    private func setupVisualFeedback() {
        visualFeedbackLayer = CAShapeLayer()
        visualFeedbackLayer.strokeColor = UIColor.green.cgColor
        visualFeedbackLayer.lineWidth = 4.0
        visualFeedbackLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(visualFeedbackLayer)
    }

    /// Draws a rectangle for the detected box
    private func drawVisualFeedback(for boundingBox: CGRect) {
        let frameWidth = view.frame.width
        let frameHeight = view.frame.height

        // Scale the detected bounding box to the screen size
        let boxX = boundingBox.minX * frameWidth
        let boxY = (1 - boundingBox.maxY) * frameHeight // Flip Y-axis
        let boxWidth = boundingBox.width * frameWidth
        let boxHeight = boundingBox.height * frameHeight

        let boxRect = CGRect(x: boxX, y: boxY, width: boxWidth, height: boxHeight)

        DispatchQueue.main.async {
            self.visualFeedbackLayer.path = UIBezierPath(rect: boxRect).cgPath
        }
    }

    /// Clears the visual feedback from the screen
    private func clearVisualFeedback() {
        DispatchQueue.main.async {
            self.visualFeedbackLayer.path = nil
        }
    }

    /// Speaks a message to guide the user
    private func speakMessage(_ message: String) {
        if let lastTime = lastInstructionTime, Date().timeIntervalSince(lastTime) < 3 {
            return // Avoid speaking too frequently
        }

        lastInstructionTime = Date()
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(utterance)
    }

    /// Handles detected box's position and guides the user
    private func handleDetectedBox(boundingBox: CGRect) {
        let frameWidth = view.frame.width
        let frameHeight = view.frame.height

        // Get the edges of the detected box
        let boxMinX = boundingBox.minX * frameWidth
        let boxMaxX = boundingBox.maxX * frameWidth
        let boxMinY = (1 - boundingBox.maxY) * frameHeight // Flip Y-axis
        let boxMaxY = (1 - boundingBox.minY) * frameHeight // Flip Y-axis

        let boxWidth = boxMaxX - boxMinX
        let boxHeight = boxMaxY - boxMinY

        let screenWidth = frameWidth
        let screenHeight = frameHeight

        var needsGuidance = false

        // Check if parts of the box are outside the screen, and provide guidance to the user
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

        // Check if the box is too close or too far
        if boxWidth < frameWidth * 0.2 {
            speakMessage("Move the box closer")
            needsGuidance = true
        } else if boxWidth > frameWidth * 0.8 {
            speakMessage("Move the box further away")
            needsGuidance = true
        }

        // If the box is within the screen and fully detected, give feedback
        if !needsGuidance && boxWidth > frameWidth * 0.2 && boxHeight > frameHeight * 0.2 {
            speakMessage("Box fully detected")
        }

        // Draw visual feedback for the detected box
        drawVisualFeedback(for: boundingBox)
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    /// Processes each frame from the camera to detect a box
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])

        let request = VNDetectRectanglesRequest { (request, error) in
            guard let results = request.results as? [VNRectangleObservation], !results.isEmpty else {
                self.speakMessage("No box detected")
                self.clearVisualFeedback()
                print("No box detected")  // Debugging print statement
                return
            }

            // Get the largest box by area
            if let largestBox = results.max(by: { $0.boundingBox.width * $0.boundingBox.height < $1.boundingBox.width * $1.boundingBox.height }) {
                print("Box detected with bounding box: \(largestBox.boundingBox)")  // Debugging print statement
                self.handleDetectedBox(boundingBox: largestBox.boundingBox)
            }
        }

        // Adjust the rectangle detection parameters
        request.minimumAspectRatio = 0.5  // Allow more flexibility
        request.maximumAspectRatio = 2.0  // Allow more flexibility
        request.minimumSize = 0.2  // 20% size of the screen
        request.maximumObservations = 5  // Allow more than 1 box
        request.minimumConfidence = 0.5  // Lower confidence threshold

        do {
            try requestHandler.perform([request])
        } catch {
            print("Failed to perform Vision request: \(error)")
        }
    }
}


