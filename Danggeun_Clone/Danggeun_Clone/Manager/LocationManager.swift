//
//  LocationManager.swift
//  Danggeun_Clone
//
//  Created by PKW on 2022/05/08.
//

/*
 권한 설정 로직
 1. 시스템 권한 (위치서비스 on / off)
 2. on -> 요청가능 , off -> 설정 유도하기
 3. 요청 가능일때 권한 허용, 권한 거부
 
 */

import Foundation
import CoreLocation
import UIKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    var locationManager: CLLocationManager?
    
    override init() {
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        super.init()
        locationManager?.delegate = self
    }
    
    // 시스템 권한 체크
    //func checkLocationServicesEnabled(_ vc: AnyObject) {
    func checkLocationServicesEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            print(#function, "= 가능")
            let status = CLLocationManager.authorizationStatus()
            checkAuthorization(status)
        } else {
            print(#function, "= 불가능")
        }
    }
    
    // 위치 서비스 상태 체크
    func checkAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
            // 선택하지 않았을때
        case .notDetermined:
            // 앱을 사용하는 동안에 대한 위치 권한 요청
            locationManager?.requestWhenInUseAuthorization()
            // 위치 접근 시작!
            locationManager?.startUpdatingLocation()
            // 권한이 없고 거부일때
        case .restricted, .denied:
            print(#function, "= DENIED, 설정으로 유도")
            // 항상 허용일때
        case .authorizedAlways:
            print(#function, "= always")
            // 앱을 사용하는 동안에만 허용일때, 한번 허용도 여기
        case .authorizedWhenInUse:
            print(#function, "= when in use")
        @unknown default:
            print(#function, "= DEFUALT")
        }
    }
    
    // 현재 위치 가져오기
    func getCurrentLocation() -> CLLocation {
        let coordinate = CLLocation(latitude: locationManager?.location?.coordinate.latitude ?? 0, longitude: locationManager?.location?.coordinate.longitude ?? 0)
        return coordinate
    }
    
    // 현재 위치 주소
    func getCurrentAddress(location: CLLocation, completion: @escaping (String) -> ()) {
        var currentAddress = ""
        let geoCoder: CLGeocoder = CLGeocoder()
        let location: CLLocation = location
        // 한국어 주소 설정
        let locale = Locale(identifier: "Ko-Kr")
        //위경도를 통해 주소 변환
        geoCoder.reverseGeocodeLocation(location, preferredLocale: locale) { (placemarks, error) -> Void in

            guard let place = placemarks?.first else { return }
            
            if let administrativeArea: String = place.administrativeArea {
                currentAddress.append(administrativeArea + " " )}
            
            if let locality: String = place.locality {
                currentAddress.append(locality + " ")
            }
            
            completion(currentAddress)
        }
    }
}

