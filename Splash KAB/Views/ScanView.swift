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

    let pillDetails: [String: String] = [
        "Panadol": NSLocalizedString("Panadol", comment: "Panadol description"),
        "Ibuprofen": NSLocalizedString("Ibuprofen", comment: "Ibuprofen description"),
        "Megamox": NSLocalizedString("Megamox", comment: "Megamox description"),
        "Unknown": NSLocalizedString("Unknown", comment: "Unknown pill description")
    ]

    let bucketDetails: [String: String] = [
        "Bucket1": NSLocalizedString("Bucket 1", comment: "Bucket 1 description"),
        "Bucket2": NSLocalizedString("Bucket 2", comment: "Bucket 2 description"),
        "Unknown": NSLocalizedString("Unknown Bucket", comment: "Unknown bucket description")
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
                classifyImageUsingBucketModel(image: image)
            }
        }
        .onDisappear {
            // Stop the camera session when view disappears
            cameraModel.stopSession()
        }
        .sheet(isPresented: $showSheet) {
            // Show detailed information for the detected object
            DetectedObjectSheet(
                objectName: detectedObject,
                pillDetails: pillDetails.merging(bucketDetails) { (_, new) in new }
            ) {
                restartDetection()
            }
            .presentationDetents([.fraction(0.6)])
            .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Classify image using the bucket model
    private func classifyImageUsingBucketModel(image: CGImage) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let model = try? VNCoreMLModel(for: KabsolaApp().model) else {
                print("Failed to load the bucket detection model.")
                return
            }

            let request = VNCoreMLRequest(model: model) { request, error in
                if let results = request.results as? [VNClassificationObservation],
                   let topResult = results.first {
                    DispatchQueue.main.async {
                        let confidence = topResult.confidence * 100
                        if confidence >= 85 {
                            detectedObject = bucketDetails[topResult.identifier] ?? NSLocalizedString("Unknown", comment: "Unknown bucket description")
                            prediction = "تم الكشف عن: \(detectedObject) (\(Int(confidence))%)"
                            showSheet = true
                            stopDetection(for: 30)
                        } else {
                            prediction = "جارٍ المسح عن الدلو... (\(Int(confidence))%)"
                            if topResult.identifier == "Unknown" || confidence < 85 {
                                classifyImageUsingPillModel(image: image)
                            }
                        }
                    }
                }
            }

            let handler = VNImageRequestHandler(cgImage: image, options: [:])
            try? handler.perform([request])
        }
    }

    // MARK: - Classify image using the pill model
    private func classifyImageUsingPillModel(image: CGImage) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let model = try? VNCoreMLModel(for: pillDetect().model) else {
                print("Failed to load the pill detection model.")
                return
            }

            let request = VNCoreMLRequest(model: model) { request, error in
                if let results = request.results as? [VNClassificationObservation],
                   let topResult = results.first {
                    DispatchQueue.main.async {
                        let confidence = topResult.confidence * 100
                        if confidence >= 85 {
                            detectedObject = pillDetails[topResult.identifier] ?? NSLocalizedString("Unknown", comment: "Unknown pill description")
                            prediction = "تم الكشف عن: \(detectedObject) (\(Int(confidence))%)"
                            showSheet = true
                            stopDetection(for: 30)
                        } else {
                            detectedObject = NSLocalizedString("Unknown", comment: "Unknown object description")
                            prediction = "لم يتم التعرف على الكائن (\(Int(confidence))%)"
                            showSheet = true
                            stopDetection(for: 30)
                        }
                    }
                }
            }

            let handler = VNImageRequestHandler(cgImage: image, options: [:])
            try? handler.perform([request])
        }
    }    // MARK: - Pause detection for a specified duration
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
