//
//  MyCartTVC.swift
//  MetroCRM
//
//  Created by Ecsion Research Labs Pvt. Ltd. on 01/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RoseLib

class MyCartTVC: UITableViewController {

    @IBOutlet var footerView: UIView!
    var jsonResponse = NSArray ()
    var finalPrice = ""
    var priceIdArray = [Double]()
    let button = UIButton.init(type: .system)
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
       // self.tableView.tableFooterView = UIView()
        tableView.backgroundView = UIImageView(image: UIImage(named: "gradientbg.jpg"))
        tableView.register(UINib(nibName: "MyCartTableViewCell", bundle: nil), forCellReuseIdentifier: "cartList")
        tableView.estimatedRowHeight = 157
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    override func viewWillAppear(_ animated: Bool) {
         callApiToGetWishList()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        
        //self.navigationController?.view.backgroundColor = .blue
    }
    func footerTableView() {
        //let button=UIButton.init(type: .system)
        button.setTitle("PROCEED TO PAYMENT(RM \(self.finalPrice))", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(didClickProceedPayment), for: .touchUpInside)
        button.frame.size = CGSize(width: self.view.frame.width - 30, height: 70)
        
        //set constrains
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            button.rightAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
            button.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
            button.leftAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
            button.heightAnchor.constraint(equalToConstant: 45).isActive = true
            // button.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        } else {
            button.rightAnchor.constraint(equalTo: tableView.layoutMarginsGuide.rightAnchor, constant: 0).isActive = true
            button.bottomAnchor.constraint(equalTo: tableView.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
            button.leftAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.leftAnchor, constant: -10).isActive = true
        }
        if (priceIdArray.count > 0) {
            button.isHidden = false
            
        } else {
            
            button.isHidden = true
            button.removeFromSuperview()
        }
        
    }
    @objc func didClickProceedPayment(sender : UIButton){
        let billingAddressVC = self.storyboard?.instantiateViewController(withIdentifier: "BillingAddressTVC") as! BillingAddressTVC
       
        billingAddressVC.amountStr = self.finalPrice
        
        self.navigationController?.pushViewController(billingAddressVC, animated: true)
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        // Make footerview so it fill up size of the screen
//        // The button is aligned to bottom of the footerview
//        // using autolayout constraints
//        self.tableView.tableFooterView = nil
//        self.footerView.frame = CGRect(x:0, y:self.tableView.frame.size.height - self.tableView.contentSize.height - self.footerView.frame.size.height, width:self.view.frame.size.width, height:50)
//        self.tableView.tableFooterView = self.footerView
//    }
    func callApiToGetWishList() {
        var user_Id = String()
        if let userId = UserDefaults.standard.string(forKey: "userlogin_id") {
            user_Id = userId
        }
        let paramDic = [
            "user_id" : user_Id,
            ] as [String : Any]
        
        do {
            showHUD(message: "Loading")
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.GetOrderListCheckoutItems, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            self.jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                            print(self.jsonResponse)
                            
                            DispatchQueue.main.async {
                                self.hideHUD()
                                print(responseStr)
                                if self.jsonResponse.count == 0 {
                                    self.tableView.backgroundView = UIImageView(image: UIImage(named: "no_voucher_mobile"))
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartList", for: indexPath) as! MyCartTableViewCell
        
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(didClickDelete(_:)), for: .touchUpInside)
        
        if let title = dic["voucher_name"] {
            cell.voucherTitle.text = title as? String
        } else {
            cell.voucherTitle.text = ""
        }
        if let original_price = dic["original_price"] {
            //cell.originalPriceLbl.text = original_price as? String
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: String(original_price as! Float))
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            
            let attributeStringOne: NSMutableAttributedString =  NSMutableAttributedString(string: "Original Price: ")
            let combinedAttributedString = attributeStringOne.getAttributedStringByAppending(attributedString: attributeString)
            cell.originalPrice.attributedText = combinedAttributedString
            
        } else {
            cell.originalPrice.text = ""
        }
        if let discount_price = dic["discount_price"] {
            cell.discountPrice.text = "Discount Price: RM \(discount_price as! Float)"
        } else {
            cell.discountPrice.text = ""
        }
        if let sst = dic["sst_amount"] {
            cell.sstLbl.text = "SST :\(sst)"
        } else {
            cell.sstLbl.text = ""
        }
        if let promocode = dic["Promocode_name"] {
            cell.promoCOdeLbl.text = "Promo Code :\(promocode)"
        } else {
            cell.promoCOdeLbl.text = ""
        }
        if let totalPrice = dic["total_amount"] {
            cell.totalProceLbl.text = "Total Price : RM \(totalPrice)"
        } else {
            cell.totalProceLbl.text = ""
        }
        let finalPriceVal = dic["TotalAmount"]
        self.finalPrice = String(format: "%.2f", finalPriceVal as! Double)
        //self.finalPrice = "\(finalPriceVal!)"
        var imageUrl = ""
        if let imageStr = dic["Voucher_ImgPath"] {
            imageUrl = "\(Url.imageBaseUrl)\(imageStr)"
        }
        
        cell.checkBoxButton.addTarget(self, action: #selector(didClickSelectCart(_:)), for: .touchUpInside)
        cell.checkBoxButton.tag = indexPath.row
        
        cell.voucherImage.image = UIImage(named: "NoImageFound")  //set placeholder image first.
        
        cell.voucherImage.downloaded(from: imageUrl)
        cell.voucherImage.contentMode = .scaleToFill
        
        cell.backgroundColor = UIColor.clear
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 150))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 5.0
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        
        //self.footerTableView()
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 157
    }
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        var footerView : UIView?
//
//        footerView = UIView(frame: CGRect(x:0, y:100, width:tableView.frame.size.width, height:50))
//
//        footerView?.backgroundColor = UIColor.black
//
//
//
//        let dunamicButton = UIButton(type: UIButton.ButtonType.system)
//
//        dunamicButton.backgroundColor = UIColor.green
//
//        dunamicButton.setTitle("Button", for: .normal)
//
//        dunamicButton.frame = CGRect(x:0, y:0, width:100,height: 50)
//
//        dunamicButton.addTarget(self, action: "buttonTouched:", for: UIControl.Event.touchUpInside)
//
//
//
//        footerView?.addSubview(dunamicButton)
//
//
//
//        return footerView
//    }
    @objc private func didClickSelectCart(_ sender: UIButton?) {
        let dic = self.jsonResponse[sender!.tag] as! NSDictionary
        let amount = dic["discount_price"]
        sender!.isSelected = !sender!.isSelected
        if (sender!.isSelected) {
            //priceIdArray.add(amount as Any)
            priceIdArray.append(amount as! Double)
            
        } else {
            if let index = priceIdArray.index(of:amount as! Double) {
                priceIdArray.remove(at: index)
            }
//            if (priceIdArray.contains(amount as! Double)) {
//                priceIdArray.
//                priceIdArray.remove(at: Int(amount as! Double))
//
//            }
        }
        var total: Double = 0.0
        for str in priceIdArray {
            total += Double(str)
        }
        print("price \(priceIdArray)")
        self.finalPrice = String(format: "%.2f", total)
        footerTableView()
        //self.finalPrice = "\(total)"
    }
    @objc private func didClickDelete(_ sender: UIButton?) {
        let dic = jsonResponse[(sender?.tag)!] as! NSDictionary
        // Create the alert controller
        let alertController = UIAlertController(title: "Confirm", message: "Are you sure to delete this item from cartList ?", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.callDeleteCartApi(wl_Id: dic["orderid"] as! Int)
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
        
        //callApiToDeleteWishList(wl_Id: dic["wl_id"] as! Int)
    }
    func callDeleteCartApi (wl_Id : Int) {
        let paramDic = [
            "orderid" : wl_Id,
            ] as [String : Any]
        
        do {
            showHUD(message: "Loading")
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.DeleteOrderList, bodyData: data, completionHandler: {
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
extension NSMutableAttributedString{
    func getAttributedStringByAppending(attributedString:NSMutableAttributedString) -> NSMutableAttributedString{
        let newAttributedString = NSMutableAttributedString()
        newAttributedString.append(self)
        newAttributedString.append(attributedString)
        return newAttributedString
    }
}


