//
//  ReedemTVC.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 18/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RoseLib

class ReedemTVC: UITableViewController {
    
    var jsonResponse = NSArray ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let height = 64; // height of navigation bar = 44(In portait), height of status bar = 20
        tableView.frame = CGRect(x:tableView.frame.origin.x, y: CGFloat(height) ,width: tableView.frame.size.width, height: tableView.frame.size.height);
        self.automaticallyAdjustsScrollViewInsets =  false;
        self.title = "Redeem Voucher"
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 151
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
        self.tableView.tableFooterView = UIView()
        tableView.backgroundView = UIImageView(image: UIImage(named: "gradientbg.jpg"))
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callApiForNotificationList()
    }
    
    func callApiForNotificationList() {
        var user_Id = String()
        if let userId = UserDefaults.standard.string(forKey: "userlogin_id") {
            user_Id = userId
        }
        let paramDic = [
            "userlogin_id" : user_Id
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
    // MARK: - Table view data source

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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reedem", for: indexPath) as! ReedemTableViewCell
        
        if let title = dic["voucher_name"] {
            cell.voucherNameLbl.text = "Voucher Name :\(title as! String)"
        } else {
            cell.voucherNameLbl.text = ""
        }
        if let Merchant_Name = dic["Merchant_Name"] {
            cell.merchantNameLbl.text = "Merchant Name :\(Merchant_Name as! String)"
        }
        if let transaction_date = dic["transaction_date"] {
            cell.transactionDateLbl.text = "Transaction Date :\(transaction_date as! String)"
        }
        if let voucher_code = dic["voucher_code"] {
            cell.voucherCodeLbl.text = "Voucher Code :\(voucher_code as! String)"
        }
        if let enddate = dic["enddate"] {
            cell.reedemBeforeLbl.text = "Reedem Before :\(enddate as! String)"
        }
        let reedemStatus = dic["redeem_status"] as! String
        if (reedemStatus == "1") {
            cell.redeemButton.backgroundColor = UIColor (red: 194/255.0, green: 194/255.0, blue: 194/255.0, alpha: 1.0)
            cell.redeemButton.isEnabled = false
        }
        cell.redeemButton.tag = indexPath.row
        return cell
    }
    
    @IBAction func didClickRedeemBtn(_ sender: UIButton) {
        let dic : NSDictionary = self.jsonResponse[sender.tag] as! NSDictionary
        let redeemDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "RedeemDetailVC") as! RedeemDetailVC
        redeemDetailVC.voucherCOdeString = dic["voucher_code"] as! String
        redeemDetailVC.voucherImageStr = dic["promotion_image_path"] as! String
        self.navigationController?.pushViewController(redeemDetailVC, animated: true)
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
