//
//  AricleTVC.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 28/03/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RoseLib
class AricleTVC: UITableViewController {
    var jsonResponse = NSArray ()
    var cellHeight : CGFloat = 140.00
    var indexPathForRow = Int()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "articleCell")
        //tableView.estimatedRowHeight = 89
        //tableView.rowHeight = UITableView.automaticDimension
    }
    
    
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.jsonResponse.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleTableViewCell
        
        
        
        let dic = jsonResponse[indexPath.row] as! NSDictionary
        if let title = dic["content_title"] {
            cell.articleTitleLbl.text = title as? String
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
        
        // separator line
//        let screenSize = UIScreen.main.bounds
//        let separatorHeight = CGFloat(3.0)
//        let additionalSeparator = UIView.init(frame: CGRect(x: 0, y: cell.frame.size.height-separatorHeight, width: screenSize.width, height: separatorHeight))
//        additionalSeparator.backgroundColor = UIColor.gray
//        cell.contentView.addSubview(additionalSeparator)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.estimatedRowHeight = 89
        indexPathForRow = indexPath.row
        cellHeight = cellHeight == 140 ? UITableView.automaticDimension : 140
        
        //tableView.rowHeight = UITableView.automaticDimension
        tableView.reloadData()
    }
   
//    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forR section: Int) {
//        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == indexPathForRow {
            return cellHeight
        }
        return 140
       
       // return UITableView.automaticDimension
    }
    
     

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
