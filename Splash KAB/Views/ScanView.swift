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
    @State private var capturedImage: CGImage?
    @State private var prediction: String = "لم يتم اكتشاف أي كائن"
    @State private var detectedObject: String = ""
    @State private var showSheet: Bool = false

    // Model-specific details
    let bucketDetails: [String: String] = [
        "Panadol": NSLocalizedString("Panadol", comment: "Panadol description"),
        "Ibuprofen": NSLocalizedString("Ibuprofen", comment: "Ibuprofen description"),
        "Megamox": NSLocalizedString("Megamox", comment: "Megamox description"),
        "Bucket1": NSLocalizedString("Bucket 1", comment: "Bucket 1 description"),
        "Bucket2": NSLocalizedString("Bucket 2", comment: "Bucket 2 description"),
        "Unknown": NSLocalizedString("Unknown", comment: "Unknown description")
    ]

    // MARK: - Main Body
    var body: some View {
        ZStack {
            Camera1View(cameraModel: cameraModel)

            VStack {
                Spacer()

                Button(action: captureImage) {
                    Text("التقاط صورة")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            cameraModel.startSession { image in
                self.capturedImage = image
            }
        }
        .onDisappear {
            cameraModel.stopSession()
        }
        .sheet(isPresented: $showSheet) {
            DetectedObjectSheet(
                objectName: detectedObject,
                pillDetails: bucketDetails,
                onClose: {
                    showSheet = false 
                }
            )
            .presentationDetents([.fraction(0.5)])
            .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Capture and Classify Image
    private func captureImage() {
        guard let image = capturedImage else {
            prediction = "لم يتم التقاط صورة"
            print("Error: No image captured")
            return
        }
        print("Image captured successfully. Passing to model...")
        classifyImageUsingBucketModel(image: image)
    }

    // MARK: - Classify Image with First Model (Bucket Model)
    private func classifyImageUsingBucketModel(image: CGImage) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let model = try? VNCoreMLModel(for: KabsolaApp().model) else {
                print("Failed to load bucket detection model.")
                return
            }

            let request = VNCoreMLRequest(model: model) { request, error in
                if let results = request.results as? [VNClassificationObservation],
                   let topResult = results.first {
                    DispatchQueue.main.async {
                        let confidence = topResult.confidence * 100
                        print("Bucket Model Result: \(topResult.identifier) (\(confidence)%)")
                        
                        if confidence >= 80 {
                            detectedObject = bucketDetails[topResult.identifier] ?? "Unknown"
                            prediction = "تم الكشف عن: \(detectedObject) (\(Int(confidence))%)"
                        } else {
                            detectedObject = "غير معروف"
                            prediction = "لم يتم التعرف على الكائن (\(Int(confidence))%)"
                        }
                        
                        showSheet = true
                    }
                }
            }

            let handler = VNImageRequestHandler(cgImage: image, options: [:])
            do {
                try handler.perform([request])
            } catch {
                print("Error performing bucket model request: \(error)")
            }
        }
    }

    // MARK: - Reset Detection
    private func resetDetection() {
        detectedObject = ""
        prediction = "جارٍ المسح..."
    }
}

