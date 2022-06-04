//
//  Region.swift
//  Danggeun_Clone
//
//  Created by PKW on 2022/05/08.
//

import Foundation


struct RegionModel {
    var regionName: String
    var lat: Double
    var lon: Double
    
    static func regionList() -> [RegionModel] {
        return [
            RegionModel(regionName: "서울", lat: 1.1, lon: 0.0),
            RegionModel(regionName: "경기도", lat: 2.2, lon: 0.0),
            RegionModel(regionName: "강원도", lat: 3.3, lon: 0.0),
            RegionModel(regionName: "충청남도", lat: 4.4, lon: 0.0),
            RegionModel(regionName: "충청북도", lat: 5.5, lon: 0.0),
            RegionModel(regionName: "전라남도", lat: 6.6, lon: 0.0),
            RegionModel(regionName: "인천광역시", lat: 7.7, lon: 0.0),
            RegionModel(regionName: "전라북도", lat: 8.8, lon: 0.0),
            RegionModel(regionName: "부산", lat: 9.9, lon: 0.0),
            RegionModel(regionName: "제주도", lat: 10.10, lon: 0.0)
        ]
    }
}
