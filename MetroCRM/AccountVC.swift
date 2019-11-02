//
//  AccountVC.swift
//  MetroCRM
//
//  Created by Ecsion Research Labs Pvt. Ltd. on 26/03/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RoseLib

class AccountVC: UIViewController {

    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var voucherCountBtn: UIButton!
    @IBOutlet var reedemCountBtn: UIButton!
    @IBOutlet var myPointCountBtn: UIButton!
    @IBOutlet var myTransactionCountBtn: UIButton!
    @IBOutlet var bigRIdLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    var account = [String]()
    var accountLbl = [String]()
    var wishCount = Int()
    var cartCount = Int()
    var notificationCount = Int()
    var imageStr = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        configureData()
        callApiToGetUserData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
        //self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func configureData() {
        
        account = ["my_profile_ic_new", "mywishlist_ic_new-1", "cartNew", "redeem", "transaction_ic_new", "my_payment_ic_new", "my_payment_ic_new", "notification_ic_new", "feedback_ic_new", "feedback_ic_new", "my_payment_ic_new", "my_payment_ic_new",  "logout_ic_new"]
        
        accountLbl = ["profile", "myWishlist", "myCart", "Redeem Merchandise", "Transaction", "My Payment", "Redeem Cryto", "Notification", "Feedback", "QrPay History", "Change Pin", "Invite Friend", "Logout"]
    }
    
    func configureUI() {
        if let userName = UserDefaults.standard.string(forKey: "user_fistname") {
            nameLbl.text = "\(userName)"
        }
        
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        
        voucherCountBtn.addBorder(side: .right, color: UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0), width: 1)
        voucherCountBtn.addBorder(side: .bottom, color: UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0), width: 1)
        
        reedemCountBtn.addBorder(side: .right, color: UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0), width: 1)
        reedemCountBtn.addBorder(side: .bottom, color: UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0), width: 1)
        
        myPointCountBtn.addBorder(side: .right, color: UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0), width: 1)
        myPointCountBtn.addBorder(side: .bottom, color: UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0), width: 1)
        
        myTransactionCountBtn.addBorder(side: .right, color: UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0), width: 1)
        myTransactionCountBtn.addBorder(side: .bottom, color: UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0), width: 1)
    }
    
    func callApiToGetUserData() {
        var user_Id = String()
        if let userId = UserDefaults.standard.string(forKey: "userlogin_id") {
            user_Id = userId
        }
        let paramDic = [
            "userlogin_id" :user_Id
            ] as [String : Any]
        
        do {
            showHUD(message: "Loading")
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.GetUserMobileDashboardData, bodyData: data, completionHandler: {
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
                                    self.voucherCountBtn.setTitle("\(String(describing: dic["no_of_voucher"]!))", for: .normal)
                                    self.reedemCountBtn.setTitle("\(String(describing: dic["redeemPoints"]!))", for: .normal)
                                    self.myTransactionCountBtn.setTitle("\(String(describing: dic["trans_amount"]!))", for: .normal)
                                    if let reward = dic["rewardPoint"] as? String {
                                        self.myPointCountBtn.setTitle((reward ), for: .normal)
                                    }
                                    
                                    self.bigRIdLbl.text = "BigR ID : \(dic["membership_no"] ?? "")"
                                    self.emailLbl.text = "Email : \(dic["email_id"] ?? "")"
                                    self.cartCount = dic["cart_count"] as! Int
                                    self.wishCount = dic["wish_count"] as! Int
                                    self.notificationCount = dic["notifi_count"] as! Int
                                    
                                    
                                    if let imageSt = dic["image_path"] {
                                        self.imageStr = "\(imageSt)"
                                    }
                                    
                                    self.profileImageView.image = UIImage(named: "NoImageFound")  //set placeholder image first.
                                    self.profileImageView.downloaded(from: self.imageStr)
                                    
                                    self.collectionView.reloadData()
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
    
}
extension AccountVC : UICollectionViewDelegate, UICollectionViewDataSource {
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 1
        return 1
    }
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 2
        return account.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AccountCollectionCell
        
        cell.collectionImage.image = UIImage.init(named: account[indexPath.row])
        cell.collectionImage.contentMode = .scaleAspectFit
        if indexPath.row == 1 {
            cell.collectionLabel.text = "\(accountLbl[indexPath.row])(\(wishCount))"
        } else if indexPath.row == 2 {
            cell.collectionLabel.text = "\(accountLbl[indexPath.row])(\(cartCount))"
        } else if indexPath.row == 6 {
            cell.collectionLabel.text = "\(accountLbl[indexPath.row])(\(notificationCount))"
        } else {
            cell.collectionLabel.text = accountLbl[indexPath.row]
        }
        
        cell.contentView.layer.cornerRadius = 5.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0).cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let EditProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
            EditProfileVC.imageStr = imageStr
            self.navigationController?.pushViewController(EditProfileVC, animated: true)
        }
        else if indexPath.row == 1 {
            
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "WishListTVC") as! WishListTVC
            self.navigationController?.pushViewController(secondViewController, animated: true)
            
        } else if indexPath.row == 2 {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyCartTVC") as! MyCartTVC
            
            self.navigationController?.pushViewController(secondViewController, animated: true)
        } else if indexPath.row == 4 {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "TransactionHistoryVC") as! TransactionHistoryVC
            
            self.navigationController?.pushViewController(secondViewController, animated: true)
        } else if indexPath.row == 5 {
            DispatchQueue.main.async {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ComingSoon")
                self.navigationController?.pushViewController(secondViewController!, animated: true)
            }
        } else if indexPath.row == 6 {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "NotificationTVC") as! NotificationTVC
            
            self.navigationController?.pushViewController(secondViewController, animated: true)
        } else if indexPath.row == 7 {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackListViewController") as! FeedbackListViewController
            
            self.navigationController?.pushViewController(secondViewController, animated: true)
        } else if indexPath.row == 9 {
            
            let alertController = UIAlertController(title: "Confirmation", message: "Do you really want to Logout ?", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                UserDefaults.standard.removeObject(forKey: "user_fistname")
                self.dismiss(animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            
        }
    }

    
    
}


public enum BorderSide {
    case top, bottom, left, right
}

extension UIView {
    public func addBorder(side: BorderSide, color: UIColor, width: CGFloat) {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = color
        self.addSubview(border)
        
        let topConstraint = topAnchor.constraint(equalTo: border.topAnchor)
        let rightConstraint = trailingAnchor.constraint(equalTo: border.trailingAnchor)
        let bottomConstraint = bottomAnchor.constraint(equalTo: border.bottomAnchor)
        let leftConstraint = leadingAnchor.constraint(equalTo: border.leadingAnchor)
        let heightConstraint = border.heightAnchor.constraint(equalToConstant: width)
        let widthConstraint = border.widthAnchor.constraint(equalToConstant: width)
        
        
        switch side {
        case .top:
            NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, heightConstraint])
        case .right:
            NSLayoutConstraint.activate([topConstraint, rightConstraint, bottomConstraint, widthConstraint])
        case .bottom:
            NSLayoutConstraint.activate([rightConstraint, bottomConstraint, leftConstraint, heightConstraint])
        case .left:
            NSLayoutConstraint.activate([bottomConstraint, leftConstraint, topConstraint, widthConstraint])
        }
    }
}
