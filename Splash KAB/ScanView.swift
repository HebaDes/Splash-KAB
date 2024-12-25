import SwiftUI
import AVFoundation
import CoreML
import Vision

struct ScanView: View {
    @StateObject private var cameraModel = Camera1ViewModel()
    @State private var prediction: String = "جارٍ المسح..."
    @State private var detectedObject: String = ""
    @State private var showSheet: Bool = false
    @State private var isDetectionPaused: Bool = false

    @State private var newPrediction: String = "جارٍ المسح باستخدام النموذج الجديد..."
    @State private var newDetectedObject: String = ""
    @State private var newShowSheet: Bool = false

    let pillDetails: [String: String] = [
        "Panadol": NSLocalizedString("Panadol", comment: "Panadol description"),
        "Ibuprofen": NSLocalizedString("Ibuprofen", comment: "Ibuprofen description"),
        "Megamox": NSLocalizedString("Megamox", comment: "Megamox description"),
        "Unknown": NSLocalizedString("Unknown", comment: "Unknown pill description")
    ]

    var body: some View {
        ZStack {
            Camera1View(cameraModel: cameraModel)
            VStack {
                Spacer()

                if !isDetectionPaused {
                    Text(prediction)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 10)

                    Text(newPrediction)
                        .padding()
                        .background(Color.gray.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                } else {
                    Text("الكاميرا متوقفة مؤقتًا")
                        .padding()
                        .background(Color.red.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                }
            }
        }
        .onAppear { // When the view appears, start the camera session
            cameraModel.startSession { image in
                guard !isDetectionPaused else { return }// Skip detection if paused
                classifyImageUsingOldModel(image: image)
                classifyImageUsingNewModel(image: image)
            }
        }
        .onDisappear {// When the view disappears, stop the camera session
            cameraModel.stopSession()
        }
        //خليت الشيت هنا تكون (٠.٧) عشان يبان انو شيت و ما يكون علئ كامل الصفحة
        .sheet(isPresented: $showSheet) {
            DetectedObjectSheet(objectName: detectedObject, pillDetails: pillDetails) {
                restartDetection()
            }
            .presentationDetents([.fraction(0.7)]) // Occupy half the screen
            .presentationDragIndicator(.visible)  // Optional: Show a drag indicator
        }
        .sheet(isPresented: $newShowSheet) {
            DetectedObjectSheet(objectName: newDetectedObject, pillDetails: pillDetails) {
                restartDetection()
            }
            .presentationDetents([.fraction(0.7)]) // Occupy half the screen
            .presentationDragIndicator(.visible)  // Optional: Show a drag indicator
        }
    }
    // Classify an image using the old model

    private func classifyImageUsingOldModel(image: CGImage) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let model = try? VNCoreMLModel(for: KabsolaApp().model) else {
                print("Failed to load the old model.")
                return
            }

            let request = VNCoreMLRequest(model: model) { request, error in
                if let results = request.results as? [VNClassificationObservation],
                   let topResult = results.first {
                    DispatchQueue.main.async {
                        let confidence = topResult.confidence * 100
                        if confidence >= 99 {
                            detectedObject = topResult.identifier
                            prediction = "تم الكشف عن: \(detectedObject) (\(Int(confidence))%)"
                            //هنا يتعامل بالثواني ف  لو حطيتي ٦٠ يعني دقيقه و هكذا
                            stopDetection(for: 120) // Stop for 2 minutes
                            showSheet = true
                        } else if confidence >= 70 {
                            prediction = "جارٍ المسح... الرجاء الانتظار (\(Int(confidence))%)"
                        } else {
                            prediction = "الكائن بعيد جدًا (\(Int(confidence))%)"
                        }
                    }
                }
            }

            let handler = VNImageRequestHandler(cgImage: image, options: [:])
            try? handler.perform([request])
        }
    }
    // Classify an image using the new model

    private func classifyImageUsingNewModel(image: CGImage) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let model = try? VNCoreMLModel(for: pillDetect(configuration: MLModelConfiguration()).model) else {
                print("Failed to load the new model.")
                return
            }

            let request = VNCoreMLRequest(model: model) { request, error in
                if let results = request.results as? [VNClassificationObservation],
                   let topResult = results.first {
                    DispatchQueue.main.async {
                        let confidence = topResult.confidence * 100
                        if confidence >= 99 {
                            newDetectedObject = topResult.identifier
                            newPrediction = "تم الكشف عن: \(newDetectedObject) (\(Int(confidence))%)"
                            stopDetection(for: 60) // Stop for 30 seconds
                            newShowSheet = true
                        } else if confidence >= 70 {
                            newPrediction = "جارٍ المسح باستخدام النموذج... الرجاء الانتظار (\(Int(confidence))%)"
                        } else {
                            newPrediction = "الكائن بعيد جدًا بالنسبة للنموذج الجديد (\(Int(confidence))%)"
                        }
                    }
                }
            }

            let handler = VNImageRequestHandler(cgImage: image, options: [:])
            try? handler.perform([request])
        }
    }
// فنكشن توقف ديتيكشن
    private func stopDetection(for seconds: Int) {
        isDetectionPaused = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds)) {
            isDetectionPaused = false
        }
    }
// يسوي ريستارت للديتيكشن
    private func restartDetection() {
        isDetectionPaused = false
    }
}

struct DetectedObjectSheet: View {
    let objectName: String
    let pillDetails: [String: String]
    let onClose: () -> Void

    var body: some View {
        VStack {
            Text("تم الكشف عن الكائن")
                .font(.largeTitle)
                .padding()
            Text("تم الكشف عن: \(objectName)")
                .font(.title)
                .padding()
            Text(pillDetails[objectName] ?? "No details available.")
                .font(.title)
                .padding()
            // في كل مره يضغط علئ الزر يشتغل الديتكشن و يطلع الشيت
            Button("حاول مرة أخرى") {
                onClose()
            }
            .padding(30)
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
}

#Preview {
    ScanView()
}
