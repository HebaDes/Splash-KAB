import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        return controller
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}
