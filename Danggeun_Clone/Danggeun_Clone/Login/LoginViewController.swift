//
//  LoginViewController.swift
//  Danggeun_Clone
//
//  Created by PKW on 2022/05/08.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var startButton: UIButton!
    //var user: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
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
