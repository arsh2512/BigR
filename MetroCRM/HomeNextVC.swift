//
//  HomeNextVC.swift
//  MetroCRM
//
//  Created by Ecsion Research Labs Pvt. Ltd. on 27/03/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class HomeNextVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
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
