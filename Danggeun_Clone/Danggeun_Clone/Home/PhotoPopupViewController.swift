//
//  PhotoPopupViewController.swift
//  Danggeun_Clone
//
//  Created by PKW on 2022/05/25.
//

import UIKit

class PhotoPopupViewController: UIViewController {

    @IBOutlet var visualView: UIView!
    @IBOutlet var popupView: UIView!
    
    @IBOutlet var popupLabel: UILabel!
    @IBOutlet var closeButton: UIButton!
    
    var photoCount: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popupView.layer.cornerRadius = 5
        closeButton.layer.cornerRadius = 5
        
        if let photoCount = photoCount {
            popupLabel.text = "이미지는 최대 \(photoCount)까지 첨부할 수 있어요."
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.3, delay: 0.0) {
            self.visualView.alpha = 0.5
            self.popupView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    @IBAction func tapCloseButton(_ sender: Any) {
        dismiss(animated: false)
    }
    
}
