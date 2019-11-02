//
//  SignUpViewController.swift
//  MetroCRM
//
//  Created by Apple on 20/03/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RoseLib
class SignUpViewController: UIViewController {
    

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userConfirmPassword: UITextField!
    
    @IBOutlet var scrollView: UIScrollView!
    var activeField : UITextField! = UITextField()
    var keyboardClass : KeyboardClass!
    override func viewDidLoad() {
        super.viewDidLoad()
        placeholderPadding()
        
        userName.delegate = self
        userEmail.delegate = self
        userPassword.delegate = self
        userConfirmPassword.delegate = self
        
         keyboardClass = KeyboardClass(scrollView: scrollView, activeField: activeField, view: view)
    }
    @IBAction func signUpClicked(_ sender: Any) {
        if userName.text?.count == 0 || userPassword.text?.count == 0 || userEmail.text?.count == 0 || userConfirmPassword.text?.count == 0 {
            self.displayActivityAlert(title: "All fields are mandatory")
            return
        }
        if (!userEmail.text .isValidEmail()) {
            self.displayActivityAlert(title: "Invalid email")
            return
            }  
        if (userPassword.text != userConfirmPassword.text) {
            self.displayActivityAlert(title: "Password did not match")
        }
        self.callAPI()
    }
    func callAPI() {
        let paramDic = [
            "name" : userName.text!,
            "email_id" : userEmail.text!,
            "user_password" : userConfirmPassword.text!,
            "device_type" : "IOS",
            "device_id" : "1234567",
            "fcm_id" : "1234567"
        ]
        
        do {
            //let data : Data =  try PropertyListSerialization.data(fromPropertyList: paramDic, format: PropertyListSerialization.PropertyListFormat.binary, options: 0)
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.signUpUrl, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                        let str = jsonResponse[0] as! String
                        print(jsonResponse[0])
                        
                        if jsonResponse.count > 0 {
                            if str == "Username already exists" {
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "Signup Error", message: "Username already exists", preferredStyle: UIAlertController.Style.alert)
                                    
                                    // add an action (button)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                    
                                    // show the alert
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                            } else {
                                DispatchQueue.main.async {
                                    
                                    let alertController = UIAlertController(title: "Successful Message", message: "Thank you for sign up. Please check your email to activate your account", preferredStyle: .alert)
                                    
                                    // Create the actions
                                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                        UIAlertAction in
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
                                        self.present(vc!, animated: true, completion: nil)
                                    }
                    
                                    // Add the actions
                                    alertController.addAction(okAction)
                                    
                                    // Present the controller
                                    self.present(alertController, animated: true, completion: nil)
                                    
                                    
                                }
                            }
                            
                        }
                        
                    }
                    
                    catch let error
                    {
                        print(error)
                    }
                    
                    
                } else {
                    
                }
                
            })
        }
        catch {
            print("Unable to successfully convert NSData to NSDictionary")
        }
        
    }
    func placeholderPadding() {
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.userName.frame.height))
        self.userName.leftView = paddingView
        userName.leftViewMode = UITextField.ViewMode.always
        let paddingViewEmail = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.userEmail.frame.height))
        self.userEmail.leftView = paddingViewEmail
        userEmail.leftViewMode = UITextField.ViewMode.always
        let paddingViewPassword = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.userPassword.frame.height))
        self.userPassword.leftView = paddingViewPassword
        userPassword.leftViewMode = UITextField.ViewMode.always
        let paddingViewConfirm = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.userConfirmPassword.frame.height))
        self.userConfirmPassword.leftView = paddingViewConfirm
        userConfirmPassword.leftViewMode = UITextField.ViewMode.always
        
    }
    
    @IBAction func didClickTerms(_ sender: UIButton) {
        if let url = URL(string: "http://www.bigr.asia/frmTermnCondition.aspx") {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
extension SignUpViewController : UITextFieldDelegate {
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
