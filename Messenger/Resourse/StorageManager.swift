//
//  StorageManager.swift
//  Messenger
//
//  Created by Valerian   on 21/11/2020.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    let storage = Storage.storage().reference()
    
    typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    //uploadProfilePicture
    public func uploadProfilePicture(with data: Data,
                                     filename: String,
                                     completion: @escaping UploadPictureCompletion) {
        storage.child("image\(filename)").putData(data, metadata: nil) { (metadata, error) in
            guard error == nil else{
                print("Failed to upload picture to Firebase for picture ")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self.storage.child("image\(filename)").downloadURL { (url, error) in
                guard let url = url else {
                    print("fail to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                print(urlString)
                completion(.success(urlString))
            }
        }
    }
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
}
