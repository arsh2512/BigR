//
//  DealOutletMapViewController.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 11/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class DealOutletMapViewController: UIViewController {

    @IBOutlet var dealOutletImage: UIImageView!
    @IBOutlet var dealAddressLbl: UILabel!
    var jsonDic = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.view.backgroundColor = .clear
        
        dealAddressLbl.text = "\(jsonDic["branch_name"] as! String) \(jsonDic["branch_address_1"] as! String) \(jsonDic["branch_address_1"] as! String) \(jsonDic["city_name"] as! String) \(jsonDic["state_name"] as! String)"
       
        dealAddressLbl.numberOfLines = 0
        dealAddressLbl.sizeToFit()
        
        var imageUrl = ""
        if let imageStr = jsonDic["merchant_logo"] {
            imageUrl = "\(Url.imageBaseUrl)\(imageStr)"
            //imageUrl = "\(Url.imageBaseUrl)/crmapp/merchant/NEC_Logo.png"
        }
        
        dealOutletImage.image = UIImage(named: "NoImageFound")  //set placeholder image first.
        //cell.voucherImageView.contentMode = .scaleAspectFit
        dealOutletImage.downloaded(from: imageUrl)
        dealOutletImage.contentMode = .scaleToFill
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didClickMap(_ sender: Any) {
        let lat : String = jsonDic["latitude"] as? String ?? "0"
        let longi: String = (jsonDic["longitude"] as? String)!
        let coordinate = CLLocationCoordinate2DMake(Double(lat)!, Double(longi)!)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = jsonDic["organization_name"] as? String ?? ""
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        
      /*  let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        if let lat = jsonDic["latitude"] as? String {
            
            secondViewController.lat = Double(lat)!
        }
        if let longi = jsonDic["longitude"] as? String {
            
            secondViewController.longi = Double(longi)!
        }
        if let name = jsonDic["organization_name"] as? String {
            
            secondViewController.name = name
        }
        self.navigationController?.pushViewController(secondViewController, animated: true)  */
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
