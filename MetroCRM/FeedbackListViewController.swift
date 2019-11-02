//
//  FeedbackListViewController.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 10/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RoseLib

class FeedbackListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var jsonResponse = NSArray ()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Feedback"
        callApiForFeedback()
        // Do any additional setup after loading the view.
    }
    
    func callApiForFeedback() {
        var user_Id = String()
        if let userId = UserDefaults.standard.string(forKey: "user_id") {
            user_Id = userId
        }
        let paramDic = [
            "user_id" :user_Id
            ] as [String : Any]
        
        do {
            
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.GetFeedBackListByUser, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            self.jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                            
                            
                            DispatchQueue.main.async {
                                print(responseStr)
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
    @IBAction func didClickAddFeedback(_ sender: UIButton) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SubmitFeedbackTVC") as! SubmitFeedbackTVC
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
}
extension FeedbackListViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return jsonResponse.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "one", for: indexPath) as! FeedbackTableViewCell
        let dic = jsonResponse[indexPath.row] as! NSDictionary
        if let title = dic["subject"] {
            
            cell.subjectLabel.text = (title as! String)
        }
        if let description = dic["message"] {
            cell.msgLabel.text = description as? String
            //cell.msgLabel.layer.borderColor = UIColor.lightGray.cgColor
            cell.msgLabel.numberOfLines = 0;
            cell.msgLabel.sizeToFit()
        } else {
//            cell.articleDescriptionLbl.text = ""
        }
        if let date = dic["create_date"] {
            
            cell.dateLabel.text = (date as! String)
        }
        if let status = dic["reply_status"] as? Int {
            if status == 1 {
                cell.replyStatus.text = "Replied"
            } else {
                cell.replyStatus.text = "Feedback Status : Not Rply"

            }
        }
        
        cell.backgroundColor = UIColor.clear
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 2, y: 8, width: self.view.frame.size.width - 4, height: 150))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 5.0
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
