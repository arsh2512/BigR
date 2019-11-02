//
//  SubmitFeedbackTVC.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 10/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RoseLib

class SubmitFeedbackTVC: UITableViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var mobNoTextField: UITextField!
    @IBOutlet var subjectTextField: UITextField!
    @IBOutlet var messageTextField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        nameTextField.delegate = self
        emailTextField.delegate = self
        mobNoTextField.delegate = self
        subjectTextField.delegate = self
        messageTextField.delegate = self
        self.title = "Send Feedback"
        
        messageTextField.text = "Enter feedback description"
        messageTextField.textColor = UIColor.lightGray
        
        if let userName = UserDefaults.standard.string(forKey: "user_fistname") {
            nameTextField.text = "\(userName)"
        }
        if let emailId = UserDefaults.standard.string(forKey: "email_id") {
            emailTextField.text = emailId
        }
        if let mobile_no = UserDefaults.standard.string(forKey: "mobile_no") {
            mobNoTextField.text = ""
        } else {
            mobNoTextField.text = "";
        }
    }
    func configureUI() {
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.borderColor = UIColor.gray.cgColor
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor.gray.cgColor
        mobNoTextField.layer.borderWidth = 1.0
        mobNoTextField.layer.borderColor = UIColor.gray.cgColor
        subjectTextField.layer.borderWidth = 1.0
        subjectTextField.layer.borderColor = UIColor.gray.cgColor
        messageTextField.layer.borderWidth = 1.0
        messageTextField.layer.borderColor = UIColor.gray.cgColor
    }

    @IBAction func didClickSubmitFeedback(_ sender: Any) {
        callAPI()
    }
    func callAPI() {
        if nameTextField.text?.count == 0 && mobNoTextField.text?.count == 0 && emailTextField.text?.count == 0 && subjectTextField.text?.count == 0 && messageTextField.text.count == 0 {
            return
        }
        var user_Id = String()
        if let userId = UserDefaults.standard.string(forKey: "userlogin_id") {
            user_Id = userId
        }  //user_id
        var user = String()
        if let userId = UserDefaults.standard.string(forKey: "user_id") {
            user = userId
        }
        var roleId = Int()
        roleId = UserDefaults.standard.integer(forKey: "role_id")
    
        let paramDic = [
            "name" : nameTextField.text!,
            "hp_no" : mobNoTextField.text!,
            "email" : emailTextField.text!,
            "subject" : subjectTextField.text!,
            "message" : messageTextField.text!,
            "created_by" : user,
            "role_id" : roleId,
            "userlogin_id" : user_Id
            ] as [String : Any]
        print(paramDic)
        do {
            showHUD(message: "Loading")
            //let data : Data =  try PropertyListSerialization.data(fromPropertyList: paramDic, format: PropertyListSerialization.PropertyListFormat.binary, options: 0)
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.AddFeedback, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    do {if let responseStr = String(data: data!, encoding: .utf8) {
                        print(responseStr)
                        DispatchQueue.main.async {
                            self.hideHUD()
                            self.navigationController?.popViewController(animated: true)
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
    
}
extension SubmitFeedbackTVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
extension SubmitFeedbackTVC : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter feedback description"
            textView.textColor = UIColor.lightGray
        }
    }
}
