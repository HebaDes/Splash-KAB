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
    @State private var detectedUsage: String = ""
    @State private var showSheet: Bool = false

    // Model-specific details
    let bucketDetails: [String: String] = [
        "Panadol": NSLocalizedString("بنادول: يستخدم لتخفيف الألم والحمى", comment: "Panadol description"),
        "Ibuprofen": NSLocalizedString("ايبوبروفين: يستخدم لتقليل الالتهابات والألم", comment: "Ibuprofen description"),
        "Megamox": NSLocalizedString("ميجاموكس: مضاد حيوي يستخدم لعلاج العدوى", comment: "Megamox description"),
        "AziOnce": NSLocalizedString("ازي وانس: مضاد حيوي يستخدم لعلاج العدوى", comment: "AziOnce description"),
        "Bucket1": NSLocalizedString("دلو 1: وصف لدواء دلو 1", comment: "Bucket 1 description"),
        "Bucket2": NSLocalizedString("دلو 2: وصف لدواء دلو 2", comment: "Bucket 2 description"),
        "Unknown": NSLocalizedString("غير معروف: لا توجد تفاصيل متوفرة", comment: "Unknown description")
    ]

    let bucketNames: [String: String] = [
        "Panadol": "بنادول",
        "Ibuprofen": "ايبوبروفين",
        "Megamox": "ميجاموكس",
        "AziOnce": "ازي وانس",
        "Bucket1": "دلو 1",
        "Bucket2": "دلو 2",
        "Unknown": "غير معروف"
    ]

    // MARK: - Main Body
    var body: some View {
        ZStack {
            Camera1View(cameraModel: cameraModel)

            VStack {
                Spacer()

                // MARK: - Buttons
                HStack {
                    // Static Pill Detection Button
                    Button(action: detectPillStatic) {
                        Text("كشف الحبة")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color(red: 0.00, green: 0.74, blue: 0.83)) // #00BCD4
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    // Dynamic Bucket Model Detection Button
                    Button(action: captureImageUsingBucketModel) {
                        Text("كشف الدواء")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color(red: 0.10, green: 0.14, blue: 0.49)) // #1A237E
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 50)
            }
        }
        .navigationBarBackButtonHidden(true) // Hide the back button
        .onAppear {
            cameraModel.startSession { image in
                self.capturedImage = image
            }
        }
        .onDisappear {
            cameraModel.stopSession()
        }
        .sheet(isPresented: $showSheet) {
            VStack {
                Text("اسم الحبة: \(bucketNames[detectedObject] ?? "غير معروف")")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                Text("الوصف:")
                    .font(.headline)
                    .padding(.top)

                Text(detectedUsage)
                    .font(.body)
                    .padding()

                Button(action: {
                    resetDetection()
                    showSheet = false
                }) {
                    Text("إغلاق")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color(red: 0.83, green: 0.18, blue: 0.18)) // #D32F2F
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding()
            .presentationDetents([.fraction(0.5)])
            .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Pill Detection
    private func detectPillStatic() {
        prediction = "جارٍ المسح..."
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Simulate processing time
            self.detectedObject = "Panadol"
            self.detectedUsage = bucketDetails[self.detectedObject] ?? "لا توجد تفاصيل متوفرة"
            self.prediction = "تم الكشف عن: \(self.detectedObject)"
            self.showSheet = true
        }
    }

    // MARK: - Capture and Classify Image Using Bucket Model
    private func captureImageUsingBucketModel() {
        guard let image = capturedImage else {
            prediction = "لم يتم التقاط صورة"
            print("Error: No image captured")
            return
        }
        print("Image captured successfully. Passing to bucket model...")
        classifyImageUsingBucketModel(image: image)
    }

    // MARK: - Classify Image with Bucket Model
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
                            detectedObject = topResult.identifier
                            detectedUsage = bucketDetails[detectedObject] ?? "لا توجد تفاصيل متوفرة"
                            prediction = "تم الكشف عن: \(bucketNames[detectedObject] ?? detectedObject) (\(Int(confidence))%)"
                        } else {
                            detectedObject = "Unknown"
                            detectedUsage = bucketDetails[detectedObject] ?? "لا توجد تفاصيل متوفرة"
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
        detectedUsage = ""
        prediction = "جارٍ المسح..."
    }
}

// MARK: - Preview
struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView()
            .previewDevice("iPhone 15 Pro")
    }
}
