//
//  DealListTableViewCell.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 29/03/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RoseLib

class DealListTableViewCell: UITableViewCell {

    @IBOutlet var voucherImageView: UIImageView!
    @IBOutlet var voucherTitle: UILabel!
    @IBOutlet var originalPriceLbl: UILabel!
    @IBOutlet var discountPriceLbl: UILabel!
    @IBOutlet var boughtLbl: UILabel!
    @IBOutlet var wishListBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    @IBAction func didClickAddToWishList(_ sender: UIButton) {
        callApiTOAddItemToWishList(voucherList: sender.tag)
    }
    func callApiTOAddItemToWishList (voucherList : Int){
        
        var user_Id = String()
        if let userId = UserDefaults.standard.string(forKey: "userlogin_id") {
            user_Id = userId
        }
        var userName = String()
        if let userNameStr = UserDefaults.standard.string(forKey: "user_fistname") {
            userName = userNameStr
        }
        let paramDic = [
            "voucher_id" : (voucherList),
            "userlogin_id" : user_Id,
            "created_by" : userName,
            "item_type" : "VOUCHER"
            ] as [String : Any]
        
        do {
            
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.addWishListDetailsUrl, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                            print(jsonResponse)
                            
                            DispatchQueue.main.async {
                                let str = jsonResponse[0] as! String
                                let alert = UIAlertController(title: "", message: str, preferredStyle: UIAlertController.Style.alert)
                                
                                // add an action (button)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                self.parentViewController?.present(alert, animated: true, completion: nil)
                                self.parentViewController?.viewWillAppear(false)
                                // show the alert
                        
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController
            }
        }
        return nil
    }
}
