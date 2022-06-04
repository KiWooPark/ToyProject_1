//
//  ProductListTableViewCell.swift
//  Danggeun_Clone
//
//  Created by PKW on 2022/05/17.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var productImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
}
