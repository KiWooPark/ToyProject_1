//
//  MainViewController.swift
//  Danggeun_Clone
//
//  Created by PKW on 2022/05/08.
//

import UIKit
import FirebaseFirestore
import Kingfisher
import SnapKit



class MainViewController: UIViewController {
    
    var productList = [ProductRegistrationModel]()
    
    let db = Firestore.firestore()
    
    @IBOutlet var productListTableView: UITableView!
    @IBOutlet var plusButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDB()
        
        plusButton.layer.cornerRadius = plusButton.frame.width * 0.5
       
        NotificationCenter.default.addObserver(forName: Notification.Name.reloadProductListTableView, object: nil, queue: .main) { _ in
            self.fetchDB()
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailProduct" {
            guard let row = productListTableView.indexPathForSelectedRow?.last else { return }
            guard let vc = segue.destination as? ProductDetailViewController else { return }
            vc.product = productList[row]
        }
    }
    
    @IBAction func tapPlusButton(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "popupAddProductView") as? AddProductPopupViewController else { return }
        let tabBarHeight = self.tabBarController?.tabBar.frame.height
        vc.tabBarHeight = tabBarHeight
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
    
    func fetchDB() {
        db.collection("게시글").getDocuments { snapshot, error in
            if let error = error {
                print("MainViewController - 데이터베이스 패치 에러 \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            self.productList.removeAll()
            
            for i in documents {
                guard let update = i.data()["update"] as? Timestamp else { return }
            
                self.productList.append(ProductRegistrationModel(
                    regionName: i.data()["address"] as? String ?? "",
                    phoneNumber: i.data()["phoneNumber"] as? String ?? "",
                    photo: i.data()["photos"] as? [String] ?? [""],
                    title: i.data()["title"] as? String ?? "",
                    category: i.data()["category"] as? String ?? "",
                    price: i.data()["price"] as? String ?? "",
                    content: i.data()["contents"] as? String ?? "",
                    update: NSDate(timeIntervalSince1970: TimeInterval(update.seconds))
            ))}
            
            self.productList = self.productList.sorted(by: {$0.update as Date > $1.update as Date})
            self.productListTableView.reloadData()
        }
    }

    @IBAction func test(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "LoginUser")
        print("로그아웃")
    }
}


extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as? ProductListTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = productList[indexPath.row].title
        cell.addressLabel.text = productList[indexPath.row].regionName
        cell.timeLabel.text = "\(productList[indexPath.row].update.convertTimestamp()) 전"
        cell.priceLabel.text = productList[indexPath.row].price
        cell.productImageView.kf.setImage(with: URL(string: productList[indexPath.row].photo.first ?? ""))
        
        return cell
    }
}


