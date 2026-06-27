//
//  LocalFileManager.swift
//  CoreUI
//
//  Created by BADR  QABA on 2026-02-11.
//

import Foundation
import SwiftUI

actor LocalFileManager {
    
    static let instance = LocalFileManager()
    private init() { }
    
    func getFolderContent(folderName: String, fileExtension: String) throws -> [String] {
        guard let url = getURLForFolder(folderName: folderName) else { return [] }
        let fileManager = FileManager.default
        
        do {
            let fileNames = try fileManager.contentsOfDirectory(atPath: url.path)
            
            return fileNames.filter { $0.lowercased().hasSuffix(fileExtension) }
        } catch {
            throw error
        }
    }
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        // create folder
        createFolderIfNeeded(folderName: folderName)
        
        // get path for image
        guard
            let data = image.pngData(),
            let url = getURLForFile(imageName: imageName, folderName: folderName)
        else { return }
        
        // save image to path
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image. ImageName: \(imageName). \(error)")
        }
    }
    
    func getImage(
        imageName: String,
        folderName: String,
        fileExtension: String = ".png")
    -> UIImage? {
        guard
            let url = getURLForFile(
                imageName: imageName,
                folderName: folderName,
                fileExtension: fileExtension),
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    func getImages(
        names: [String],
        folderName: String,
        fileExtension: String = ".png")
    -> [UIImage] {
        var uiImages: [UIImage] = []
        names.forEach { name in
            if let image = getImage(imageName: name, folderName: folderName, fileExtension: fileExtension) {
                uiImages.append(image)
            }
        }
        return uiImages
    }
    
    func getURLForFile(imageName: String, folderName: String, fileExtension: String = ".png") -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        let imageNameWithExtension = imageName.hasSuffix(fileExtension) ? imageName : imageName + fileExtension
        return folderURL.appendingPathComponent(imageNameWithExtension)
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory. FolderName: \(folderName). \(error)")
            }
        }
    }
    
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }
    
}
