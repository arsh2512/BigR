//
//  BillingAddressTVC.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 20/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RoseLib
import CommonCrypto

class BillingAddressTVC: UITableViewController {

    @IBOutlet var nameTxtFld: UITextField!
    @IBOutlet var emailTxtFld: UITextField!
    @IBOutlet var phoneNoTxtFld: UITextField!
    @IBOutlet var addOneTxtFld: UITextField!
    @IBOutlet var addTwoTxtFld: UITextField!
    @IBOutlet var stateTxtFld: UITextField!
    @IBOutlet var cityTxtFld: UITextField!
    @IBOutlet var countryTxtFld: UITextField!
    @IBOutlet var postCodeTxtFld: UITextField!
    
    @IBOutlet var BottomView: UIView!
    
    var imageStr = String()
    var jsonArr : NSMutableArray = [" "]
    var userDetailDic = NSDictionary()
    var jsonResponse = Array<NSDictionary> ()
    var state_Id : Int = 0
    var amountStr = String()
    var orderNo = String()
    
    var cityId : Int = 0
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.BottomView.isHidden =  true
        //self.navigationController?.navigationBar.barTintColor = UIColor.blue
        
        textFieldLayout(textField: nameTxtFld)
        textFieldLayout(textField: emailTxtFld)
        textFieldLayout(textField: phoneNoTxtFld)
        textFieldLayout(textField: addOneTxtFld)
        textFieldLayout(textField: addTwoTxtFld)
        textFieldLayout(textField: postCodeTxtFld)
        
//        nameTxtFld.delegate = self
//        emailTxtFld.delegate = self
//        phoneNoTxtFld.delegate = self
//        addOneTxtFld.delegate = self
//        addTwoTxtFld.delegate = self
//        postCodeTxtFld.delegate = self
        
        phoneNoTxtFld.addDoneButtonOnKeyboard()
        postCodeTxtFld.addDoneButtonOnKeyboard()
        
