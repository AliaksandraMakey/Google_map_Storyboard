//
//  FilesManager.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 14.12.2023.
//

import UIKit

final class FilesManager: NSObject {

    static let defaultUserMarkerImage = UIImage(systemName: "person.fill")
    static let userImageName = "userImage"
    
    static func saveImage(imageName: String, image: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentsDirectory.appendingPathComponent(imageName)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print("Error removing existing image: \(error)")
            }
        }
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }

        do {
            try imageData.write(to: fileURL)
        } catch {
            print("Error saving image: \(error)")
        }
    }

    static func loadImageFromDiskWith(fileName: String) -> UIImage? {

        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }

        return nil
    }
}
