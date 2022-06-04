//
//  LoginViewController.swift
//  Danggeun_Clone
//
//  Created by PKW on 2022/05/08.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var startButton: UIButton!
    var user: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        getLoginUserData()
        
    }
    
    func getLoginUserData() {
        guard let loginUser = UserDefaults.standard.object(forKey: "LoginUser") as? Data else { return }
        
        let decoder = JSONDecoder()
        do {
            user = try decoder.decode(UserModel.self, from: loginUser)
        } catch {
            print("유저정보 가져오기 실패")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "start" {
            guard let vc = segue.destination as? RegionListViewController else { return }
            vc.titleText = "가입"
        } else if segue.identifier == "login" {
            guard let vc = segue.destination as? AuthPhoneNumberViewController else { return }
            vc.titleText = "로그인"
        }
    }
}
