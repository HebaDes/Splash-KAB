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
        VStack(spacing: 20) {
            Text("النتيجة")
                .font(.largeTitle)
                .padding(.top, 20)

            Text("تم الكشف عن: \(objectName)")
                .font(.title)
                .multilineTextAlignment(.leading)
                .padding()

            Spacer()

            // Close Button
            Button(action: onClose) {
                Text("إغلاق")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.83, green: 0.18, blue: 0.18)) // Custom HEX Color (#D32F2F)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .padding()
    }
}
