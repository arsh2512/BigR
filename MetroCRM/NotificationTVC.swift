//
//  NotificationTVC.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 14/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RoseLib
import WebKit

class NotificationTVC: UITableViewController {
    
    var jsonResponse = NSArray ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
        // self.tableView.tableFooterView = UIView()
        tableView.backgroundView = UIImageView(image: UIImage(named: "gradientbg.jpg"))
        
        callApiForNotificationList()
        self.tableView.alwaysBounceVertical = false
    }
    
    func callApiForNotificationList() {
        var role_Id = String()
        if let roleId = UserDefaults.standard.string(forKey: "role_id") {
            role_Id = roleId
        }
        let paramDic = [
            "notification_id" : 9,
            "role_id" : role_Id,
            "search_param" : ""
            ] as [String : Any]
        
        do {
            self.showHUD(message: "")
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.GetemailblastingList, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            self.jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                            
                            DispatchQueue.main.async {
                                print(responseStr)
                                self.hideHUD()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "notification", for: indexPath) as! NotificationTableViewCell
        
        if let title = dic["notification_title"] {
            cell.notiTitleLbl.text = title as? String
        } else {
            cell.notiTitleLbl.text = ""
        }
        if let notification_summary = dic["notification_summary"] {
            let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
            let userScript = WKUserScript(source: jscript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            let wkUController = WKUserContentController()
            wkUController.addUserScript(userScript)
            let wkWebConfig = WKWebViewConfiguration()
            wkWebConfig.userContentController = wkUController
            let webView = WKWebView(frame: cell.notiWebView.frame, configuration: wkWebConfig)
            webView.loadHTMLString(notification_summary as! String, baseURL: nil)
            cell.addSubview(webView)
            //Till here
            cell.notiWebView.isHidden = true
           // cell.notiWebView.loadHTMLString(notification_summary as! String, baseURL: nil)
        } else {
            //cell.notiTitleLbl.text = ""
        }
        
        cell.backgroundColor = UIColor.clear
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 100))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 5.0
        whiteRoundedView.backgroundColor = UIColor.white
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
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
