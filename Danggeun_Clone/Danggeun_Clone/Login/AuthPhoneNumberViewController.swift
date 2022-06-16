//
//  AuthPhoneNumberViewController.swift
//  Danggeun_Clone
//
//  Created by PKW on 2022/05/08.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import CoreLocation

class AuthPhoneNumberViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var title2Label: UILabel!
    
    @IBOutlet var sendSMSButton: UIButton!
    @IBOutlet var signInButton: UIButton!
    
    @IBOutlet var titleStackView: UIStackView!
    @IBOutlet var authStackView: UIStackView!
    @IBOutlet var emailStackView: UIStackView!
    
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var signInNumberTextField: UITextField!
    
    let db = Firestore.firestore()
    private var verifyID: String?
    
    var titleText: String?
    var address: String?
    var lat: Double?
    var lon: Double?
    
    var isSendNumber = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackButton()
        configureLayout()
    }
    
    func configureLayout() {
        titleLabel.text = "안녕하세요!\n휴대폰 번호로 \(titleText ?? "") 해주세요."
        
        phoneNumberTextField.layer.borderWidth = 1
        phoneNumberTextField.layer.cornerRadius = 5
        phoneNumberTextField.layer.borderColor = UIColor.black.cgColor
        
        sendSMSButton.layer.borderColor = UIColor.systemGray4.cgColor
        sendSMSButton.layer.borderWidth = 1
        sendSMSButton.layer.cornerRadius = 5
        
        signInNumberTextField.layer.borderWidth = 1
        signInNumberTextField.layer.cornerRadius = 5
        signInNumberTextField.layer.borderColor = UIColor.black.cgColor
        
        signInButton.layer.cornerRadius = 5
        
        authStackView.isHidden = true
    }
    
    @IBAction func tapRequestSMSButton(_ sender: Any) {
        print("인증번호 요청")
        guard let phoneNumber = phoneNumberTextField.text else { return }
        requestSMS(phoneNumber: phoneNumber)
        
        UIView.animate(withDuration: 0.5) {
            self.titleStackView.isHidden = true
            self.authStackView.isHidden = false
            self.emailStackView.isHidden = true
            self.signInNumberTextField.becomeFirstResponder()
        }
    }
    
    func requestSMS(phoneNumber: String) {
        PhoneAuthProvider.provider().verifyPhoneNumber("+82\(phoneNumber)", uiDelegate: nil) { verificationID, error in
            if let error = error {
                print("error = \(error.localizedDescription)")
                return
            }
                    
            self.verifyID = verificationID
            print(#function,"요청 완료")
        }
    }
    
    
    // 인증 과정 거치고 넘어가기
    @IBAction func tapCheckSignInNumberButton(_ sender: Any) {
        print("인증번호 확인")
        guard let signInNumber = signInNumberTextField.text else { return }
        
        // verifyID - 인증데이터
        // signInNumber - 인증번호
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verifyID ?? "", verificationCode: signInNumber)
        
        Auth.auth().signIn(with: credential) { success, error in
            if let error = error {
                print("인증번호 에러 \(error.localizedDescription)")
                
                self.showAlert(title: "인증번호 에러", message: "인증번호를 확인해주세요.")
                return
            }
            // 데이터베이스 체크
            self.checkPhoneNumber()
        }
    }
    
    // 데이터베이스에 있는지 확인
    func checkPhoneNumber() {
        db.collection("유저정보").whereField("phoneNumber", isEqualTo: phoneNumberTextField.text ?? "").getDocuments { snapshot, error in
            if let error = error {
                print("데이터베이스 도큐먼트 가져오기 실패 \(error)")
            } else {
                if snapshot?.documents.isEmpty ?? false {
                    print("정보 없음")
                    
                    // 신규 가입
                    guard let nicknameVC =  self.storyboard?.instantiateViewController(withIdentifier: "nickname") as? NicknameConfigureViewController else { return }
                    nicknameVC.address = self.address
                    nicknameVC.phoneNumber = self.phoneNumberTextField.text ?? ""
                    nicknameVC.lat = self.lat
                    nicknameVC.lon = self.lon
                    self.navigationController?.pushViewController(nicknameVC, animated: true)
                } else{
                   
                    print("정보 있음")
                    guard let userData = snapshot?.documents.first?.data() else { return }
                    
                    let userModel = UserModel(
                        address: userData["address"] as? String ?? "",
                        nickName: userData["nickname"] as? String ?? "",
                        phone: userData["phoneNumber"] as? String ?? "",
                        lat: userData["latitude"] as? Double ?? 0.0,
                        lon: userData["longitude"] as? Double ?? 0.0,
                        profileImageUrl: userData["profileImage"] as? String ?? "")
                    
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
}

extension AuthPhoneNumberViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        // range.length = 지워진 문자 길이
        // range.location = 마지막 글자 위치
        switch textField.tag {
        case 0:
            if range.location == 0 && range.length != 0 {
                self.sendSMSButton.isEnabled = false
            } else if range.location >= 10 && range.length != 0 {
                self.sendSMSButton.isEnabled = false
            } else if range.location == 10 {
                self.sendSMSButton.isEnabled = true
                self.sendSMSButton.tintColor = .black
            }
            guard let stringRange = Range(range, in: text) else { return false }
            let updatedText = text.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 11
            
        case 1:
            print(range.location , range.length)
            if range.location == 0 && range.length != 0 {
                self.signInButton.isEnabled = false
                self.signInButton.backgroundColor = .systemGray4
                self.signInButton.tintColor = .systemGray
            } else if range.location >= 5 && range.length != 0 {
                self.signInButton.backgroundColor = .systemGray4
                self.signInButton.tintColor = .systemGray
                self.signInButton.isEnabled = false
            } else if range.location == 5 {
                self.signInButton.isEnabled = true
                self.signInButton.backgroundColor = UIColor(displayP3Red: 237/255, green: 125/255, blue: 52/255, alpha: 1)
                self.signInButton.tintColor = .white
            }
            guard let stringRange = Range(range, in: text) else { return false }
            let updatedText = text.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 6
        default:
            return false
        }
    }
}



