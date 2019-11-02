//
//  WishListTVC.swift
//  MetroCRM
//
//  Created by Ecsion Research Labs Pvt. Ltd. on 01/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RoseLib

class WishListTVC: UITableViewController {
    var jsonResponse = NSArray ()
     
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
        self.tableView.tableFooterView = UIView()
         tableView.backgroundView = UIImageView(image: UIImage(named: "gradientbg.jpg"))
        tableView.register(UINib(nibName: "WishListTableViewCell", bundle: nil), forCellReuseIdentifier: "wishList")
        tableView.estimatedRowHeight = 89
        tableView.rowHeight = UITableView.automaticDimension
        
        //self.tableView.contentInset = UIEdgeInsets(top: 100,left: 0,bottom: 0,right: 0);
        callApiToGetWishList()

    }
    func callApiToGetWishList() {
        var user_Id = String()
        if let userId = UserDefaults.standard.string(forKey: "userlogin_id") {
            user_Id = userId
        }
        let paramDic = [
            "userlogin_id" : user_Id,
            ] as [String : Any]
        
        do {
            showHUD(message: "Loading")
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.GetWishListDetails, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            self.jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                            print(self.jsonResponse)
                            
                            DispatchQueue.main.async {
                                print(responseStr)
                                self.hideHUD()
                                if self.jsonResponse.count == 0 {
//                                    let imageView : UIImageView     = UIImageView(frame: CGRect(x: 0, y: 100, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height-50))
//                                    imageView.image = UIImage(named: "no_voucher_mobile")
                                    self.tableView.backgroundView = UIImageView(image: UIImage(named: "no_voucher_mobile"))
                                    //self.tableView.backgroundView  = imageView
                                } else {
                                    self.tableView.backgroundView = UIImageView(image: UIImage(named: "gradientbg.jpg"))
                                }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishList", for: indexPath) as! WishListTableViewCell
        if let title = dic["product_name"] {
            cell.titleLbl.text = title as? String
        } else {
            cell.titleLbl.text = ""
        }
        
        if let date = dic["transdate"] {
            cell.dateLbl.text = date as? String
        } else {
            cell.dateLbl.text = ""
        }
        if let voucher_main_category = dic["voucher_main_category"] {
            cell.subTitleLbl.text = voucher_main_category as? String
        } else {
            cell.subTitleLbl.text = ""
        }
        if let voucher_id = dic["voucher_id"] {
            cell.voucherNum.text = "\(voucher_id)"
        } else {
            cell.voucherNum.text = ""
        }
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(didClickDelete(_:)), for: .touchUpInside)
        
        var imageUrl = ""
        if let imageStr = dic["product_image"] {
            imageUrl = "\(Url.imageBaseUrl)\(imageStr)"
        }
        
        cell.wishListImage.image = UIImage(named: "NoImageFound")  //set placeholder image first.
        
        cell.wishListImage.downloaded(from: imageUrl)
        cell.wishListImage.contentMode = .scaleToFill
        
        cell.backgroundColor = UIColor.clear
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 115))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 5.0
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 121
    }
    private let kSeparatorId = 123
        private let kSeparatorHeight: CGFloat = 10
        override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if cell.viewWithTag(kSeparatorId) == nil //add separator only once
            {
                let separatorView = UIView(frame: CGRect(x:0, y:cell.frame.height - kSeparatorHeight, width:cell.frame.width, height:kSeparatorHeight))
                separatorView.tag = kSeparatorId
                separatorView.backgroundColor = UIColor.clear
                separatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
                cell.addSubview(separatorView)
            }
        }
    @objc private func didClickDelete(_ sender: UIButton?) {
        let dic = jsonResponse[(sender?.tag)!] as! NSDictionary
        let alertController = UIAlertController(title: "Confirm", message: "Are you sure to delete this item from wishList ?", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.callApiToDeleteWishList(wl_Id: dic["wl_id"] as! Int)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func callApiToDeleteWishList(wl_Id : Int) {
        let paramDic = [
            "content_id" : wl_Id,
            ] as [String : Any]
        
        do {
            showHUD(message: "Loading")
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.DeleteWishListDetails, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            self.jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                            print(self.jsonResponse)
                            
                            DispatchQueue.main.async {
                                print(responseStr)
                                self.hideHUD()
                                self.callApiToGetWishList()
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
    
}
