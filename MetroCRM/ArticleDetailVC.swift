//
//  ArticleDetailVC.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 15/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ArticleDetailVC: UIViewController {

    @IBOutlet var aticleDetailLbl: UILabel!
    var descLabel = String()
    var aticleTitle = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = aticleTitle.htmlToString
        aticleDetailLbl.text = descLabel.htmlToString
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
