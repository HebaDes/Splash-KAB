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
            Text("تم الكشف عن الكائن")
                .font(.largeTitle)
                .padding(.top, 20)

            Text("تم الكشف عن: \(objectName)")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            // Close Button
            Button(action: onClose) {
                Text("إغلاق")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .padding()
    }
}
