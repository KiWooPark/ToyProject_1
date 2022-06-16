//
//  ProductRegistraionViewController.swift
//  Danggeun_Clone
//
//  Created by PKW on 2022/05/17.
//

import UIKit
import BSImagePicker
import Firebase
import FirebaseFirestore
import Photos


class ProductRegistraionViewController: UIViewController, PhotosCollectionViewDelegate, CategoryDelegate {
    func changeCategoryName(categoryName: String) {
        categoryLabel.text = categoryName
    }
    
    func deletePhoto(index: Int) {
        selectedImages.remove(at: index)
        uploadImagesData.remove(at: index)
        photosCollectionView.reloadData()
    }
    
    @IBOutlet var photosCollectionView: UICollectionView!
    @IBOutlet var productTitleTextField: UITextField!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var contentPlaceholderLabel: UILabel!
    
    let imagePicker = ImagePickerController()
    let db = Firestore.firestore()
    
    var uploadAssets = [PHAsset]()
    var uploadImagesData = [Data]()
    
    var selectedAssets = [PHAsset]()
    var selectedImages = [UIImage]()
    
    var imagesURL = [String]()
    
    
    
    var user: UserModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextView.isScrollEnabled = false
        
        guard let userData = UserDefaults.standard.object(forKey: "LoginUser") as? Data else { return }
        
        let decoder = JSONDecoder()
        self.user = try? decoder.decode(UserModel.self, from: userData)
        
        contentPlaceholderLabel.text = "\(self.user?.address ?? "")에 올릴 게시글 내용을 작성해주세요.(가품 및 판매금지품목은 게시가 제한될 수 있어요."
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "category" {
            guard let vc = segue.destination as? CategoryViewController else { return }
            vc.delegate = self
            vc.selectedCategory = categoryLabel.text ?? ""
        }
    }
    
    
    @IBAction func tapBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func tapDone(_ sender: Any)  {
        var count = 0
        
        if uploadImagesData.isEmpty {
            addDocument()
        } else {
            for i in 0..<uploadImagesData.count {
                imagesURL.append("")
                FirebaseStorageManager.uploadImage(image: uploadImagesData[i],
                                                   position: i,
                                                   uploadType: UploadType.addProductImage) { url,position in
                    
                    guard let url = url else { return }
                    
                    self.imagesURL[position] = url.absoluteString
                    
                    count += 1
                    
                    if count == self.uploadImagesData.count {
                        self.addDocument()
                    }
                }
            }
        }
    }
    
    
    func addDocument() {
        guard let product = productTitleTextField.text else { return }
        guard let category = categoryLabel.text else { return }
        guard let price = priceTextField.text else { return }
        guard let content = contentTextView.text else { return }
        
        db.collection("게시글").document().setData([
            "title": product,
            "contents": content,
            "price": price,
            "category": category,
            "phoneNumber": self.user?.phone ?? "",
            "photos": imagesURL,
            "address": self.user?.address ?? "",
            "update": Date()
        ]) { error in
            if let error = error {
                print("게시글 업로드 실패 = \(error)")
            } else {
                self.dismiss(animated: true)
                NotificationCenter.default.post(name: .reloadProductListTableView, object: nil)
            }
        }
    }
}

extension ProductRegistraionViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        
        contentPlaceholderLabel.isHidden = textView.text?.count ?? 0 > 0 ? true : false
    }
}

extension ProductRegistraionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return selectedImages.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addPhotoCell", for: indexPath) as? AddPhotosCollectionViewCell else { return UICollectionViewCell() }
            cell.countLabel.text = "\(selectedImages.count)"
            
            if selectedImages.count > 0 {
                cell.countLabel.textColor = UIColor(displayP3Red: 237/255, green: 125/255, blue: 52/255, alpha: 1)
            } else {
                cell.countLabel.textColor = .black
            }
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosCell", for: indexPath) as? PhotosCollectionViewCell else { return UICollectionViewCell() }
            cell.delegate = self
            cell.deleteButton.tag = indexPath.row
            cell.selectedImageView.image = selectedImages[indexPath.row]
            cell.representativeLabel.isHidden = indexPath.row == 0 ? false : true
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension ProductRegistraionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            if selectedImages.count == 10 {
                let alert = UIAlertController(title: "알림", message: "이미지는 최대 10까지 첨부할 수 있어요", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "닫기", style: .cancel)
                alert.addAction(cancel)
                present(alert, animated: true)
            } else {
                imagePicker.modalPresentationStyle = .fullScreen
                imagePicker.settings.selection.max = 10
                imagePicker.settings.theme.selectionStyle = .numbered
                imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
                imagePicker.settings.theme.selectionFillColor = .black
                imagePicker.doneButton.tintColor = .black
                imagePicker.doneButtonTitle = "확인"
                imagePicker.cancelButton.tintColor = .black
                
                var totalCount = self.selectedImages.count
                
                presentImagePicker(imagePicker) { asset in
                    
                    if totalCount >= 10 {
                        self.imagePicker.deselect(asset: asset)
                        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "photoPopupView") as? PhotoPopupViewController else { return }
                        vc.photoCount = 10 - self.selectedImages.count
                        vc.modalPresentationStyle = .overFullScreen
                        self.imagePicker.present(vc, animated: false)
                    } else {
                        totalCount += 1
                    }
                } deselect: { asset in
                    print("선택해제")
                    totalCount -= 1
                } cancel: { assets in
                    print("취소")
                } finish: { assets in
                    print("완료")
                    
                    for asset in assets {
                        self.imagePicker.deselect(asset: asset)
                    }
                    
                    self.selectedAssets.removeAll()
                    
                    assets.forEach {
                        self.selectedAssets.append($0)
                    }
                    
                    self.convertAssetToImage(thumbnailSize: true)
                    self.convertAssetToImage(thumbnailSize: false)
                    
                    print(self.selectedAssets.count, self.selectedImages.count)
                    
                    self.photosCollectionView.reloadData()
                }
            }
        }
    }
    
    func convertAssetToImage(thumbnailSize: Bool) {
        
        let imageManager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        
        if thumbnailSize {
            // 썸네일이면
            // selectedAsset에 저장된 PHAsset 이미지 가지고 변환
            if !self.selectedAssets.isEmpty {
                for i in 0..<self.selectedAssets.count {
                    imageManager.requestImage(for: self.selectedAssets[i],
                                              targetSize: CGSize(width: 200, height: 200),
                                              contentMode: .aspectFill,
                                              options: option) { image, info in
                        if let data = image?.jpegData(compressionQuality: 0.5) {
                            if let newImage = UIImage(data: data) {
                                self.selectedImages.append(newImage)
                            }
                        }
                    }
                }
            }
        } else {
            // 썸네일이 아니면
            // uploadAssets에 저장된 PHAsset 이미지 가지고 변환
            for i in 0..<self.selectedAssets.count {
                imageManager.requestImage(for: self.selectedAssets[i],
                                          targetSize: CGSize(width: self.selectedAssets[i].pixelWidth, height: self.selectedAssets[i].pixelHeight),
                                          contentMode: .aspectFill,
                                          options: option) { image, info in
                    if let data = image?.jpegData(compressionQuality: 0.5) {
                        self.uploadImagesData.append(data)
                    }
                }
            }
        }
    }
}

extension ProductRegistraionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
        case 1:
            return UIEdgeInsets(top: 0, left: -10, bottom: 10, right: 20)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.height - 40
        let height = width
        
        return CGSize(width: width, height: height)
    }
}
