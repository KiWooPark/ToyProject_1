//
//  FireStorageManager.swift
//  Danggeun_Clone
//
//  Created by PKW on 2022/05/18.
//

import Foundation
import FirebaseStorage


enum UploadType {
    case profileImage
    case addProductImage
}

class FirebaseStorageManager {
    
    static func uploadImage(image: Data, position: Int?, uploadType: UploadType, completion: @escaping (URL?,Int) -> ())  {
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let randomNumber = Int.random(in: 0...9999)
        
        
        
        let imageName: String?
        let firebaseReference: StorageReference?
        
        switch uploadType {
        case .profileImage:
            imageName = "ProductImage " + String(randomNumber)
            firebaseReference = Storage.storage().reference().child("productImage/" + (imageName ?? ""))
        case .addProductImage:
            imageName = "profileImage " + String(randomNumber)
            firebaseReference = Storage.storage().reference().child("profileImage/" + (imageName ?? ""))
        }
        
        firebaseReference?.putData(image, metadata: metaData) { metaData, error in
            if let error = error {
                print("사진 업로드 에러 = \(error)")
            } else {
                firebaseReference?.downloadURL { url, error in
                    if let error = error {
                        print("URL 다운로드 에러 = \(error)")
                    }
                    completion(url,position ?? 0)
                }
            }
        }
    }
    
    static func uploadImage(image: UIImage?, position: Int?, uploadType: UploadType, completion: @escaping (URL?,Int?) -> ())  {
    
        guard let image = image else { return completion(nil,nil) }
        
        let imageData = image.jpegData(compressionQuality: 0.8) ?? Data()
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let randomNumber = Int.random(in: 0...9999)
        
        let imageName: String?
        let firebaseReference: StorageReference?
        
        switch uploadType {
        case .profileImage:
            imageName = "profileImage " + String(randomNumber)
            firebaseReference = Storage.storage().reference().child("profileImage/" + (imageName ?? ""))
        case .addProductImage:
            imageName = "ProductImage " + String(randomNumber)
            firebaseReference = Storage.storage().reference().child("productImage/" + (imageName ?? ""))
        }
        
        firebaseReference?.putData(imageData, metadata: metaData) { metaData, error in
            if let error = error {
                print("사진 업로드 에러 = \(error)")
            } else {
                firebaseReference?.downloadURL { url, error in
                    if let error = error {
                        print("URL 다운로드 에러 = \(error)")
                    }
                    completion(url,position ?? 0)
                }
            }
        }
    }
}


