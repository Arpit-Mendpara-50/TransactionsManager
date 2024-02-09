//
//  ImagePickerManager.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-01-26.
//

import Foundation
import SwiftUI

class ImagePickerManager: ObservableObject {
    
    public static var shared: ImagePickerManager = {
        let mgr = ImagePickerManager()
        return mgr
    }()
    @Published var selectedImage: UIImage?
    @Published var selectedImageName: String?
    @Published var isImagePickerPresented: Bool = false
    
    func loadImage() {
        // Handle the selected image from the image picker
    }
    
    func saveImageToDocumentsDirectory(image: UIImage) {
        if let data = image.jpegData(compressionQuality: 1.0) {
            let filename = getDocumentsDirectory().appendingPathComponent(self.selectedImageName ?? "savedImage.jpg")
            try? data.write(to: filename)
        }
    }
    
    func loadImageFromDocumentsDirectory(imageName: String) -> UIImage? {
        let filename = getDocumentsDirectory().appendingPathComponent(imageName)
        return UIImage(contentsOfFile: filename.path)
    }
    // MARK: Not using
    func loadImageFromDocumentsURL(imageURL: URL) -> UIImage? {
        let filename = imageURL
        return UIImage(contentsOfFile: filename.path)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
