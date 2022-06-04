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
}
