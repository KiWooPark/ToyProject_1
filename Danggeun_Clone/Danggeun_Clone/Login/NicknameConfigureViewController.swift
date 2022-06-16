//
//  NicknameConfigureViewController.swift
//  Danggeun_Clone
//
//  Created by PKW on 2022/05/10.
//

import UIKit
import FirebaseFirestore
import CoreLocation
import BSImagePicker

class NicknameConfigureViewController: UIViewController {
    
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var nicknameCheckLabel: UILabel!
    @IBOutlet var okButton: UIButton!
    @IBOutlet var profileImageView: UIImageView!
    
    var address: String?
    var phoneNumber: String?
    var lat: Double?
    var lon: Double?
    
    let imagePicker = ImagePickerController()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.image = UIImage(named: "user")
        profileImageView.contentMode = .scaleToFill
        profileImageView.layer.cornerRadius = profileImageView.frame.width * 0.5
        
        okButton.isEnabled = false
        nicknameTextField.addTarget(self, action: #selector(nicknameFieldDidChange), for: .editingChanged)
        nicknameTextField.layer.borderColor = UIColor.red.cgColor
        nicknameTextField.layer.borderWidth = 1.0
    }

    @IBAction func tapNicknameButton(_ sender: Any) {
        createUser()
    }
    
    @IBAction func addProfileImageButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "닫기", style: .cancel)
        let deleteProfileImage = UIAlertAction(title: "프로필 사진 삭제", style: .destructive) { _ in
            self.profileImageView.image = UIImage(named: "user")
        }
        let add = UIAlertAction(title: "앨범에서 선택", style: .default) { _ in
            self.imagePicker.modalPresentationStyle = .fullScreen
            self.imagePicker.settings.selection.max = 1
            self.imagePicker.settings.theme.selectionStyle = .checked
            self.imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
            self.imagePicker.settings.theme.selectionFillColor = .black
            self.imagePicker.doneButton.tintColor = .black
            self.imagePicker.doneButtonTitle = "확인"
            self.imagePicker.cancelButton.tintColor = .black
            
            self.presentImagePicker(self.imagePicker) { asset in
                print("선택")
            } deselect: { asset in
                print("선택 해제")
            } cancel: { assets in
                print("취소")
            } finish: { assets in
                let image = assets[0].resizeImage(size: CGSize(width: 200, height: 200))
                self.profileImageView.image = image
                self.imagePicker.deselect(asset: assets[0])
            }
        }
        
        if profileImageView.image == UIImage(named: "user") {
            alert.addAction(cancel)
            alert.addAction(add)
        } else {
            alert.addAction(cancel)
            alert.addAction(add)
            alert.addAction(deleteProfileImage)
        }
        
        present(alert, animated: true)
    }
    
    
    func createUser() {
        let profileImage = profileImageView.image == UIImage(named: "user") ? nil : profileImageView.image
        
        FirebaseStorageManager.uploadImage(image: profileImage, position: nil, uploadType: UploadType.profileImage) { url, _ in
            let url = url?.absoluteString ?? ""
            self.db.collection("유저정보").document().setData([
                "nickname": self.nicknameTextField.text ?? "",
                "phoneNumber": self.phoneNumber ?? "",
                "address": self.address ?? "",
                "latitude": self.lat ?? 0.0,
                "longitude": self.lon ?? 0.0,
                "profileImage": url
            ]) { error in
                if let error = error {
                    print("데이터 베이스 계정 생성 실패 = \(error)")
                } else {
                    // 유저 정보 유저디폴트에 저장하기
                    print("유저정보 저장 성공")

                    let userModel = UserModel(
                        address: self.address ?? "",
                        nickName: self.nicknameTextField.text ?? "",
                        phone: self.phoneNumber ?? "",
                        lat: self.lat ?? 0.0,
                        lon: self.lon ?? 0.0,
                        profileImageUrl: url)

                    let encoder = JSONEncoder()

                    if let encoded = try? encoder.encode(userModel) {
                        UserDefaults.standard.set(encoded, forKey: "LoginUser")
                    }

                    let tabbarVC = UIStoryboard(name: "Tabbar", bundle: nil)
                    let tabbarVC2 = tabbarVC.instantiateViewController(withIdentifier: "tabbar")
                    UIApplication.shared.windows.first?.rootViewController = tabbarVC2
                }
            }
        }
    }
    
    @objc func nicknameFieldDidChange() {
        guard let nickname = nicknameTextField.text else { return }
        
        if nickname.isEmpty {
            nicknameCheckLabel.text = " "
            changeBorderColorAndButtonIsEnable(textColor: .red, borderColor: UIColor.red.cgColor, isEnable: false)
        } else if nickname.count < 2 {
            nicknameCheckLabel.text = "두글자 이상 입력해주세요."
            changeBorderColorAndButtonIsEnable(textColor: .red, borderColor: UIColor.red.cgColor, isEnable: false)
        } else if nickname.count > 12 {
            nicknameCheckLabel.text = "닉네임은 12자리 이하로 해주세요."
            changeBorderColorAndButtonIsEnable(textColor: .red, borderColor: UIColor.red.cgColor, isEnable: false)
        } else if nickname.isValidNickname() {
            nicknameCheckLabel.text = "닉네임을 입력해주세요."
            changeBorderColorAndButtonIsEnable(textColor: .gray, borderColor: UIColor.black.cgColor, isEnable: true)
        } else {
            nicknameCheckLabel.text = "닉네임은 띄어쓰기 없이 한글, 영문, 숫자만 가능해요."
            changeBorderColorAndButtonIsEnable(textColor: .red, borderColor: UIColor.red.cgColor, isEnable: false)
        }
    }
    
    func changeBorderColorAndButtonIsEnable(textColor: UIColor, borderColor: CGColor, isEnable: Bool) {
        nicknameTextField.layer.borderColor = borderColor
        nicknameTextField.layer.borderWidth = 1.0
        nicknameCheckLabel.tintColor = textColor
        okButton.isEnabled = isEnable
    }
}

