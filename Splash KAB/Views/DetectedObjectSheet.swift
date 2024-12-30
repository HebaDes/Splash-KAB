//
//  DetectedObjectSheet.swift
//  Splash KAB
//
//  Created by Shamam Alkafri on 30/12/2024.
//

import SwiftUI

struct DetectedObjectSheet: View {
    let objectName: String
    let pillDetails: [String: String]
    let onClose: () -> Void

    var body: some View {
        VStack {
            Text("تم الكشف عن الكائن")
                .font(.largeTitle)
                .padding(20)
            
            Text("تم الكشف عن: \(objectName)")
                .font(.title)
                .padding()

            // Button to restart detection
            Button("حاول مرة أخرى") {
                onClose()
            }
            .padding(20)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .navigationBarBackButtonHidden(true) 
    }
}
