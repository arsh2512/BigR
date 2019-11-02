//
//  RegisterPinViewController.swift
//  MetroCRM
//
//  Created by phonestop on 11/2/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RoseLib

class RegisterPinViewController: UIViewController, UITextFieldDelegate {
      var pinJson = NSArray()
    
    @IBOutlet var pin1: UITextField!
    @IBOutlet var pin2: UITextField!
    @IBOutlet var pin3: UITextField!
    @IBOutlet var pin4: UITextField!
    @IBOutlet var pin5: UITextField!
    @IBOutlet var pin6: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // textfield delegates
        pin1.delegate = self
        pin2.delegate = self
        pin3.delegate = self
        pin4.delegate = self
        pin5.delegate = self
        pin6.delegate = self
        self.pin1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.pin2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.pin3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.pin4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.pin5.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.pin6.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    
        
        
        if pinJson.count == 0 {
            self.displayActivityAlert(title: "You dont have pin registered with us. Please Create your Pin")
            self.title = "Reqister Pin"
        } else {
            
        }
        // Do any additional setup after loading the view.
    }
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case pin1:
                pin2.becomeFirstResponder()
            case pin2:
                pin3.becomeFirstResponder()
            case pin3:
                pin4.becomeFirstResponder()
            case pin4:
                pin5.becomeFirstResponder()
            case pin5:
                pin6.becomeFirstResponder()
            case pin6:
                pin6.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case pin1:
                pin1.becomeFirstResponder()
            case pin2:
                pin1.becomeFirstResponder()
            case pin3:
                pin2.becomeFirstResponder()
            case pin4:
                pin3.becomeFirstResponder()
            case pin5:
                pin4.becomeFirstResponder()
            case pin6:
                pin5.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    @IBAction func didClickVisible(_ sender: Any) {
    }
    
    @IBAction func didCLickSave(_ sender: Any) {
        callApiToRegisterPin()
    }
    func callApiToRegisterPin() {
        var user_Id = String()
        var user_fistname = String()
        if let userId = UserDefaults.standard.string(forKey: "user_id") {
            user_Id = userId
        }
        if let userId2 = UserDefaults.standard.string(forKey: "user_fistname") {
             user_fistname = userId2
        }
        let paramDic = [
            "user_id" : user_Id,
            "pin_no" : "\(pin1.text!)\(pin2.text!)\(pin3.text!)\(pin4.text!)\(pin5.text!)\(pin6.text!)",
            "created_by" : user_fistname
            ] as [String : Any]
        
        do {
            
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.AddEditTransactionPin, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            let responeJson = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                            print(responeJson)
                            
                            DispatchQueue.main.async {
                                
                                
                                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterPinViewController") as! RegisterPinViewController
                                secondViewController.pinJson = responeJson
                                self.navigationController?.pushViewController(secondViewController, animated: true)
                                
                                
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
