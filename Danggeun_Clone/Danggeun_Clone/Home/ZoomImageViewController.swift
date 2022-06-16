//
//  ZoomImageViewController.swift
//  Danggeun_Clone
//
//  Created by PKW on 2022/06/08.
//

import UIKit
import SnapKit

class ZoomImageViewController: UIViewController {

    @IBOutlet var visualView: UIView!
    @IBOutlet var imageScrollView: UIScrollView!
    
    var images: [UIImage]?
    var imageIndex: Int?
    
    var imageViewTopOriginY = 0.0
    var imageViewBottomOriginY = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        imageScrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.height.equalToSuperview()
        }
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(tapGesture))
        gesture.delegate = self
        imageScrollView.addGestureRecognizer(gesture)
        
        
        self.imageScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(images?.count ?? 0), height: self.view.frame.height)

        configureImages()
        configureImageViewContentOffsetX()
    }
    

    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    func configureImageViewContentOffsetX() {
        let imageView = imageScrollView.subviews.filter({$0 is UIImageView})
        imageScrollView.contentOffset.x = imageView[imageIndex ?? 0].frame.origin.x
    }
   
    
    @objc func tapGesture(_ sender: UIPanGestureRecognizer) {
        let point = sender.translation(in: imageScrollView)
        let velocity = sender.velocity(in: imageScrollView)
    
        if abs(velocity.y.magnitude) > abs(velocity.x.magnitude) {
            imageScrollView.center.y = self.view.frame.height / 2 + point.y
            imageScrollView.isScrollEnabled = false
        } else {
            imageScrollView.isScrollEnabled = true
        }

        if sender.state.rawValue == 3 {
            imageScrollView.center.y = self.view.frame.height / 2
        }
        
        let top = imageViewTopOriginY + point.y
        let bottom = imageViewBottomOriginY + point.y
        
        let ratio = imageScrollView.center.y / UIScreen.main.bounds.height
        
        if ratio < 0.5 {
            print(imageScrollView.center.y)
        } else if ratio > 0.5 {
            print(imageScrollView.center.y)
        }
     
        
        if top < UIScreen.main.bounds.origin.x + 10 {
            print("상단에 가까움")
            
        } else if bottom > UIScreen.main.bounds.height - 10 {
            print("바텀에 가까움")
            
        }
        
    }
    
    func configureImages() {
        guard let images = images else { return }
        
        for (index, image) in images.enumerated() {
            let imageView = UIImageView()
            let xPos = UIScreen.main.bounds.width * CGFloat(index)
            
            imageView.image = image
            
            let ratio = image.size.width / image.size.height
            var newHeight = UIScreen.main.bounds.width / ratio
            
            if newHeight > 700 {
                newHeight = UIScreen.main.bounds.height * 0.8
            } else if newHeight < UIScreen.main.bounds.height / 2 {
                newHeight = UIScreen.main.bounds.height / 2
            }
            
            imageView.frame = CGRect(x: xPos, y: 0, width: UIScreen.main.bounds.width, height: floor(newHeight))
            
            imageScrollView.addSubview(imageView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let imageView = imageScrollView.subviews.filter({$0 is UIImageView})
    
        UIView.animate(withDuration: 0.5) {
            for i in 0..<imageView.count {
                imageView[i].center.y = self.imageScrollView.center.y
            }
        }

        imageViewTopOriginY = imageView[imageIndex ?? 0].frame.origin.y
        imageViewBottomOriginY = imageView[imageIndex ?? 0].frame.origin.y + imageView[imageIndex ?? 0].frame.height
    }
}

extension ZoomImageViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
