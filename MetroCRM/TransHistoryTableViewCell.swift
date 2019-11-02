//
//  TransHistoryTableViewCell.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 20/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class TransHistoryTableViewCell: UITableViewCell {

    @IBOutlet var transactionNoLbl: UILabel!
    @IBOutlet var transDateLbl: UILabel!
    @IBOutlet var orderNoLbl: UILabel!
    @IBOutlet var transAmtLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
