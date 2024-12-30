//
//  CameraView.swift
//  Splash KAB
//
//  Created by Shamam Alkafri on 30/12/2024.
//


import SwiftUI
import AVFoundation
import Foundation
import Vision
import UIKit


// MARK: - cameraview
struct CameraView: UIViewControllerRepresentable {
    var cameraModel: CameraModel

    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.cameraModel = cameraModel
        return controller
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}
