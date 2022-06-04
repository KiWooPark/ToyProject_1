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
    
    let visualViewButton = UIButton()
    let plusViewButton = UIButton()
    let addProductStackView = UIStackView()
    let addProductButtonView = UIView()
    let addProductImageView = UIImageView()
    let addProductLabel = UILabel()
    let addProductButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDB()
        configureAddSubView()
        makeConstraints()
        
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
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        let navigation = UINavigationBarAppearance()
//        navigation.backgroundColor = .white
//        navigationController?.navigationBar.standardAppearance = navigation
//        navigationController?.navigationBar.scrollEdgeAppearance = navigation
//        navigationController?.navigationBar.isTranslucent = false
//    }
    
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

    func configureAddSubView() {
        addProductStackView.addArrangedSubview(addProductImageView)
        addProductStackView.addArrangedSubview(addProductLabel)
        addProductButtonView.addSubview(addProductStackView)
        addProductButtonView.addSubview(addProductButton)
        
        tabBarController?.view.addSubview(visualViewButton)
        tabBarController?.view.addSubview(plusViewButton)
        tabBarController?.view.addSubview(addProductButtonView)
    }
    
    func makeConstraints() {
        addProductButtonView.translatesAutoresizingMaskIntoConstraints = false
        addProductStackView.translatesAutoresizingMaskIntoConstraints = false
        addProductImageView.translatesAutoresizingMaskIntoConstraints = false
        addProductButton.translatesAutoresizingMaskIntoConstraints = false
        visualViewButton.translatesAutoresizingMaskIntoConstraints = false
        plusViewButton.translatesAutoresizingMaskIntoConstraints = false
        
        visualViewButton.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        visualViewButton.backgroundColor = .black
        visualViewButton.alpha = 0.0
        visualViewButton.isHidden = true
        visualViewButton.addTarget(self, action: #selector(tapPlusButton), for: .touchUpInside)
        
        addProductButtonView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(plusViewButton.snp.top).inset(-10)
            make.height.equalTo(40)
            make.width.equalTo(180)
        }
        
        addProductButtonView.isHidden = true
        addProductButtonView.alpha = 0.0
        addProductButtonView.backgroundColor = .white
        addProductButtonView.layer.cornerRadius = 5
        
        addProductButton.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        addProductButton.addTarget(self, action: #selector(tapAddProductButton), for: .touchUpInside)
        
        addProductStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.leading.top.bottom.equalToSuperview().inset(10)
        }
        
        addProductStackView.axis = .horizontal
        addProductStackView.distribution = .fillProportionally
        addProductStackView.alignment = .leading
        addProductStackView.spacing = 5
        
        addProductLabel.text = "내 물건 팔기"
        addProductLabel.font = UIFont.systemFont(ofSize: 16)
        addProductLabel.tintColor = .black
        
        addProductImageView.image = UIImage(named: "purchase")
        addProductImageView.contentMode = .scaleAspectFit
        
        plusViewButton.snp.makeConstraints { make in
            guard let tabBar = tabBarController?.tabBar else { return }
            make.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(tabBar.snp.top).inset(-10)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        plusViewButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusViewButton.tintColor = .white
        plusViewButton.backgroundColor = UIColor(displayP3Red: 237/255, green: 125/255, blue: 52/255, alpha: 1)
        plusViewButton.layer.cornerRadius = 0.5 * 50
        plusViewButton.addTarget(self, action: #selector(tapPlusButton), for: .touchUpInside)
        plusViewButton.adjustsImageWhenHighlighted = false
    }
    
    @objc func tapPlusButton() {
        var ishidden = visualViewButton.isHidden
    
        if ishidden {
            visualViewButton.isHidden = false
            addProductButtonView.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.visualViewButton.alpha = 0.5
                self.addProductButtonView.alpha = 1.0
                self.plusViewButton.setImage(UIImage(systemName: "xmark"), for: .normal)
                self.plusViewButton.backgroundColor = .white
                self.plusViewButton.tintColor = .black
            } completion: { _ in
                ishidden = self.visualViewButton.isHidden
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.visualViewButton.alpha = 0.0
                self.addProductButtonView.alpha = 0.0
                self.plusViewButton.setImage(UIImage(systemName: "plus"), for: .normal)
                self.plusViewButton.backgroundColor = UIColor(displayP3Red: 237/255, green: 125/255, blue: 52/255, alpha: 1)
                self.plusViewButton.tintColor = .white
            } completion: { _ in
                self.visualViewButton.isHidden = true
                self.addProductButtonView.isHidden = true
            }
        }
    }
    
    @objc func tapAddProductButton() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "addProductNavigationView") else { return }
        tapPlusButton()
        self.present(vc, animated: true)
    }
    
    
    @IBAction func test(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "LoginUser")
        print("로그아웃")
        print(tabBarController?.tabBar.frame.height)
    }

    func convertTimestamp(timeStamp: NSDate) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth] // 시간 단위 설정
        formatter.maximumUnitCount = 1 // 시간 단위를 몇개를 나타낼 것인가
        formatter.unitsStyle = .abbreviated // 단위의 가장 앞글자 약어(s, m, h, d, w 등)으로 설정

        // 한글로 변환
        var calender = Calendar.current
        calender.locale = Locale(identifier: "ko")
        formatter.calendar = calender

        let stamp = Timestamp(date: timeStamp as Date)

        // 만들어진 시간부터 지금(Date())까지 얼마만큼의 시간이 걸렸는지 계산해서 차이(difference)를 반환
        return formatter.string(from: stamp.dateValue(), to: Date()) ?? ""
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
        cell.timeLabel.text = "\(convertTimestamp(timeStamp: productList[indexPath.row].update)) 전"
        cell.priceLabel.text = productList[indexPath.row].price
        cell.productImageView.kf.setImage(with: URL(string: productList[indexPath.row].photo.first ?? ""))
        
        return cell
    }
}


