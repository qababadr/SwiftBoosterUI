//
//  Helpers.swift
//  CoreUI
//
//  Created by BADR  QABA on 2026-02-25.
//
import SwiftUI
import Photos
import QuickLook

public struct FilePreview: UIViewControllerRepresentable {
    private let url: URL

    public init(url: URL) {
        self.url = url
    }
    
    public func makeUIViewController(context: Context) -> UINavigationController {
        let previewController = QLPreviewController()
        previewController.dataSource = context.coordinator
        
        // Embed in navigation controller
        let navigation = UINavigationController(rootViewController: previewController)
        navigation.modalPresentationStyle = .fullScreen
        
        return navigation
    }

    public func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(url: url)
    }
    
    public class Coordinator: NSObject, QLPreviewControllerDataSource {
        private let url: URL
        
        public init(url: URL) {
            self.url = url
        }
        
        public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            1
        }
        
        public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            url as NSURL
        }
    }
}

public extension FileUploader {
    func requestPhotoLibraryAccess(completion: @Sendable @escaping (Bool) -> Void) {

        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        switch status {
        case .authorized, .limited:
            completion(true)

        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized || newStatus == .limited)
                }
            }

        case .denied, .restricted:
            completion(false)

        @unknown default:
            completion(false)
        }
    }
}
