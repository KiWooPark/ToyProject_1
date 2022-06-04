//
//  NicknameConfigureViewController.swift
//  Danggeun_Clone
//
//  Created by PKW on 2022/05/10.
//

import UIKit
import FirebaseFirestore
import CoreLocation

class NicknameConfigureViewController: UIViewController {
    
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var nicknameCheckLabel: UILabel!
    @IBOutlet var okButton: UIButton!
    
    var address: String?
    var phoneNumber: String?
    var lat: Double?
    var lon: Double?
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        okButton.isEnabled = false
        nicknameTextField.addTarget(self, action: #selector(nicknameFieldDidChange), for: .editingChanged)
        nicknameTextField.layer.borderColor = UIColor.red.cgColor
        nicknameTextField.layer.borderWidth = 1.0
    }

    @IBAction func tapNicknameButton(_ sender: Any) {
        createUser()
    }
    
    func createUser() {
        db.collection("유저정보").document().setData([
            "nickname": self.nicknameTextField.text ?? "",
            "phoneNumber": self.phoneNumber ?? "",
            "address": self.address ?? "",
            "latitude": self.lat ?? 0.0,
            "longitude": self.lon ?? 0.0
        ]) { error in
            if let error = error {
                print("데이터 베이스 계정 셍성 실패 = \(error)")
            } else {
                // 유저 정보 유저디폴트에 저장하기
                print("유저정보 저장 성공")
                
                let userModel = UserModel(
                    address: self.address ?? "",
                    nickName: self.nicknameTextField.text ?? "",
                    phone: self.phoneNumber ?? "",
                    lat: self.lat ?? 0.0,
                    lon: self.lon ?? 0.0)
                
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
    
    @objc func nicknameFieldDidChange() {
        guard let nickname = nicknameTextField.text else { return }
        
        if nickname.isEmpty {
            nicknameCheckLabel.text = ""
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

extension String {
    /// nickname 정규식
    /// - Returns: nickname정규식과 일치한다면 true를 return한다.
    func isValidNickname() -> Bool {
        let nicknameRegEx = "[가-힣A-Za-z0-9]{1,12}"
        
        let nicknamePredicate = NSPredicate(format:"SELF MATCHES %@", nicknameRegEx)
        return nicknamePredicate.evaluate(with: self)
    }
}
