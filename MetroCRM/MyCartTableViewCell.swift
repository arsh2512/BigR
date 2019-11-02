//
//  MyCartTableViewCell.swift
//  MetroCRM
//
//  Created by Ecsion Research Labs Pvt. Ltd. on 01/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class MyCartTableViewCell: UITableViewCell {

    @IBOutlet var voucherTitle: UILabel!
    @IBOutlet var voucherImage: UIImageView!
    @IBOutlet var originalPrice: UILabel!
    @IBOutlet var discountPrice: UILabel!
    @IBOutlet var sstLbl: UILabel!
    @IBOutlet var promoCOdeLbl: UILabel!
    @IBOutlet var totalProceLbl: UILabel!
    
    @IBOutlet var checkBoxButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
