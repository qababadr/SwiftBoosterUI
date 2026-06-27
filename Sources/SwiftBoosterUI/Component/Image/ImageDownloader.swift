//
//  ImageDownloader.swift
//  CoreUI
//
//  Created by BADR  QABA on 2026-02-11.
//

import Foundation
import SwiftUI

extension ImageDownloader {
    
    /// Check if an image exists in disk cache
    func isCached(url: URL) async -> Bool {
        let key = url.absoluteString
            .addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? UUID().uuidString
        return await fileManager.getImage(imageName: key, folderName: folderName) != nil
    }
}

actor ImageDownloader {
    
    private let fileManager = LocalFileManager.instance
    private let folderName = "cached_images"
    
    /// Downloads or returns cached image using the URL as the key
    func cache(url: URL) async throws -> UIImage? {
        // Use URL absoluteString as cache key
        let key = url.absoluteString
            .addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? UUID().uuidString
        
        // Check disk cache
        if let savedImage = await fileManager.getImage(imageName: key, folderName: folderName) {
            return savedImage
        }
        
        // Download from network
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let image = handleResponse(data: data, response: response) else {
            return nil
        }
        
        // Save to disk
        await fileManager.saveImage(image: image, imageName: key, folderName: folderName)
        return image
    }
    
    private func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        return image
    }
}

