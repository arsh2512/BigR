//
//  DealVoucherTVC.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 30/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RoseLib
class DealVoucherTVC: UITableViewController {
    var jsonResponse = NSArray ()
    var voucherId = Int ()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        tableView.backgroundView = UIImageView(image: UIImage(named: "gradientbg.jpg"))
        tableView.register(UINib(nibName: "DealListTableViewCell", bundle: nil), forCellReuseIdentifier: "DealList")
        tableView.estimatedRowHeight = 89
        tableView.rowHeight = UITableView.automaticDimension
    }
    override func viewWillAppear(_ animated: Bool) {
        CallGetVoucherMerchandiseDetails(voucherCatId: voucherId)
    }
    func CallGetVoucherMerchandiseDetails( voucherCatId : Int) {
        var user_Id = String()
        if let userId = UserDefaults.standard.string(forKey: "userlogin_id") {
            user_Id = userId
        }
        let paramDic = [
            "voucher_cat_id" : voucherCatId,
            "sub_cat_id" : "0",
            "search_value" : "",
            "userlogin_id" : user_Id
            ] as [String : Any]
        
        do {
            self.showHUD(message: "Loading")
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.GetVoucherMerchandiseDetailsBySearchKeyMobile, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            let responseJson = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                            print("res \(responseJson)")
                            self.jsonResponse = responseJson
                            DispatchQueue.main.async {
                                self.hideHUD()
                                self.tableView.reloadData()
                            }
                        }
                            
                        catch let error
                        {
                            print(error)
                        }
                        
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        
                    }
                }
                
            })
        }
        catch {
            print("Unable to successfully convert NSData to NSDictionary")
        }
        
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return jsonResponse.count
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
        cell.wishListBtn.tag = dic["Voucher_Id"] as! Int
        if let wishList = dic["WL_Exists"] as? Bool {
            if wishList {
                cell.wishListBtn.setImage(UIImage(named: "already_in_wishlist"), for: .normal)
            } else {
                cell.wishListBtn.setImage(UIImage(named: "wishlist"), for: .normal)
            }
        }
        
        var imageUrl = ""
        if let imageStr = dic["promotion_image"] {
            imageUrl = "\(Url.imageBaseUrl)\(imageStr)"
        }
        
        cell.voucherImageView.image = UIImage(named: "NoImageFound")  //set placeholder image first.
        //cell.voucherImageView.contentMode = .scaleAspectFit
        cell.voucherImageView.downloaded(from: imageUrl)
        cell.voucherImageView.contentMode = .scaleToFill
        
        cell.backgroundColor = UIColor.clear
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 0, y: 8, width: self.view.frame.size.width, height: 98))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 5.0
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
}
