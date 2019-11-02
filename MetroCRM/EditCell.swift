//
//  EditCell.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 15/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class EditCell: UITableViewCell {

    @IBOutlet var nameTextLbl: UITextField!
    @IBOutlet var dobLbl: UITextField!
    @IBOutlet var address1Lbl: UITextField!
    @IBOutlet var address2Lbl: UITextField!
    @IBOutlet var postalCOdeLbl: UITextField!
    @IBOutlet var stateLbl: UITextField!
    @IBOutlet var cityLbl: UITextField!
    @IBOutlet var mobLbl: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
