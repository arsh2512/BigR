//
//  DealsVC.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 29/03/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RoseLib
import CommonCrypto


class DealsVC: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var headerTitleLbl: UILabel!
    @IBOutlet var cartCountLabel: UILabel!
    @IBOutlet var heartCount: UILabel!
    
    var jsonResponse = NSArray ()
    var nearByJsonResponse = NSArray ()
    var cartCount = String ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.heartCount.isHidden = true
    
        cartCountLabel.layer.borderColor = UIColor.white.cgColor
        cartCountLabel.layer.borderWidth = 1.5
        
        heartCount.layer.borderColor = UIColor.white.cgColor
        heartCount.layer.borderWidth = 1.5
        
        //tableView.register(CollectionDealsTableViewCell.self, forCellReuseIdentifier: "collectionCell")
        tableView.register(UINib(nibName: "DealListTableViewCell", bundle: nil), forCellReuseIdentifier: "DealList")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        callApiToDiscoverNewDeals()
        callApiToGetNearByDeals()
        // callApiCartCount()
        callApiToGetUserData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func callApiToDiscoverNewDeals() {
        var user_Id = String()
        if let userId = UserDefaults.standard.string(forKey: "userlogin_id") {
        user_Id = userId
        }
        let paramDic = [
            "userlogin_id" : user_Id,
            ] as [String : Any]
        
        do {
            //self.showHUD(message: "Loading")
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.getDealsList, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            self.jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                            print(self.jsonResponse)
                            
                            DispatchQueue.main.async {
                                //print(responseStr)
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
    func callApiCartCount() {
        var user_Id = String()
        if let userId = UserDefaults.standard.string(forKey: "userlogin_id") {
            user_Id = userId
        }
        let paramDic = [
            "user_id" : user_Id,
            ] as [String : Any]
        
        do {
            //self.showHUD(message: "Loading")
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.GetOLCountByUserloginId, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            let responseJson = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                            print("res \(responseJson)")
                            
                            DispatchQueue.main.async {
                                let dic = responseJson.firstObject as! NSDictionary
                                self.cartCountLabel.text = "\(dic["product_qty"] ?? "0")"
                         
                                
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
    func callApiToGetUserData() {
        var user_Id = String()
        if let userId = UserDefaults.standard.string(forKey: "userlogin_id") {
            user_Id = userId
        }
        let paramDic = [
            "userlogin_id" :user_Id
            ] as [String : Any]
        
        do {
            //showHUD(message: "Loading")
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.GetUserMobileDashboardData, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            let dataJson = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                            
                            
                            DispatchQueue.main.async {
                                //self.hideHUD()
                                print("responseStr \(dataJson)")
                                if dataJson.count > 0 {
                                    let dic = dataJson[0] as! NSDictionary
                                    
                                    self.heartCount.text = "\(dic["wish_count"] as! Int)"
                                    self.heartCount.isHidden = false
                                    
                                    self.cartCountLabel.text = "\(dic["cart_count"] as! Int)"
                                }
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
    @IBAction func didClickwishList(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "WishListTVC") as! WishListTVC
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    @IBAction func didiClickCartList(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyCartTVC") as! MyCartTVC
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    func callApiToGetNearByDeals() {
        var user_Id = String()
        if let userId = UserDefaults.standard.string(forKey: "userlogin_id") {
            user_Id = userId
        }
        let paramDic = [
            "userlogin_id" : user_Id,
            "state_id" : "4"
            ] as [String : Any]
        
        do {
              self.showHUD(message: "Loading")
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.getNearByDeals, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            self.nearByJsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                            //print(self.nearByJsonResponse)
                            
                            DispatchQueue.main.async {
                                self.hideHUD()
                                //print(responseStr)
                                
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

    @IBAction func didClickVoucherDetails(_ sender: UIButton) {
        if sender.tag == 0 {
            CallGetVoucherMerchandiseDetails(voucherCatId: 5)
        } else if sender.tag == 1 {
            CallGetVoucherMerchandiseDetails(voucherCatId: 10)
        } else if sender.tag == 2 {
            CallGetVoucherMerchandiseDetails(voucherCatId: 2)
        } else if sender.tag == 3 {
            CallGetVoucherMerchandiseDetails(voucherCatId: 15)
        } else if sender.tag == 4 {
            CallGetVoucherMerchandiseDetails(voucherCatId: 1)
        } else if sender.tag == 5 {
            CallGetVoucherMerchandiseDetails(voucherCatId: 14)
        } else if sender.tag == 6 {
            CallGetVoucherMerchandiseDetails(voucherCatId: 16)
        } else if sender.tag == 7 {
            CallGetVoucherMerchandiseDetails(voucherCatId: 0)
        }
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
                            
                            DispatchQueue.main.async {
                                self.hideHUD()
                                if responseJson.count > 0 {
                                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "DealVoucherTVC") as! DealVoucherTVC
                                    secondViewController.jsonResponse = responseJson
                                    secondViewController.voucherId = voucherCatId
                                    self.navigationController?.pushViewController(secondViewController, animated: true)
                                } else {
                                     self.displayActivityAlert(title: "No deals found")
                                }
                                
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
extension DealsVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
           return 1
        }
        else if section == 1 {
            
            
            return jsonResponse.count >= 2 ? 2 : jsonResponse.count
        }
        else {
            return nearByJsonResponse.count >= 2 ? 2 : nearByJsonResponse.count
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerViewMain = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        headerViewMain.backgroundColor = UIColor.white
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 0, width: headerViewMain.frame.width - 60, height: 20)
        label.text = "Notification Times"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textColor = UIColor.init(red: 60/255.0, green: 123/255.0, blue: 231/255.0, alpha: 1)

        headerViewMain.addSubview(label)
        
        let button = UIButton()
        button.setTitleColor(UIColor.red, for: .normal)
        button.frame = CGRect(x:headerViewMain.frame.width-70, y:0, width:65, height: 20)
        button.tag = section
        button.setTitle("View All >", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(didClickViewAll(_:)), for: .touchUpInside)
        
        headerViewMain.addSubview(button)
        
        if section == 0 {
            return nil
        }
        else if section == 1 {
            label.text = "Discover New Deals"
            return headerViewMain
        }
        else {
            label.text = "Near by Deals"
           return headerViewMain
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic : NSDictionary = indexPath.section == 1 ? self.jsonResponse[indexPath.row] as! NSDictionary : self.nearByJsonResponse[indexPath.row] as! NSDictionary
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "DealsDetailsTVC") as! DealsDetailsTVC
        if let wishList = dic["WL_Exists"] as? Bool {
            secondViewController.wished = wishList
        }
        secondViewController.voucherId = dic["Voucher_Id"] as! Int
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
    }
    @objc func didClickViewAll(_ sender: UIButton) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "VoucherListTableViewController") as! VoucherListTableViewController
        
        secondViewController.jsonResponse = sender.tag == 1 ? self.jsonResponse : self.nearByJsonResponse
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 20.0
        }
        else {
           return 20.0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var dic = NSDictionary()
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DealsCell
            cell.foodBtn.alignVertical()
            cell.travelBtn.alignVertical()
            cell.electronicsBtn.alignVertical()
            cell.sportsBtn.alignVertical()
            cell.beautyBtn.alignVertical()
            cell.gamesBtn.alignVertical()
            cell.carsBtn.alignVertical()
            cell.othersBtn.alignVertical()
            return cell
        }
        else if indexPath.section == 1 {
            dic = jsonResponse[indexPath.row] as! NSDictionary
            
        } else {
            dic = nearByJsonResponse[indexPath.row] as! NSDictionary
        }
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
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
             return 12.0
        }
        return 0.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
           return 193
        }
        else if indexPath.section == 1 {
            return 107
        }
        else {
           return 107
        }
        
    }
    
}
extension UIButton {
    func alignVertical(spacing: CGFloat = 6.0) {
        guard let imageSize = self.imageView?.image?.size,
            let text = self.titleLabel?.text,
            let font = self.titleLabel?.font
            else { return }
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: font])
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0;
        self.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
    }
}


