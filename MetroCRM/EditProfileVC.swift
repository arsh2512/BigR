//
//  EditProfileVC.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 15/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import RoseLib
import DropDown

class EditProfileVC: UIViewController {

    @IBOutlet var profileImgView: UIImageView!
    @IBOutlet var emailId: UILabel!
    @IBOutlet var editProfileTableVIew: UITableView!
    
    var imageStr = String()
    var jsonArr : NSMutableArray = [" "]
    var userDetailDic = NSDictionary()
    var jsonResponse = Array<NSDictionary> ()
    var state_Id : Int = 0
    var stateName : String = ""
    var cityName : String = ""
    var cityId : Int = 0
    var name : String = ""
    var dob : String = ""
    var mobNo : String = ""
    var address1 : String = ""
    var address2 : String = ""
    var postalCode : Int = 0
    var countryId : Int = 0
    let dropDown = DropDown()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.title = "Profile"
        
        profileImgView.layer.borderWidth = 1
        profileImgView.layer.masksToBounds = false
        profileImgView.layer.borderColor = UIColor.black.cgColor
        profileImgView.layer.cornerRadius = profileImgView.frame.height/2
        profileImgView.clipsToBounds = true
        
        //profileImgView.image = UIImage(named: "NoImageFound")  //set placeholder image first.
        //profileImgView.downloaded(from: self.imageStr)
        
