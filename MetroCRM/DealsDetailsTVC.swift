//
//  DealsDetailsTVC.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 01/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RoseLib
class DealsDetailsTVC: UITableViewController {

    @IBOutlet var voucherNameLbl: UILabel!
    @IBOutlet var broughtLbl: UILabel!
    @IBOutlet var originalPriceLbl: UILabel!
    @IBOutlet var discountPriceLbl: UILabel!
    @IBOutlet var redeemOfferLbl: UIButton!
    @IBOutlet var reservationLbl: UIButton!
    @IBOutlet var promotionImg: UIImageView!
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var redemInstructionLbl: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var offerImgView: UIImageView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var calendarLbl: UILabel!
    @IBOutlet var callLbl: UILabel!
    @IBOutlet var reedemOfferCountLbl: UILabel!
    @IBOutlet var addToCartView: UIView!
    @IBOutlet var detailLbl: UILabel!
    
    @IBOutlet var wishListBtn: UIButton!
    @IBOutlet var quantityLbl: UILabel!
    @IBOutlet var promocodeTextField: UITextField!
    @IBOutlet var totalPriceLbl: UILabel!
    
    
    let bgView = UIView()
    var scrollImageUrl = String()
    var voucherId = Int()
    var images = [UIImage]()
    var colors:[UIImage] =  []
    var cellHeight : CGFloat = 120.00
    var indexPathForRow = Int()
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var addressDic = NSDictionary()
    var wished = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Deal Detail"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        // self.tableView.tableFooterView = UIView()
        tableView.backgroundView = UIImageView(image: UIImage(named: "gradientbg.jpg"))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        images = [#imageLiteral(resourceName: "rose"),#imageLiteral(resourceName: "flower"),#imageLiteral(resourceName: "rose"),#imageLiteral(resourceName: "flower")]
        colors = [#imageLiteral(resourceName: "rose"),#imageLiteral(resourceName: "flower"),#imageLiteral(resourceName: "rose"),#imageLiteral(resourceName: "flower")]
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if wished {
            wishListBtn.isSelected = true
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        callApi()
        callApiToGetAddress()
    }
    func configureBanner() {
        configurePageControl()
        for index in 0..<5 {
            
            //let bannerList : NSDictionary = bannerListJson[index] as! NSDictionary
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            var imageUrl = ""
            if index == 0 {
                imageUrl = scrollImageUrl
            }
            
            //if var imageStr = scrollImageUrl {
            let imageStr = (imageUrl).addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                imageUrl = "https://www.bigr.asia/crmapp/Images/voucher/\(imageStr)"
           // }
            
            offerImgView.image = UIImage(named: "")  //set placeholder image first.
            //offerImgView.contentMode = .scaleToFill
            
            offerImgView = UIImageView(frame: frame)
            offerImgView.downloaded(from: imageUrl)
            
            self.scrollView .addSubview(offerImgView)
        }
        
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * CGFloat(colors.count), height:self.scrollView.frame.height)
        self.scrollView.delegate = self
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
    }
    func configurePageControl() {
        self.pageControl = UIPageControl(frame: CGRect(x:0,y: 98, width:view.frame.size.width, height:50))
        self.pageControl.numberOfPages = 5
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.white
        self.pageControl.pageIndicatorTintColor = UIColor.gray
        self.pageControl.currentPageIndicatorTintColor = UIColor.white
        self.view.addSubview(pageControl)
        
    }
    @objc func moveToNextPage (){
        
        let pageWidth:CGFloat = self.scrollView.frame.width
        let maxWidth:CGFloat = pageWidth * CGFloat(colors.count)
        let contentOffset:CGFloat = self.scrollView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth
        {
            slideToX = 0
        }
        self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: true)
    }
    func callApiToGetAddress() {
        let url = "\(Url.GetVoucherOutletsAddressById)voucherId=\(voucherId)"
        WebserviceManager().executeGetRequest(url: url, completionHandler: {
            data,urlResponse,error,status in
            print("res\(urlResponse)")
            do {
                
                let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                print("val:\(jsonResponse)")
                let dic : NSDictionary = jsonResponse[0] as! NSDictionary
                self.addressDic = dic
                DispatchQueue.main.async {
                    self.addressLbl.text = "\(dic["branch_name"] as! String) \(dic["branch_address_1"] as! String) \(dic["branch_address_1"] as! String) \(dic["city_name"] as! String) \(dic["state_name"] as! String)"
                    let outletCountString : String = jsonResponse.count == 1 ? "\(jsonResponse.count) Outlet" : "\(jsonResponse.count) Outlets"
                    self.reedemOfferCountLbl.text = "Reedem offer at \(outletCountString)"
                    self.addressLbl.numberOfLines = 0
                    self.addressLbl.sizeToFit()
                    let indexPath = IndexPath(item: 3, section: 0)
                    
                    var imageUrl = ""
                    if let imageStr = dic["merchant_logo"] {
                        let parsedStr = (imageStr as! String).replacingOccurrences(of: "..", with: "")
                        imageUrl = "\(Url.imageBaseUrl)\(parsedStr)"
                        //imageUrl = "\(Url.imageBaseUrl)/crmapp/merchant/NEC_Logo.png"
                    }
                    
                    self.promotionImg.image = UIImage(named: "NoImageFound")  //set placeholder image first.
                    //cell.voucherImageView.contentMode = .scaleAspectFit
                    self.promotionImg.downloaded(from: imageUrl)
                    self.promotionImg.contentMode = .scaleToFill
                    
                    self.tableView.reloadRows(at: [indexPath], with: .top)
                }
                
            }
            catch let error
            {
                print(error)
            }
        })
    }
    func callApi() {
        showHUD(message: "")
        let url = "\(Url.GetVoucherDetailsByIdUrl)voucherId=\(voucherId)"
        WebserviceManager().executeGetRequest(url: url, completionHandler: {
            data,urlResponse,error,status in
            print("res\(urlResponse)")
            do {
                self.hideHUD()
                let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                print("val:\(jsonResponse)")
                let dic : NSDictionary = jsonResponse[0] as! NSDictionary
                DispatchQueue.main.async {
                    self.voucherNameLbl.text = dic["voucher_name"] as? String
                    
                    if let detailLbl = dic["descriptions"] {
                        self.detailLbl.text = (detailLbl as! String).htmlToString
                    }
                    self.detailLbl.numberOfLines = 0;
                    self.detailLbl.sizeToFit()
                    if let calLbl = dic["redeem_offer"] {
                        self.calendarLbl.text = (calLbl as! String).htmlToString
                    }
                    if let callLbl = dic["reservation"] {
                        self.callLbl.text = (callLbl as! String).htmlToString
                    }
                    self.calendarLbl.numberOfLines = 0
                    self.calendarLbl.sizeToFit()
                    
                    self.callLbl.numberOfLines = 0
                    self.callLbl.sizeToFit()
                    let oPrice = dic["original_price"] as! Int
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: String(oPrice))
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
                    let attributeStringOne: NSMutableAttributedString =  NSMutableAttributedString(string: "RM")
                    let combinedAttributedString = attributeStringOne.getAttributedStringByAppending(attributedString: attributeString)
                    self.originalPriceLbl.attributedText = combinedAttributedString
                    self.discountPriceLbl.text = "RM " + String(dic["discount_price"] as! Int)
                   
                    self.redemInstructionLbl.text = (dic["redeem_instruction"] as! String).htmlToString
                    self.redemInstructionLbl.sizeToFit()
                    
                    self.broughtLbl.text = "\(dic["bought"] as! Int) Bought"
                    self.scrollImageUrl = dic["promotion_image"] as! String
                    self.configureBanner()
                    self.tableView.reloadData()
                }
                
            }
            catch let error
            {
                print(error)
            }
        })
    }
    func callApiToAddToCart() {
        // voucher_id,product_qty,userlogin_id,promocode_id
        var user_Id = String()
        if let userId = UserDefaults.standard.string(forKey: "userlogin_id") {
            user_Id = userId
        }
        let promoId = promocodeTextField.text == "GONGXIFATCAI" ? 4 : 0
        
        let paramDic = [
            "userlogin_id" : user_Id,
            "voucher_id" : voucherId,
            "product_qty" : 1,
            "promocode_id" : promoId
            ] as [String : Any]
        
        do {
            //self.showHUD(message: "Loading")
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.AddOrderListItems, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                            print(jsonResponse)
                             let dic : NSDictionary = jsonResponse[0] as! NSDictionary
                            DispatchQueue.main.async {
                                print(responseStr)
                                self.hideHUD()
                                self.bgView.removeFromSuperview()
                                self.addToCartView.removeFromSuperview()
                                if dic["ptype"] as! Int == 1 {
                                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyCartTVC") as! MyCartTVC
                                
                                    self.navigationController?.pushViewController(secondViewController, animated: true)
                                } else {
                                    self.displayActivityAlert(title: "Already Exists")
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if indexPath.row == 1 {
            cellHeight = cellHeight == 120 ? UITableView.automaticDimension : 120
        } 
        
        //tableView.rowHeight = UITableView.automaticDimension
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 140.0
        }
        else if indexPath.row == 1 {
            return cellHeight
        }
        else if indexPath.row == 2 {
            return UITableView.automaticDimension
        }
        else if indexPath.row == 3 {
            return 160
        }
        else {
            return UITableView.automaticDimension
        }
    }
        private let kSeparatorId = 123
        private let kSeparatorHeight: CGFloat = 10
        override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if cell.viewWithTag(kSeparatorId) == nil //add separator only once
            {
                let separatorView = UIView(frame: CGRect(x:0, y:cell.frame.height - kSeparatorHeight, width:cell.frame.width, height:kSeparatorHeight))
                separatorView.tag = kSeparatorId
                separatorView.backgroundColor = UIColor(white: 1, alpha: 0.0)
                separatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

                cell.addSubview(separatorView)
                
//                cell.backgroundColor = UIColor.clear
//                let whiteRoundedView : UIView = UIView(frame: CGRect(x: 0, y: 8, width: self.view.frame.size.width, height: 150))
//
//                whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
//                whiteRoundedView.layer.masksToBounds = false
//                whiteRoundedView.layer.cornerRadius = 0.0
//
//                cell.contentView.addSubview(whiteRoundedView)
//                cell.contentView.sendSubviewToBack(whiteRoundedView)
            }
        }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    

    @IBAction func didClickAddToCart(_ sender: UIButton) {
        
        bgView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        self.navigationController?.view.addSubview(bgView)
        bgView.frame = CGRect(x: 0,
                                     y: 0,
                                     width: self.view.bounds.size.width,
                                     height: self.view.bounds.size.height)
        bgView.addSubview(addToCartView)
        addToCartView.frame = CGRect(x: 0,
                                     y: self.view.bounds.size.height - addToCartView.bounds.size.height-40,
                                     width: self.view.bounds.size.width,
                                     height: addToCartView.bounds.size.height)
        self.totalPriceLbl.text = self.discountPriceLbl.text!
        self.promocodeTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(hidebgView))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        bgView.addGestureRecognizer(tap)
    }
    
    @IBAction func didClickViewAll(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "DealOutletMapViewController") as! DealOutletMapViewController
        secondViewController.jsonDic = addressDic
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    @objc func hidebgView() {
        bgView.removeFromSuperview()
        addToCartView.removeFromSuperview()
    }
    @IBAction func didClickVerify(_ sender: Any) {
        if promocodeTextField.text == "GONGXIFATCAI" {
            self.displayActivityAlert(title: "Promocode Matched")
        } else {
            self.displayActivityAlert(title: "Promocode did not match")
        }
    }
    
    @IBAction func didClickFinalAddToCart(_ sender: Any) {
        callApiToAddToCart()
    }
    @IBAction func didClickPayNow(_ sender: Any) {
        callApiToAddToCart()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.addToCartView.frame.origin.y == self.view.bounds.size.height - addToCartView.bounds.size.height-40 {
                self.addToCartView.frame.origin.y = self.view.bounds.size.height - addToCartView.bounds.size.height-40-keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.addToCartView.frame.origin.y != self.view.bounds.size.height - addToCartView.bounds.size.height-40 {
            self.addToCartView.frame.origin.y = self.view.bounds.size.height - addToCartView.bounds.size.height-40
        }
    }
}
extension DealsDetailsTVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
}
private typealias ScrollView = DealsDetailsTVC
extension ScrollView
{
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView){
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage)
    }
}

