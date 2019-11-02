//
//  DealsCell.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 30/03/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class DealsCell: UITableViewCell {

    @IBOutlet var foodBtn: UIButton!
    @IBOutlet var travelBtn: UIButton!
    @IBOutlet var electronicsBtn: UIButton!
    @IBOutlet var sportsBtn: UIButton!
    @IBOutlet var beautyBtn: UIButton!
    @IBOutlet var gamesBtn: UIButton!
    @IBOutlet var carsBtn: UIButton!
    @IBOutlet var othersBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        foodBtn.imageView?.contentMode = .scaleAspectFit;
        electronicsBtn.imageView?.contentMode = .scaleAspectFit
        electronicsBtn.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20);
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
