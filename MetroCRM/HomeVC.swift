//
//  HomeVC.swift
//  MetroCRM
//
//  Created by Ecsion Research Labs Pvt. Ltd. on 27/03/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RoseLib
import WebKit

class HomeVC: UIViewController , UIScrollViewDelegate, UITextFieldDelegate{

    @IBOutlet var shohidePinBtn: UIButton!
    @IBOutlet var articleTableView: UITableView!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var offerImgView: UIImageView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var minexWebView: WKWebView!
    @IBOutlet var digiByteWebView: WKWebView!
    @IBOutlet var myQR: UIButton!
    @IBOutlet var pinView: UIView!
    
    @IBOutlet var backView: UIView!
    @IBOutlet var pin1: UITextField!
    @IBOutlet var pin2: UITextField!
    @IBOutlet var pin3: UITextField!
    @IBOutlet var pin4: UITextField!
    @IBOutlet var pin5: UITextField!
    @IBOutlet var QRPay: UIButton!
    @IBOutlet var pin6: UITextField!
    var pinNo = String()
    var images = [UIImage]()
    var colors:[UIImage] =  []
    var jsonResponse = NSArray ()
    var bannerListJson = NSArray ()
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var iconClick = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // textfield delegates
        pin1.delegate = self
        pin2.delegate = self
        pin3.delegate = self
        pin4.delegate = self
        pin5.delegate = self
        pin6.delegate = self
          let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
         self.backView.addGestureRecognizer(tap)
        myQR.alignVertical()
        QRPay.alignVertical()
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        //var hostval : DeviceDetail?
        var contacts : NSMutableArray = []
        for var i in 0..<4 {
        let str : String = "MSEARCH RESPONSE\nFRIENDLY_NAME:Portronics_Mux_8f6b50\nFW_VERSION:May 30 201916:41:16\nUSN:240ac48f6b50"
        let arr = str.split(separator: "\n")
        var dic = [String : Any]()
        
        if str.contains("Portronics") {
            for ParseStr in arr {
                if (ParseStr.contains("FW_VERSION")) {
                    let frnNm = ParseStr.components(separatedBy: "FW_VERSION:")
                    print("fwVrsion:\(frnNm.last!)")
                    dic.updateValue(frnNm.last!, forKey: "FWVersion")
                }
                if (ParseStr.contains("FRIENDLY_NAME")) {
                    let frnNm = ParseStr.components(separatedBy: "FRIENDLY_NAME:")
                    print("name:\(frnNm.last!)")
                    dic.updateValue(frnNm.last!, forKey: "frN")
                }
            }
            if !contacts.contains{ $0 == dic } {
                print("dic\(dic)")
                contacts.add(dic)
            }
        }
        
        print("mutArr\(contacts)")
        }
        let d :[String : Any] = contacts[0] as! [String : Any]
        print("fn \(d["frN"]!)")
        articleTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "articleCell")
        if let userName = UserDefaults.standard.string(forKey: "user_fistname") {
            userNameLbl.text = "Hi \(userName)"
        }
        articleTableView.estimatedRowHeight = 89
        articleTableView.rowHeight = UITableView.automaticDimension
        
        // Do any additional setup after loading the view.
        
        
    }
    @IBAction func showPin(_ sender: Any) {
        if(iconClick == true) {
            self.shohidePinBtn.setImage(UIImage(named: "baseline_visibility_black_24pt"), for: .normal)
            pin1.isSecureTextEntry = false
            pin2.isSecureTextEntry = false
            pin3.isSecureTextEntry = false
            pin4.isSecureTextEntry = false
            pin5.isSecureTextEntry = false
            pin6.isSecureTextEntry = false
            
        } else {
            self.shohidePinBtn.setImage(UIImage(named: "baseline_visibility_off_black_24pt"), for: .normal)
            pin1.isSecureTextEntry = true
            pin2.isSecureTextEntry = true
            pin3.isSecureTextEntry = true
            pin4.isSecureTextEntry = true
            pin5.isSecureTextEntry = true
            pin6.isSecureTextEntry = true
        }
        
        iconClick = !iconClick
    }
    
    @IBAction func submitPinAction(_ sender: Any) {
        callApiToValidateTransactionPin()
    }
    
    @IBAction func cancelPinAction(_ sender: Any) {
        self.pinView.isHidden = true
        self.backView.isHidden = true
    }
    func loadHTMLStringImage() -> Void {
        minexWebView.layer.cornerRadius = 10;
        minexWebView.layer.masksToBounds = true;
        
        digiByteWebView.layer.cornerRadius = 10
        digiByteWebView.clipsToBounds = true
        
        let htmlString = "<script type=\"text/javascript\" src=\"https://files.coinmarketcap.com/static/widget/currency.js\"></script><div class=\"coinmarketcap-currency-widget\" data-currencyid=\"2139\" data-base=\"MYR\" data-secondary=\"\" data-ticker=\"true\" data-rank=\"false\" data-marketcap=\"false\" data-volume=\"false\" data-stats=\"USD\" data-statsticker=\"false\"></div>"
        minexWebView.loadHTMLString(htmlString, baseURL: nil)
        
        let htmlStringDigiByte = "<script type=\"text/javascript\" src=\"https://files.coinmarketcap.com/static/widget/currency.js\"></script><div class=\"coinmarketcap-currency-widget\" data-currencyid=\"109\" data-base=\"MYR\" data-secondary=\"\" data-ticker=\"true\" data-rank=\"false\" data-marketcap=\"false\" data-volume=\"false\" data-stats=\"USD\" data-statsticker=\"false\"></div>"
        digiByteWebView.loadHTMLString(htmlStringDigiByte, baseURL: nil)
        
        
    }
    func configureBanner() {
        configurePageControl()
        for index in 0..<bannerListJson.count {
            
            let bannerList : NSDictionary = bannerListJson[index] as! NSDictionary
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            var imageUrl = ""
            if var imageStr = bannerList["image_path"] {
                imageStr = (imageStr as! String).addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                imageUrl = "\(Url.bannerImageUrl)\(imageStr)"
            }
            
            offerImgView.image = UIImage(named: "NoImageFound")  //set placeholder image first.
            //offerImgView.contentMode = .scaleToFill
            
            offerImgView = UIImageView(frame: frame)
            offerImgView.downloaded(from: imageUrl)

            self.scrollView .addSubview(offerImgView)
        }
        
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * CGFloat(self.bannerListJson.count), height:self.scrollView.frame.height)
        self.scrollView.delegate = self
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        callApiToGetBannerList()
        callApiToGetArticleList()
        images = [#imageLiteral(resourceName: "rose"),#imageLiteral(resourceName: "flower"),#imageLiteral(resourceName: "rose"),#imageLiteral(resourceName: "flower")]
        colors = [#imageLiteral(resourceName: "rose"),#imageLiteral(resourceName: "flower"),#imageLiteral(resourceName: "rose"),#imageLiteral(resourceName: "flower")]
        
        loadHTMLStringImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    func callApiToGetBannerList() {
        let paramDic = [
            "content_category_code" :"5"
            ] as [String : Any]
        
        do {
            
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.getBannerDetailsByCategoryUrl, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            self.bannerListJson = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                            print(self.bannerListJson)
                            
                            DispatchQueue.main.async {
                                //print(responseStr)
                                
                                self.configureBanner()
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
    func callApiToGetArticleList() {
        let url = "\(Url.getArticleList)content_category_code=3"
        WebserviceManager().executeGetRequest(url: url, completionHandler: {
            data,urlResponse,error,status in
            print("status \(status)")
            if status {
                do {
                    self.jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                    print(self.jsonResponse)
                    
                    DispatchQueue.main.async {
                        //print(responseStr)
                        self.hideHUD()
                        self.articleTableView.reloadData()
                        
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
    func configurePageControl() {
        self.pageControl = UIPageControl(frame: CGRect(x:0,y: view.frame.height - 100, width:view.frame.size.width, height:50))
        self.pageControl.numberOfPages = self.bannerListJson.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.white
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.red
        self.view.addSubview(pageControl)
        
    }
    @objc func moveToNextPage (){
        
        let pageWidth:CGFloat = self.scrollView.frame.width
        let maxWidth:CGFloat = pageWidth * CGFloat(self.bannerListJson.count)
        let contentOffset:CGFloat = self.scrollView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth
        {
            slideToX = 0
        }
        self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: true)
    }

    @IBAction func didClickViewAll(_ sender: Any) {
        DispatchQueue.main.async {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ArticleTVC") as! AricleTVC
            secondViewController.jsonResponse = self.jsonResponse
            //let navigationController = UINavigationController(rootViewController: secondViewController)
            self.navigationController?.pushViewController(secondViewController, animated: true)
            //self.present(secondViewController, animated: true, completion: nil)

        }
        
    }
    @IBAction func buttonAction(_ sender: Any) {
        let button = sender as! UIButton
        if button.tag == 0 {
            callApiToGetPinDetail()
        } else {
            DispatchQueue.main.async {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ComingSoon")
                self.navigationController?.pushViewController(secondViewController!, animated: true)
            }
        }
    }
    func callApiToGetPinDetail() {
        var user_Id = String() //user_fistname
        if let userId = UserDefaults.standard.string(forKey: "user_id") {
            user_Id = userId
        }
        if let userId2 = UserDefaults.standard.string(forKey: "user_fistname") {
           // user_Id2 = userId2
        }
        let paramDic = [
            "user_id" : user_Id
            ] as [String : Any]
        
        do {
            
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.GetTPinDetailsByUserId, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            let responeJson = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                            print(responeJson)
                            
                            DispatchQueue.main.async {
                                
                                if responeJson.count == 0 {
                                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterPinViewController") as! RegisterPinViewController
                                    secondViewController.pinJson = responeJson
                                    self.navigationController?.pushViewController(secondViewController, animated: true)
                                } else {
                                    self.backView.isHidden = false
                                    self.pinView.isHidden = false
                                    self.pin1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
                                    self.pin2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
                                    self.pin3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
                                    self.pin4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
                                    self.pin5.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
                                    self.pin6.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
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
    func callApiToValidateTransactionPin() {
        var user_Id = String() //user_fistname
        if let userId = UserDefaults.standard.string(forKey: "user_id") {
            user_Id = userId
        }
        if let userId2 = UserDefaults.standard.string(forKey: "user_fistname") {
            // user_Id2 = userId2
        }
        let paramDic = [
            "user_id" : user_Id,
            "pin_no" : "\(pin1.text!)\(pin2.text!)\(pin3.text!)\(pin4.text!)\(pin5.text!)\(pin6.text!)"
            ] as [String : Any]
        
        do {
            
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.ValidateTransactionPin, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            let responeJson = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                            print(responeJson)
                            DispatchQueue.main.async {
                                if responeJson.count == 0 {
                                    self.displayActivityAlert(title: "Invalid Pin")
                                } else {
                                    self.pinView.isHidden = true
                                    self.backView.isHidden = true
                                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ScanQRViewController") as! ScanQRViewController
                                    
                                    self.navigationController?.pushViewController(secondViewController, animated: true)
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
private typealias ScrollView = HomeVC
extension ScrollView
{
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView){
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage)
    }
}

extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if jsonResponse.count > 0 {
            return 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleTableViewCell
        let dic = jsonResponse.lastObject as! NSDictionary
        if let title = dic["content_title"] {
            cell.articleTitleLbl.attributedText = (title as! String).htmlToAttributedString
            
            //cell.articleTitleLbl.text = title as? String
        } else {
            cell.articleTitleLbl.text = ""
        }
        if let description = dic["content_description"] {
            cell.articleDescriptionLbl.text = (description as? String)?.htmlToString
            cell.articleDescriptionLbl.layer.borderColor = UIColor.lightGray.cgColor
            cell.articleDescriptionLbl.numberOfLines = 0;
            cell.articleDescriptionLbl.sizeToFit()
        } else {
            cell.articleDescriptionLbl.text = ""
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ArticleDetailVC") as! ArticleDetailVC
        let dic : NSDictionary = jsonResponse.lastObject as! NSDictionary
        if let title = dic["content_title"] {
            secondViewController.aticleTitle = title as! String
        } else {
            
        }
        if let description = dic["content_description"] {
            secondViewController.descLabel = ((description as? String)!)
            
        } else {
            //secondViewController.aticleDetailLbl = ""
        }
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIView.ContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:"https://api.bigr.asia/img/portfolio/abc.png")! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleToFill) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        
    }
}
