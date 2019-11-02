//
//  RedeemDetailVC.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 20/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class RedeemDetailVC: UIViewController {

    @IBOutlet var voucherCode: UILabel!
    @IBOutlet var qrCodeImageView: UIImageView!
    var voucherCOdeString = String()
    var voucherImageStr = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        //self.view = UIImageView(image: UIImage(named: "gradientbg.jpg"))
        
        voucherCode.text = "Voucher Code : \(voucherCOdeString)"
        
        let imageUrl = "\(Url.imageBaseUrl)\(voucherImageStr)"
        
        qrCodeImageView.image = UIImage(named: "NoImageFound")  //set placeholder image first.
        qrCodeImageView.downloaded(from: imageUrl)
        qrCodeImageView.contentMode = .scaleToFill
        // Do any additional setup after loading the view.
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
