//
//  TransactionHistoryVC.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 20/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RoseLib

class TransactionHistoryVC: UIViewController {
    var jsonResponse = NSArray ()
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 89
        tableView.rowHeight = UITableView.automaticDimension
        getUserDetails()
        
        
    }
    func getUserDetails() {
        var user_Id = String()
        if let userId = UserDefaults.standard.string(forKey: "userlogin_id") {
            user_Id = userId
        }
        let paramDic = [
            "userlogin_id" : user_Id,
            "search_param" : "",
            "start_date" : "1900-01-01",
            "end_date" : "1900-01-01"
            ] as [String : Any]
        
        do {
            self.showHUD(message: "Loading")
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.GetVoucherlistRedeemDetails, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            self.jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                            print("json \(self.jsonResponse)")
                            
                            DispatchQueue.main.async {
                                print(responseStr)
                                self.hideHUD()
                                if self.jsonResponse.count == 0 {
                                    
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
    func getUserDetailsone() {
        var user_Id = String()
        if let userId = UserDefaults.standard.string(forKey: "userlogin_id") {
            user_Id = userId
        }
        let paramDic = [
            "userlogin_id" : user_Id,
            "search_param" : "",
            "start_date" : "1900-01-01",
            "end_date" : "1900-01-01"
            ] as [String : Any]
        
        do {
            self.showHUD(message: "Loading")
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.GetOrderListRetailDetails, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            self.jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                            print("json \(self.jsonResponse)")
                            
                            DispatchQueue.main.async {
                                print(responseStr)
                                self.hideHUD()
                                if self.jsonResponse.count == 0 {
                                    
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
    func getUserDetailsTwo() {
        var user_Id = String()
        if let userId = UserDefaults.standard.string(forKey: "userlogin_id") {
            user_Id = userId
        }
        let paramDic = [
            "userlogin_id" : user_Id,
            "search_param" : "",
            "start_date" : "1900-01-01",
            "end_date" : "1900-01-01"
            ] as [String : Any]
        
        do {
            self.showHUD(message: "Loading")
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.GetRedeemPointDetails, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            self.jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                            print("json \(self.jsonResponse)")
                            
                            DispatchQueue.main.async {
                                print(responseStr)
                                self.hideHUD()
                                if self.jsonResponse.count == 0 {
                                    
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

    @IBAction func didClickSegmentControl(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
        getUserDetails()
        } else if (sender.selectedSegmentIndex == 1) {
            getUserDetailsone()
        } else {
            getUserDetailsTwo()
        }
    }
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }

}
extension TransactionHistoryVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dic = jsonResponse[indexPath.row] as! NSDictionary
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrasHis", for: indexPath) as! TransHistoryTableViewCell
      
        cell.transactionNoLbl.text =  "Transaction Number : \(dic["transaction_id"] as? String ?? "nil")"
       // let v = nullToNil(value: dic["transaction_id"])
       // cell.transactionNoLbl.text = "Transaction Number : \(nullToNil(dic["transaction_id"]))"
        cell.transDateLbl.text = "Transaction Date: \(String(describing: dic["(transaction_date)"]))"
        cell.orderNoLbl.text = "Order No : \(dic["order_no"] as! String)"
        cell.transAmtLbl.text = "Transaction Amount : \(dic["total_amount"] ?? "")"
    
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return jsonResponse.count
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
        
    }
}
