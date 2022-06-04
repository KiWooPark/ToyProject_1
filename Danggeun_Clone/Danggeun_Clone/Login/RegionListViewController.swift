//
//  RegionListViewController.swift
//  Danggeun_Clone
//
//  Created by PKW on 2022/05/08.
//

import UIKit
import CoreLocation
import SnapKit

class RegionListViewController: UIViewController {
    
    @IBOutlet var findRegionButton: UIButton!
    @IBOutlet var regionListTableView: UITableView!

    var regionList = RegionModel.regionList()
    
    var titleText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LocationManager.shared.checkLocationServicesEnabled()
        
        let location = LocationManager.shared.getCurrentLocation()
       
        LocationManager.shared.getCurrentAddress(location: location) { address in
            print("주소",address)
        }
        
        configureSearchbar()
        configureBackButton()
    }
}

extension RegionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(regionList[indexPath.row].regionName)"
        return cell
    }
}

extension RegionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RegionListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? AuthPhoneNumberViewController else { return }
        if let indexPath = regionListTableView.indexPathForSelectedRow {
            vc.titleText = "가입"
            vc.address = regionList[indexPath.row].regionName
            vc.lat = regionList[indexPath.row].lat
            vc.lon = regionList[indexPath.row].lon
        }
    }
}

extension UIViewController {
    func configureBackButton() {
        let backbutton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(tapBackButton))
        self.navigationItem.leftBarButtonItem = backbutton
    }
    
    @objc func tapBackButton() {
        print(#function)
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureSearchbar() {
        let searchBar = UISearchBar()
        let underlineView = UIView()
    
        searchBar.placeholder = "동명(읍,면)으로 검색 (ex. 서초동)"
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            
            textfield.backgroundColor = .white
            
            textfield.addSubview(underlineView)
            
            underlineView.snp.makeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
            
            underlineView.translatesAutoresizingMaskIntoConstraints = false
            underlineView.backgroundColor = .systemGray4
        }
        self.navigationItem.titleView = searchBar
    }
}
