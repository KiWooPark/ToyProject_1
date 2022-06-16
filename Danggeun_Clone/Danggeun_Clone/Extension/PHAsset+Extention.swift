//
//  UIImage+Extention.swift
//  Danggeun_Clone
//
//  Created by PKW on 2022/06/06.
//

import Foundation
import UIKit
import Photos

extension PHAsset {
    func resizeImage(size: CGSize) -> UIImage {
        var thumbnail = UIImage()
        let manager = PHImageManager.default()
        
        manager.requestImage(for: self, targetSize: size, contentMode: .aspectFit, options: nil) { result, info in
            
            if let image = result {
                thumbnail = image
            }
        }
        return thumbnail
    }
}
