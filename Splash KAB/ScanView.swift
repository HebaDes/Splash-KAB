import SwiftUI
import AVFoundation
import CoreML
import Vision

struct ScanView: View {
    @StateObject private var cameraModel = Camera1ViewModel()
    @State private var prediction: String = "Scanning..."
    @State private var detectedObject: String = ""
    @State private var showSheet: Bool = false // State to manage sheet visibility

    var body: some View {
        ZStack {
            Camera1View(cameraModel: cameraModel)
            VStack {
                Spacer()
                // Display the detected object's name or scanning status
                Text(prediction)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.bottom, 20)
            }
        }
        .onAppear {
            cameraModel.startSession { image in
                classifyImage(image: image)
            }
            cameraModel.toggleFlash(on: true) // Turn flashlight ON
        }
        .onDisappear {
            cameraModel.stopSession()
            cameraModel.toggleFlash(on: false) // Turn flashlight OFF
        }
        .sheet(isPresented: $showSheet) {
            DetectedObjectSheet(objectName: detectedObject)
        }
    }
    
    private func classifyImage(image: CGImage) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let model = try? VNCoreMLModel(for: KabsolaApp().model) else {
                print("Failed to load CoreML model.")
                return
            }
            
            let request = VNCoreMLRequest(model: model) { request, error in
                if let results = request.results as? [VNClassificationObservation],
                   let topResult = results.first {
                    DispatchQueue.main.async {
                        let confidence = topResult.confidence * 100
                        if confidence >= 99 {
                            detectedObject = topResult.identifier
                            prediction = "Detected: \(detectedObject) (\(Int(confidence))%)"
                            showSheet = true // Show the sheet
                        } else if confidence >= 70 {
                            prediction = "Scanning... Please wait (\(Int(confidence))%)"
                        } else {
                            prediction = "Object is too far away (\(Int(confidence))%)"
                        }
                    }
                }
            }
            
            let handler = VNImageRequestHandler(cgImage: image, options: [:])
            try? handler.perform([request])
        }
    }
}

struct DetectedObjectSheet: View {
    let objectName: String

    var body: some View {
        VStack {
            Text("Object Detected")
                .font(.largeTitle)
                .padding()
            Text("You detected: \(objectName)")
                .font(.title2)
                .padding()
            Button("Dismiss") {
                // Add any additional functionality here
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

struct Camera1View: UIViewControllerRepresentable {
    @ObservedObject var cameraModel: Camera1ViewModel
    
    func makeUIViewController(context: Context) -> Camera1ViewController {
        let controller = Camera1ViewController()
        controller.cameraModel = cameraModel
        return controller
    }
    
    func updateUIViewController(_ uiViewController: Camera1ViewController, context: Context) {}
}

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
            print("Failed to access camera.")
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

class Camera1ViewModel: ObservableObject {
    var onFrameCaptured: ((CGImage) -> Void)?
    private var session: AVCaptureSession?
    
    func startSession(onFrame: @escaping (CGImage) -> Void) {
        onFrameCaptured = onFrame
    }
    
    func stopSession() {
        session?.stopRunning()
    }
    
    func toggleFlash(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        } catch {
            print("Error toggling flash: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ScanView()
}
