//
//  VoucherListTableViewController.swift
//  MetroCRM
//
//  Created by Ecsion Research Labs Pvt. Ltd. on 31/03/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class VoucherListTableViewController: UITableViewController {
    var jsonResponse = NSArray ()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        //tableView.backgroundView = UIImageView(image: UIImage(named: "gradientbg.jpg"))
        tableView.register(UINib(nibName: "DealListTableViewCell", bundle: nil), forCellReuseIdentifier: "DealList")
        tableView.estimatedRowHeight = 89
        tableView.rowHeight = UITableView.automaticDimension

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func viewWillAppear(_ animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "gradientbg.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.jsonResponse.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dic = jsonResponse[indexPath.row] as! NSDictionary
        let cell = tableView.dequeueReusableCell(withIdentifier: "DealList", for: indexPath) as! DealListTableViewCell
        if let title = dic["Voucher_Name"] {
            cell.voucherTitle.text = title as? String
        } else {
            cell.voucherTitle.text = ""
        }
        if let original_price = dic["original_price"] {
            //cell.originalPriceLbl.text = original_price as? String
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: original_price as! String)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            cell.originalPriceLbl.attributedText = attributeString
            
        } else {
            cell.originalPriceLbl.text = ""
        }
        if let discount_price = dic["discount_price"] {
            cell.discountPriceLbl.text = discount_price as? String
        } else {
            cell.discountPriceLbl.text = ""
        }
        if let bought = dic["bought"] {
            cell.boughtLbl.text = "\(bought) Bought"
        } else {
            cell.boughtLbl.text = ""
        }
        if let wishList = dic["WL_Exists"] as? Bool {
            if wishList {
                cell.wishListBtn.setImage(UIImage(named: "already_in_wishlist"), for: .normal)
            }
        }
        
        var imageUrl = ""
        if let imageStr = dic["promotion_image"] {
            imageUrl = "\(Url.imageBaseUrl)\(imageStr)"
        }
        
        cell.voucherImageView.image = UIImage(named: "NoImageFound")  //set placeholder image first.
        
        cell.voucherImageView.downloaded(from: imageUrl)
        cell.voucherImageView.contentMode = .scaleToFill
    
        
        cell.backgroundColor = UIColor.clear
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 0, y: 8, width: self.view.frame.size.width, height: 107))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 0.0
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        return cell
    }
    
//    private let kSeparatorId = 123
//    private let kSeparatorHeight: CGFloat = 10
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if cell.viewWithTag(kSeparatorId) == nil //add separator only once
//        {
//            let separatorView = UIView(frame: CGRect(x:0, y:cell.frame.height - kSeparatorHeight, width:cell.frame.width, height:kSeparatorHeight))
//            separatorView.tag = kSeparatorId
//            separatorView.backgroundColor = UIColor.red
//            separatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//            cell.addSubview(separatorView)
//        }
//    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
        
    }

}