        if let email = UserDefaults.standard.string(forKey: "email_id") {
            emailId.text = email
        }
       getUserDetails()
        
        
    }
    
    @IBAction func didClickCamera(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func getUserDetails() {
        var user_Id = String()
        if let userId = UserDefaults.standard.string(forKey: "userlogin_id") {
            user_Id = userId
        }
        let paramDic = [
            "userlogin_id" : user_Id
            ] as [String : Any]
        
        do {
            self.showHUD(message: "Loading")
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.GetNormalUserDetailsbyLoginId, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            self.jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray as! [NSDictionary]
                            print("json \(self.jsonResponse)")
                            self.userDetailDic = self.jsonResponse.first!
                            if let name = self.userDetailDic["user_fistname"] as? String {
                                self.name = name
                            }
                            if let dob = self.userDetailDic["user_dateofbirth"] as? String {
                                self.dob = dob
                            }
                            if let mobile_no = self.userDetailDic["mobile_no"] as? String {
                                self.mobNo = mobile_no
                            }
                            if let address1 = self.userDetailDic["address1"] as? String {
                                self.address1 = address1
                            }
                            if let address2 = self.userDetailDic["address2"] as? String{
                                self.address2 = address2
                            }
                            if let postalCode = self.userDetailDic["postcode_id"] as? Int {
                                self.postalCode = postalCode
                            }
                            if let stateName = self.userDetailDic["state_name"] as? String {
                                self.stateName = stateName
                            }
                            if let state_Id = self.userDetailDic["state_id"] as? Int {
                                self.state_Id = state_Id
                            }
                            if let country_Id = self.userDetailDic["country_id"] as? Int {
                                self.countryId = country_Id
                            }
                            if let cityName = self.userDetailDic["city_name"] as? String {
                                self.cityName = cityName
                            }
                            if let city_Id = self.userDetailDic["city_id"] as? Int {
                                self.cityId = city_Id
                            }
                            DispatchQueue.main.async {
                                //print(responseStr)
                                self.profileImgView.image = UIImage(named: "NoImageFound")  //set placeholder image first.
                                if let imageStr = self.userDetailDic["image_path"] {
                                    self.imageStr = imageStr as! String
                                    //self.profileImgView.image = UIImage(named: "placeholder")
                                    self.profileImgView.downloadImageFrom(link: self.imageStr, contentMode: UIView.ContentMode.scaleToFill)
                                    //self.profileImgView.downloaded(from: self.imageStr)
                                }
                                self.hideHUD()
                                self.editProfileTableVIew.reloadData()
                                
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
    func callApiToUpdateUserDetails() {
        var user_Id = String()
        if let userId = UserDefaults.standard.string(forKey: "userlogin_id") {
            user_Id = userId
        }
        var user = String()
        if let userId = UserDefaults.standard.string(forKey: "user_id") {
            user = userId
        }
        //userlogin_id,user_name,ToDateTime,mobile_no,address1,address2,city_id,state_id,postcodeid,country_id,image_path,updated_by
        let paramDic = [
            "userlogin_id" : user_Id,
            "user_name" : name,
            "ToDateTime" : dob,
            "mobile_no" : mobNo,
            "address1" : address1,
            "address2" : address2,
            "city_id" : cityId,
            "state_id" : state_Id,
            "postcodeid" : postalCode,
            "country_id" : countryId,
            "image_path" : self.userDetailDic["image_path"] as! String,
            "updated_by" : user
            ] as [String : Any]
            print("para \(paramDic)")
        do {
            self.showHUD(message: "Loading")
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.UpdateNormalUserDetailsbyLoginId, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        DispatchQueue.main.async {
                            self.hideHUD()
                            print(responseStr)
                            self.displayActivityAlert(title: "Profile updated")
                            //self.tableView.reloadData()
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
    func getStateList(showPicker : Bool) {
        WebserviceManager().executeGetRequest(url: Url.GetStateDetails, completionHandler: {
            data,urlResponse,error,status in
            print("status \(status)")
            if status {
                do {
                    self.jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! Array<NSDictionary>
                    //print(self.jsonResponse)
                    if self.jsonResponse.count > 0 {
                        
                        let nameArray = self.jsonResponse.compactMap { $0["state_name"] }
                        let stateIdArr = self.jsonResponse.compactMap{ $0["state_id"] }
                        
                        if (showPicker) {
                            DPPickerManager().showPicker(title: "State List", selected: nameArray.first as? String, strings: nameArray as! [String], completion: {
                                (value, index, cancel) in
                                if (cancel) {
                                    return
                                }
                                self.state_Id = stateIdArr[index] as! Int
                                self.stateName = value!
                                DispatchQueue.main.async {
                                    let indexPath = IndexPath(item: 6, section: 0)
                                    self.editProfileTableVIew.reloadRows(at: [indexPath], with: .none)
                                    self.callApiToUpdateUserDetails()
                                }
                            })
                        }
//                        DispatchQueue.main.async {
//                            let indexPath = IndexPath(item: 6, section: 0)
//                            self.editProfileTableVIew.reloadRows(at: [indexPath], with: .none)
//                            self.callApiToUpdateUserDetails()
//                        }
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
    func showDatePicker() {
        DPPickerManager().showPicker(title: "Select Date", selected: Date() , completion: {
            (date, cancle) in
            if (cancle) {
                return
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            // again convert your date to string
            let myStringafd = formatter.string(from: date!)
            self.dob = myStringafd
            DispatchQueue.main.async {
                let indexPath = IndexPath(item: 1, section: 0)
                self.editProfileTableVIew.reloadRows(at: [indexPath], with: .none)
                self.callApiToUpdateUserDetails()
            }
        })
    }
    func callApiToGetCity(showPicker: Bool) {
    
        let paramDic = [
            "state_id" : state_Id
            ] as [String : Any]
        
        do {
            //self.showHUD(message: "Loading")
            let data =  try JSONSerialization.data(withJSONObject: paramDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            WebserviceManager().executePostRequest(url: Url.GetCityListing, bodyData: data, completionHandler: {
                data,urlResponse,error,status in
                if status {
                    if let responseStr = String(data: data!, encoding: .utf8) {
                        do {
                            let jsonArray = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! Array<NSDictionary>
                            //print("cityNames \(jsonArray)")
                            DispatchQueue.main.async {
                                print(responseStr)
                                //self.hideHUD()
                                let nameArray = jsonArray.compactMap { $0["city_name"] }
                                let cityArr = jsonArray.compactMap { $0["city_id"] }
                                self.cityName = nameArray.first as! String
                                self.cityId = cityArr.first as! Int
                                if (showPicker) {
                                    DPPickerManager().showPicker(title: "City List", selected: nameArray.first as? String, strings: nameArray as! [String], completion: {
                                        (value, index, cancel) in
                                        //self.state_Id = index
                                        if (cancel) {
                                            return
                                        }
                                        self.cityName = value!
                                        self.cityId = cityArr[index] as! Int
                                        DispatchQueue.main.async {
                                            let indexPath = IndexPath(item: 7, section: 0)
                                            self.editProfileTableVIew.reloadRows(at: [indexPath], with: .none)
                                            self.callApiToUpdateUserDetails()
                                        }
                                        
                                    })
                                }
//                                DispatchQueue.main.async {
//                                    let indexPath = IndexPath(item: 7, section: 0)
//                                    self.editProfileTableVIew.reloadRows(at: [indexPath], with: .none)
//                                    self.callApiToUpdateUserDetails()
//                                }
                            }
                        }
                            
                        catch let error
                        {
                            print(error)
                        }
                        
                    }
                    
                }
                
            })
        }
        catch {
            print("Unable to successfully convert NSData to NSDictionary")
        }
    }

}
extension EditProfileVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = EditCell()
        let cellAudioButton = UIButton(type: .custom)
        cellAudioButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        cellAudioButton.addTarget(self, action: #selector(accessoryButtonTapped), for: .touchUpInside)
        cellAudioButton.setImage(UIImage(named: "baseline_edit_black_24pt.png"), for: .normal)
        cellAudioButton.contentMode = .scaleAspectFit
        cellAudioButton.tag = indexPath.row
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "name", for: indexPath) as! EditCell
            cell.nameTextLbl.text = name
            
            
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "dob", for: indexPath) as! EditCell
            cell.dobLbl.text = dob
            
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "mob", for: indexPath) as! EditCell
            cell.mobLbl.text = mobNo
            cell.mobLbl.addDoneButtonOnKeyboard()
            
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "addone", for: indexPath) as! EditCell
           cell.address1Lbl.text = address1
            
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: "addtwo", for: indexPath) as! EditCell
            cell.address2Lbl.text = address2
            
        case 5:
            cell = tableView.dequeueReusableCell(withIdentifier: "postcode", for: indexPath) as! EditCell
            cell.postalCOdeLbl.text = "\(postalCode)"
            cell.postalCOdeLbl.addDoneButtonOnKeyboard()
            
        case 6:
            cell = tableView.dequeueReusableCell(withIdentifier: "state", for: indexPath) as! EditCell
            cell.stateLbl.text = stateName
            
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "city", for: indexPath) as! EditCell
            cell.cityLbl.text = cityName
        
        }
        cell.backgroundColor = UIColor.clear
        
        cell.accessoryView = cellAudioButton as UIView
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 5, y: 8, width: self.view.frame.size.width - 20, height: 45))
        
        whiteRoundedView.layer.backgroundColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0).cgColor
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 5.0
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        return cell
    }
    @objc func accessoryButtonTapped(sender : UIButton){
        print(sender.tag)
        switch sender.tag {
        case 0:
            do {
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = editProfileTableVIew.cellForRow(at: indexPath) as! EditCell
                cell.nameTextLbl.isUserInteractionEnabled = true
                cell.nameTextLbl.becomeFirstResponder()
            print("")
                
            }; break
        case 1:
            do {
                showDatePicker()
            }; break
        case 2:
            do {
                let indexPath = IndexPath(row: 2, section: 0)
                let cell = editProfileTableVIew.cellForRow(at: indexPath) as! EditCell
                cell.mobLbl.isUserInteractionEnabled = true
                cell.mobLbl.becomeFirstResponder()
            }; break
        case 3:
            do {
                let indexPath = IndexPath(row: 3, section: 0)
                let cell = editProfileTableVIew.cellForRow(at: indexPath) as! EditCell
                cell.address1Lbl.isUserInteractionEnabled = true
                cell.address1Lbl.becomeFirstResponder()
            }; break
        case 4:
            do {
                let indexPath = IndexPath(row: 4, section: 0)
                let cell = editProfileTableVIew.cellForRow(at: indexPath) as! EditCell
                cell.address2Lbl.isUserInteractionEnabled = true
                cell.address2Lbl.becomeFirstResponder()
            }; break
        case 5:
            do {
                let indexPath = IndexPath(row: 5, section: 0)
                let cell = editProfileTableVIew.cellForRow(at: indexPath) as! EditCell
                cell.postalCOdeLbl.isUserInteractionEnabled = true
                cell.postalCOdeLbl.becomeFirstResponder()
            }; break
        case 6:
            do {
                getStateList(showPicker: true)
                //self.dropDown.show()
            }; break
        default:
            callApiToGetCity(showPicker: true)
        }
        print("Tapped")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func callApi(user_id : String, image: UIImage) {
        let parameters : Parameters = [
            "userlogin_id" : user_id
        ]
        
        // Convert image to lowest quality jpeg image
        if let imageData = image.jpeg(.lowest) {
            self.showHUD(message: "Uploading Profile Image")
            ImageAPIClient.requestWith(endUrl: URL(string: Url.UpdateProfileImage)!, imageData: imageData, parameters: parameters, fileName: "abc.png", withName: "filename", success: { (responseObj) in
                DispatchQueue.main.async {
                    self.hideHUD()
                    print(responseObj)
                    self.getUserDetails()
                }
            
            },
                                       failure: {
                                        (error) in
                                        self.hideHUD()
                                        print(error)
            })
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
extension EditProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // imageViewPic.contentMode = .scaleToFill
           // imageViewPic.image = pickedImage
           
            
                var user_Id = String()
                if let userId = UserDefaults.standard.string(forKey: "userlogin_id") {
                    user_Id = userId
               self.callApi(user_id: user_Id, image: pickedImage)
                 
            }
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
extension EditProfileVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
           name = ""
        } else if textField.tag == 3 {
            mobNo = ""
            
        } else if textField.tag == 4 {
            
                address1 = ""
            
        } else if textField.tag == 5 {
            
                address1 = ""
            
        } else if textField.tag == 6 {
          // textField.text = ""
            
        }
        textField.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 1 {
            if let nameStr = textField.text {
                name = nameStr
            } else {
                name = ""
            }
        } else if textField.tag == 3 {
            if let nameStr = textField.text {
                mobNo = nameStr
            } else {
                mobNo = ""
            }
        } else if textField.tag == 4 {
            if let nameStr = textField.text {
                address1 = nameStr
            } else {
                address1 = ""
            }
        } else if textField.tag == 5 {
            if let nameStr = textField.text {
                address2 = nameStr
            } else {
                address1 = ""
            }
        } else if textField.tag == 6 {
            if let nameStr = textField.text {
                if nameStr.count > 0 {
                    postalCode = Int(nameStr)!
                }
                
            } else {
              
            }
            
        }
        callApiToUpdateUserDetails()
        
    }
}
