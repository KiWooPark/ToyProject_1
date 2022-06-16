//
//  Preview.swift
//  Danggeun_Clone
//
//  Created by PKW on 2022/06/05.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        let ok2 = UIAlertAction(title: "설정하러 가기", style: .default)
        alert.addAction(ok)
        alert.addAction(ok2)
        present(alert, animated: true)
    }
}





