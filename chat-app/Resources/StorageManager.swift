//
//  StorageManager.swift
//  chat-app
//
//  Created by Nurzhamal Shaliyeva on 12.03.2023.
//

import Foundation
import FirebaseStorage

public enum StorageErrors: Error {
    case failedToUpload
    case failedToGetDownloadURL
}

final class StorageManager {
    static let shared = StorageManager()

    private let storage = Storage.storage().reference()
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void

///Upload picture ti fbStorage and return completion with url string to download
    public func uploadProfilePic(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion)  {
        
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                //failed
                print("Failed to upload data firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    print("Failed To Get Download URL")
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                
                let urlString = url.absoluteString
                print("Download url returned: \(urlString)")
                completion(.success(urlString))
            }
        })
    }
}
