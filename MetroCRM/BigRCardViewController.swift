//
//  BigRCardViewController.swift
//  MetroCRM
//
//  Created by phonestop on 10/26/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class BigRCardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didClickRegisterCard(_ sender: UIButton) {
        
        let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterBigRCardVC") as! RegisterBigRCardVC
        
        self.navigationController?.pushViewController(paymentVC, animated: true)
        
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
