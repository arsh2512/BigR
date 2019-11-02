//
//  RegisterBigRCardVC.swift
//  MetroCRM
//
//  Created by phonestop on 10/28/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RoseLib

class RegisterBigRCardVC: UIViewController {

    @IBOutlet var memberShipCardTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        memberShipCardTextField.layer.borderWidth = 1.0
        memberShipCardTextField.layer.borderColor = UIColor.lightGray.cgColor
        // Do any additional setup after loading the view.
    }
    

    @IBAction func didClickRegister(_ sender: Any) {
    }
    func callApi() {
   
            var user_Id = String()
            if let userId = UserDefaults.standard.string(forKey: "userlogin_id") {
                user_Id = userId
            }
            let paramDic = [
                "user_id" :user_Id,
                "card_no" : "",
                "created_by" : "",
                "active_status" : "",
                "payment_type" : ""
                ] as [String : Any]
            
            do {
                showHUD(message: "Loading")
                let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
                WebserviceManager().executePostRequest(url: Url.RegisterBigrCard, bodyData: data, completionHandler: {
                    data,urlResponse,error,status in
                    if status {
                        if let responseStr = String(data: data!, encoding: .utf8) {
                            do {
                                let dataJson = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                                
                                
                                DispatchQueue.main.async {
                                    self.hideHUD()
                                    print("responseStr \(dataJson)")
                                    if dataJson.count > 0 {
                                        let dic = dataJson[0] as! NSDictionary
                                      
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
