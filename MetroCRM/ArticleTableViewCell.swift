//
//  ArticleTableViewCell.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 28/03/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet var articleTitleLbl: UILabel!
    @IBOutlet var articleDescriptionLbl: UILabel!
    @IBOutlet var articlesLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        articlesLbl.layer.borderColor = UIColor.lightGray.cgColor
        articlesLbl.layer.borderWidth = 1
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
