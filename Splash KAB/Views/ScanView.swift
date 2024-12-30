//
//  ScanView.swift
//  Splash KAB
//
//  Created by Shamam Alkafri on 30/12/2024.
//

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

    // MARK: - Camera view for live detection
    var body: some View {
        ZStack {
            
            Camera1View(cameraModel: cameraModel)
            VStack {
                Spacer()

                // Predictions and detection results
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
            .navigationBarBackButtonHidden(true) 
        }
        
        // MARK: - Start the camera , stop and other processes
        .onAppear {
            
            cameraModel.startSession { image in
                guard !isDetectionPaused else { return } // Skip detection if paused
                classifyImageUsingOldModel(image: image)
                classifyImageUsingNewModel(image: image)
            }
        }
        .onDisappear {
            // Stop the camera session when view disappears
            cameraModel.stopSession()
        }
        .sheet(isPresented: $showSheet) {
            // Show detailed information for the detected object
            DetectedObjectSheet(
                objectName: pillDetails[detectedObject] ?? NSLocalizedString("Unknown", comment: "Unknown pill description"),
                pillDetails: pillDetails
            ) {
                restartDetection()
            }
            .presentationDetents([.fraction(0.6)])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $newShowSheet) {
            // Show information for new model detections
            DetectedObjectSheet(
                objectName: pillDetails[newDetectedObject] ?? NSLocalizedString("Unknown", comment: "Unknown pill description"),
                pillDetails: pillDetails
            ) {
                restartDetection()
            }
            .presentationDetents([.fraction(0.6)])
            .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Classify an image using the old model
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
                        if confidence >= 88 {
                            detectedObject = topResult.identifier
                            prediction = "تم الكشف عن: \(pillDetails[detectedObject] ?? NSLocalizedString("Unknown", comment: "Unknown pill description")) (\(Int(confidence))%)"
                            stopDetection(for: 30) // Stop detection for 1 minute
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

    // MARK: - Classify an image using the new model
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
                        if confidence >= 88 {
                            newDetectedObject = topResult.identifier
                            newPrediction = "تم الكشف عن: \(pillDetails[newDetectedObject] ?? NSLocalizedString("Unknown", comment: "Unknown pill description")) (\(Int(confidence))%)"
                            stopDetection(for: 30) // Stop detection for 1 minute
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

    // MARK: - Pause detection for a specified duration
    private func stopDetection(for seconds: Int) {
        isDetectionPaused = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds)) {
            isDetectionPaused = false
        }
    }

    // MARK: - Restart detection after pausing
    private func restartDetection() {
        isDetectionPaused = false
    }
}
