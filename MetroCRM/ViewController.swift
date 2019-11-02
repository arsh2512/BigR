//
//  ViewController.swift
//  MetroCRM
//
//  Created by Apple on 16/03/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RoseLib

class ViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var userEmail: UITextField!
    var activeField : UITextField! = UITextField()
    var keyboardClass : KeyboardClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "user_fistname") != nil {
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tab")
                self.present(vc!, animated: true, completion: nil)
            }
    
        }
        

        userName.delegate = self
        userEmail.delegate = self
        
        keyboardClass = KeyboardClass(scrollView: scrollView, activeField: activeField, view: view)
        let array : [Int] = [1,2,3,4]
        printArray(array: array)
    }
    func printArray<element>(array:[element]) {
        array.map {(print($0)) }
    }
    func addLeftImageTo(txtField: UITextField, andImage img: UIImage!){
        let leftImageView = UIImageView(frame: CGRect(x: 30, y: 0.0, width: 20, height: 20))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
        
    }

    @IBAction func loginAction(_ sender: Any) {
        if userName.text?.count == 0 || userEmail.text?.count == 0 {
            self.displayActivityAlert(title: "Incorrect Credentials")
            return
        }
        if (!userName.text .isValidEmail()) {
            self.displayActivityAlert(title: "Invalid email")
            return
        }
        
        let url = "\(Url.loginUrl)user_name=\(userName.text!)&user_password=\(userEmail.text!)"
        WebserviceManager().executeGetRequest(url: url, completionHandler: {
            data,urlResponse,error,status in
            print("status \(status)")
            if status {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                    print(jsonResponse)
                    if jsonResponse.count > 0 {
                        let dic = jsonResponse[0] as! NSDictionary
                        print("dic \(dic)")
                        UserDefaults.standard.set(dic["user_fistname"], forKey: "user_fistname")
                        UserDefaults.standard.set(dic["userlogin_id"], forKey: "userlogin_id")
                        UserDefaults.standard.set(dic["role_id"], forKey: "role_id")
                        UserDefaults.standard.set(dic["user_id"], forKey: "user_id")
                        UserDefaults.standard.set(dic["email_id"], forKey: "email_id")
//                        if let mobNo = dic["mobile_no"] {
//                            UserDefaults.standard.set(mobNo, forKey: "mobile_no")
//                        }
                        self.afterLoginApI(login_id: dic["userlogin_id"] as! Int, updated_by: dic["email_id"] as! String)
                    } else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Login Error", message: "Incorrect credential", preferredStyle: UIAlertController.Style.alert)
                            
                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            
                            // show the alert
                            self.present(alert, animated: true, completion: nil)
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
    func afterLoginApI(login_id : Int, updated_by : String ) {
        
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy hh:mm a"
            let result = formatter.string(from: date)
            //"26-03-2019 09:50 PM"
            let paramDic = [
                "last_login" : result,
                "userlogin_id" : login_id,
                "updated_by" : updated_by
                ] as [String : Any]
            
            do {
                
                let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
                WebserviceManager().executePostRequest(url: Url.afterLoginUrl, bodyData: data, completionHandler: {
                    data,urlResponse,error,status in
                    if status {
                        //if let responseStr = String(data: data!, encoding: .utf8) {
                            DispatchQueue.main.async {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tab")
                                self.present(vc!, animated: true, completion: nil)
                            }
                        //}
                        
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

extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
}

extension UITextField
{
    open override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 3.0
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.masksToBounds = true
    }
    
}
extension UITextField{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}
