//
//  UserModel.swift
//  Danggeun_Clone
//
//  Created by PKW on 2022/05/09.
//

import Foundation

struct UserModel: Codable {
    var address: String
    var nickName: String
    var phone: String
    var lat: Double
    var lon: Double
    var profileImageUrl: String
    
    static func getUserData() -> UserModel {
        var result = UserModel(address: "", nickName: "", phone: "", lat: 0.0, lon: 0.0, profileImageUrl: "")
        
        if let userData = UserDefaults.standard.object(forKey: "LoginUser") as? Data {
            let decoder = JSONDecoder()
            do {
                result = try decoder.decode(UserModel.self, from: userData)
            } catch {
                print("유저정보 가져오기 실패")
            }
        }
        return result
    }
}
