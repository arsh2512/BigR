//
//  WishListTableViewCell.swift
//  MetroCRM
//
//  Created by Ecsion Research Labs Pvt. Ltd. on 01/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class WishListTableViewCell: UITableViewCell {

    @IBOutlet var wishListImage: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var voucherNum: UILabel!
    @IBOutlet var subTitleLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
