//
//  FeedbackTableViewCell.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 10/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class FeedbackTableViewCell: UITableViewCell {

    @IBOutlet var subjectLabel: UILabel!
    @IBOutlet var msgLabel: UILabel!
    
    @IBOutlet var replyStatus: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
