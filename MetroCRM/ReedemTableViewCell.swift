//
//  ReedemTableViewCell.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 18/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ReedemTableViewCell: UITableViewCell {

    @IBOutlet var voucherNameLbl: UILabel!
    @IBOutlet var merchantNameLbl: UILabel!
    @IBOutlet var transactionDateLbl: UILabel!
    @IBOutlet var voucherCodeLbl: UILabel!
    @IBOutlet var reedemBeforeLbl: UILabel!
    @IBOutlet var redeemButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