        getUserDetails()
    }
    func textFieldLayout(textField: UITextField) {
        textField.layer.cornerRadius = 3
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1
        textField.layer.masksToBounds = true
        textField.textColor = UIColor.white
    }
    // MARK: - Table view data source
    func getUserDetails() {
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
            WebserviceManager().executePostRequest(url: Url.GetNormalUserDetailsbyLoginId, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            self.jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray as! [NSDictionary]
                            print("json \(self.jsonResponse)")
                            self.userDetailDic = self.jsonResponse.first!
                            
                            DispatchQueue.main.async {
                                print(responseStr)
                                self.hideHUD()
                                if let name = self.userDetailDic["user_fistname"] as? String {
                                    self.nameTxtFld.text = name
                                }
                                if let email_id = self.userDetailDic["email_id"] as? String{
                                    self.emailTxtFld.text = email_id
                                }
                                if let mobile_no = self.userDetailDic["mobile_no"] as? String {
                                    self.phoneNoTxtFld.text = mobile_no
                                }
                                if let address1 = self.userDetailDic["address1"] as? String {
                                    self.addOneTxtFld.text = address1
                                }
                                if let address2 = self.userDetailDic["address2"] as? String {
                                    self.addTwoTxtFld.text = address2
                                }
                                if let postalCode = self.userDetailDic["postcode_id"] as? Int {
                                    self.postCodeTxtFld.text = "\(postalCode)"
                                }
                                if let stateName = self.userDetailDic["state_name"] as? String {
                                    self.stateTxtFld.text = stateName
                                }
                                if let state_Id = self.userDetailDic["state_Id"] as? Int {
                                    self.state_Id = state_Id
                                }
                                if let cityName = self.userDetailDic["city_name"] as? String {
                                    self.cityTxtFld.text = cityName
                                }
                                if let countryTxtFld = self.userDetailDic["country_name"] as? String {
                                    self.countryTxtFld.text = countryTxtFld
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
    func getStateList(showPicker : Bool) {
        WebserviceManager().executeGetRequest(url: Url.GetStateDetails, completionHandler: {
            data,urlResponse,error,status in
            print("status \(status)")
            if status {
                do {
                    self.jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! Array<NSDictionary>
                    //print(self.jsonResponse)
                    if self.jsonResponse.count > 0 {
                        
                        let nameArray = self.jsonResponse.compactMap { $0["state_name"] }
                        let stateIdArr = self.jsonResponse.compactMap{ $0["state_id"] }
                        
                        if (showPicker) {
                            DPPickerManager().showPicker(title: "State List", selected: nameArray.first as? String, strings: nameArray as! [String], completion: {
                                (value, index, cancel) in
                                if (cancel) {
                                    return
                                }
                                
                                DispatchQueue.main.async {
                                    self.state_Id = stateIdArr[index] as! Int
                                    self.stateTxtFld.text = value!
                                }
                            })
                        }
                        
                    }
                }
                catch let error
                {
                    print(error)
                }
                print("status \(status)")
            } else {
                
            }
        })
    }
    func callApiToGetCity(showPicker: Bool) {
        
        let paramDic = [
            "state_id" : state_Id
            ] as [String : Any]
        
        do {
            //self.showHUD(message: "Loading")
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.GetCityListing, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            let jsonArray = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! Array<NSDictionary>
                            //print("cityNames \(jsonArray)")
                            DispatchQueue.main.async {
                                print(responseStr)
                                //self.hideHUD()
                                let nameArray = jsonArray.compactMap { $0["city_name"] }
                                let cityArr = jsonArray.compactMap { $0["city_id"] }
                               
                                if (showPicker) {
                                    DPPickerManager().showPicker(title: "City List", selected: nameArray.first as? String, strings: nameArray as! [String], completion: {
                                        (value, index, cancel) in
                                        //self.state_Id = index
                                        if (cancel) {
                                            return
                                        }
                                        DispatchQueue.main.async {
                                            self.cityTxtFld.text = value!
                                            self.cityId = cityArr[index] as! Int
                                        }
                                    })
                                }
                                
                            }
                        }
                            
                        catch let error
                        {
                            print(error)
                        }
                        
                    }
                    
                }
                
            })
        }
        catch {
            print("Unable to successfully convert NSData to NSDictionary")
        }
    }
    func callApiToAddOrderCheckOut() {
        var user_Id = String()
        if let userId = UserDefaults.standard.string(forKey: "userlogin_id") {
            user_Id = userId
        }
        let timeStamp = Date().millisecondsSince1970
        orderNo = "METRO\(user_Id)\(timeStamp)"
        //userlogin_id,user_name,ToDateTime,mobile_no,address1,address2,city_id,state_id,postcodeid,country_id,image_path,updated_by
        let paramDic = [
            "user_id" : user_Id,
            "order_no" : orderNo,
            "transaction_amount" : amountStr,
            "address1" : addOneTxtFld.text!,
            "address2" : addTwoTxtFld.text!,
            "city_id" : cityId,
            "state_id" : state_Id,
            "postcodeid" : postCodeTxtFld.text!
            ] as [String : Any]
        print("para \(paramDic)")
        do {
            self.showHUD(message: "Loading")
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.AddOrderCheckOut, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            self.jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray as! [NSDictionary]
                            
                            DispatchQueue.main.async {
                                print(responseStr)
                                self.hideHUD()
                                let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
                                paymentVC.amount = self.amountStr
                                paymentVC.email = self.emailTxtFld.text!
                                paymentVC.orderNo = self.orderNo
                                self.navigationController?.pushViewController(paymentVC, animated: true)
                                
                            }
                        }
                            
                        catch let error
                        {
                            self.hideHUD()
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
    @IBAction func cancel(_ sender: Any) {
    }
    @IBAction func submit(_ sender: Any) {
        if addOneTxtFld.text?.count == 0 || stateTxtFld.text?.count == 0 || cityTxtFld.text?.count == 0 || postCodeTxtFld.text?.count == 0 {
            self.displayActivityAlert(title: "Please fill all fields related to address information")
            return
        }
        callApiToAddOrderCheckOut()
    }
    @IBAction func didClickShowList(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            do {
                
               getStateList(showPicker: true)
                
            }; break
        case 1:
            do {
               callApiToGetCity(showPicker: true)
            }; break
         
        default: break
            
        }
        
    }
    
    @IBAction func didClickNetBanking(_ sender: Any) {
    }
    @IBAction func didClickCardPayment(_ sender: UIButton) {
    }
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
extension String {
    func sha1() -> String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}
extension BillingAddressTVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        activeField = textField
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        activeField = nil
//    }
    
}
