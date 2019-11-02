//
//  NotificationTableViewCell.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 14/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import WebKit
class NotificationTableViewCell: UITableViewCell {

    @IBOutlet var notiImage: UIImageView!
    @IBOutlet var notiTitleLbl: UILabel!
    @IBOutlet var notiWebView: WKWebView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
