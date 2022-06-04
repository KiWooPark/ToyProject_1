//
//  FireStorageManager.swift
//  Danggeun_Clone
//
//  Created by PKW on 2022/05/18.
//

import Foundation
import FirebaseStorage
import Photos

class FirebaseStorageManager {
    
    static func uploadImage(image: Data, position: Int, completion: @escaping (URL?,Int) -> ())  {
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let randomNumber = Int.random(in: 0...9999)
        let imageName = "Product " + String(randomNumber)
        
        let firebaseReference = Storage.storage().reference().child("images/" + imageName)
        
        firebaseReference.putData(image, metadata: metaData) { metaData, error in
            if let error = error {
                print("사진 업로드 에러 = \(error)")
            } else {
                firebaseReference.downloadURL { url, error in
                    if let error = error {
                        print("URL 다운로드 에러 = \(error)")
                    }
                    completion(url,position)
                }
            }
        }
    }
}


