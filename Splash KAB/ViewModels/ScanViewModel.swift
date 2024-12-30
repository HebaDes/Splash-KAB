//
//  ScanViewModel.swift
//  Splash KAB
//
//  Created by Shamam Alkafri on 30/12/2024.
//

import SwiftUI
import Vision
import CoreML

class ScanViewModel: ObservableObject {
    @Published var prediction: String = "جارٍ المسح..."
    @Published var detectedObject: String = ""
    @Published var isDetectionPaused: Bool = false
    @Published var showSheet: Bool = false

    let pillDetails: [String: String] = [
        "Panadol": NSLocalizedString("Panadol", comment: "Panadol description"),
        "Ibuprofen": NSLocalizedString("Ibuprofen", comment: "Ibuprofen description"),
        "Megamox": NSLocalizedString("Megamox", comment: "Megamox description"),
        "Unknown": NSLocalizedString("Unknown", comment: "Unknown pill description")
    ]

    func classifyImage(image: CGImage, using model: VNCoreMLModel) {
        guard !isDetectionPaused else { return }

        DispatchQueue.global(qos: .userInitiated).async {
            let request = VNCoreMLRequest(model: model) { request, error in
                if let results = request.results as? [VNClassificationObservation],
                   let topResult = results.first {
                    DispatchQueue.main.async {
                        let confidence = topResult.confidence * 100
                        if confidence >= 99 {
                            self.detectedObject = topResult.identifier
                            self.prediction = "تم الكشف عن: \(self.detectedObject) (\(Int(confidence))%)"
                            self.showSheet = true
                            self.pauseDetection(for: 60) // Stop for 60 seconds
                        } else if confidence >= 70 {
                            self.prediction = "جارٍ المسح... الرجاء الانتظار (\(Int(confidence))%)"
                        } else {
                            self.prediction = "الكائن بعيد جدًا (\(Int(confidence))%)"
                        }
                    }
                }
            }

            let handler = VNImageRequestHandler(cgImage: image, options: [:])
            try? handler.perform([request])
        }
    }

    func pauseDetection(for seconds: Int) {
        isDetectionPaused = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds)) {
            self.isDetectionPaused = false
        }
    }

    func resetDetection() {
        isDetectionPaused = false
    }
}
