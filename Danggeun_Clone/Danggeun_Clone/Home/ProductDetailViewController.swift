//
//  ProductDetailViewController.swift
//  Danggeun_Clone
//
//  Created by PKW on 2022/05/30.
//

import UIKit
import SnapKit
import Kingfisher

class ProductDetailViewController: UIViewController {

    
    @IBOutlet var productImagesScrollView: UIScrollView!
    @IBOutlet var productPageControl: UIPageControl!
    
    var product: ProductRegistrationModel?
    
    var imageView = UIImageView()
    var imageHeight = [CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        configurMainScrollView()
        
        downloadImages { images in
            DispatchQueue.main.async {
                self.downloadImages { images in
                    print(images)
                }
                //self.configureImageView(images: images)
                //self.configurMainScrollView()
            }
        }
    }
    
    func configurMainScrollView() {
        
    }
    
    
    
    
    
//        func configureImageView(images: [UIImage]) {
//
//            guard let maxHeight = images.map({ $0.size.width / $0.size.height }).map({ UIScreen.main.bounds.width / $0 }).max() else { return }
//
//            // 페이지 컨트롤 속성
//            productPageControl.currentPage = 0
//            productPageControl.numberOfPages = images.count
//            productPageControl.pageIndicatorTintColor = .black
//            productPageControl.currentPageIndicatorTintColor = .lightGray
//
//            productImagesScrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: maxHeight)
//            productImagesScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(images.count), height: maxHeight)
//            productImagesScrollView.bounces = false
//
//            for (index,image) in images.enumerated() {
//                imageView = UIImageView(image: image)
//                imageView.contentMode = .scaleToFill
//
//                let ratio = image.size.width / image.size.height
//                var newHeight = UIScreen.main.bounds.width / ratio
//
//                if newHeight < UIScreen.main.bounds.height / 2 {
//                    newHeight = UIScreen.main.bounds.height / 2
//                } else if newHeight > 800 {
//                    newHeight = UIScreen.main.bounds.height * 0.8
//                }
//
//                imageHeight.append(newHeight)
//
//                imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: newHeight)
//                imageView.frame.origin.x = UIScreen.main.bounds.width * CGFloat(index)
//
//                productImagesScrollView.addSubview(imageView)
//            }
//        }
    
    func downloadImages(completion: @escaping ([UIImage]) -> ()) {
        
        guard let photos = product?.photo else { return }
        var images = [UIImage]()
        
        //DispatchQueue.global().async {
            //let semaphore = DispatchSemaphore(value: 0)
            
            for url in photos {
                if let url = URL(string: url) {
                    let resource = ImageResource(downloadURL: url)
                    KingfisherManager.shared.retrieveImage(with: resource) { result in
                        switch result {
                        case .success(let value):
                            images.append(value.image)
                            //semaphore.signal()
                        case .failure(let error):
                            print(error)
                            //semaphore.signal()
                        }
                    }
                    //semaphore.wait()
                }
            }
            completion(images)
       // }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 상단 빈공간 재조정
        //top.constant = (UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height ?? 0.0))
    }
}


extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "otherProduct", for: indexPath) as? OtherProductCollectionViewCell else { return UICollectionViewCell() }
        print("1")
        return cell
    }
}

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("2")
        return CGSize(width: Int(UIScreen.main.bounds.width - 100) / 2, height: 200)
    }
}

extension ProductDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        
        let statusHeight = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0.0
        
        let contentOffsetY = statusHeight + navigationBarHeight
        
        //top.constant = scrollView.contentOffset.y + contentOffsetY > 0 ? scrollView.contentOffset.y + contentOffsetY * 2 : contentOffsetY
        
        
        // 세로 스크롤 막기
        //        if scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0 {
        //            scrollView.contentOffset.y = 0
        //        }
        
        //        productPageControl.currentPage = Int(floor(scrollView.contentOffset.x / UIScreen.main.bounds.width))
        
        
        //mainScrollView.contentOffset.y = testScrollView.contentOffset.y
        
        
        //
        //        mainScrollView.frame.origin.y = scrollView.contentOffset.y > 0 ? -scrollView.contentOffset.y : 0
        
        //\print(testScrollView.contentOffset.y)
    }
}
