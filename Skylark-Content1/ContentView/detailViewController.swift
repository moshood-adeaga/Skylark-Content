//
//  detailViewController.swift
//  Skylark-Content1
//
//  Created by Moshood Adeaga on 09/04/2018.
//  Copyright © 2018 Moshood Adeaga. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class detailViewController: UITableViewController {
    var Index = 0 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TableViewCell2", bundle: nil), forCellReuseIdentifier: "TableViewCell2")
        tableView.register(UINib(nibName: "TableViewCell3", bundle: nil), forCellReuseIdentifier: "TableViewCell3")
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var sectionRows = 0
        if section == 0
        {
            sectionRows = 1
        }
        if section == 1
        {
            sectionRows = 4
        }
        return sectionRows
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell2")!
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                
                (cell as! TableViewCell2).titleLabel.text = ProjectManager.sharedInstance.itemName
                if ProjectManager.sharedInstance.itemImageLink == "NoImageAvailable"{
                    (cell as! TableViewCell2).detailImageView.image = (UIImage(named: "NoImage")?.withRenderingMode(.alwaysOriginal))!
                }else{
                    (cell as! TableViewCell2).detailImageView.image = ProjectManager.sharedInstance.image(forKey: ProjectManager.sharedInstance.itemImageLink)
                    if ProjectManager.sharedInstance.itemBody == ""
                    {
                        (cell as! TableViewCell2).bodyTextView.text = "Not Available"
                    }else{
                        (cell as! TableViewCell2).bodyTextView.text = ProjectManager.sharedInstance.itemBody
                    }
                }
            }
        }
        if indexPath.section == 1
        {
            if indexPath.row >= 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell3")!
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                (cell as! TableViewCell3).detailLabel.text = "Published:"
                if ProjectManager.sharedInstance.itemPublished == ""
                {
                    (cell as! TableViewCell3).descLabel.text = "Not Available"
                }else{
                    let dateFormatter = DateFormatter()
                    let tempLocale = dateFormatter.locale
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let date = dateFormatter.date(from: ProjectManager.sharedInstance.itemPublished)
                    dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
                    dateFormatter.locale = tempLocale
                    let dateString = dateFormatter.string(from: date!)
                    
                    (cell as! TableViewCell3).descLabel.text = dateString
                }
            }
            if indexPath.row >= 1
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell3")!
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                (cell as! TableViewCell3).detailLabel.text = "Quoter(s):"
                if ProjectManager.sharedInstance.itemQuoter == ""
                {
                    (cell as! TableViewCell3).descLabel.text = "Not Available"
                }else{
                    (cell as! TableViewCell3).descLabel.text = ProjectManager.sharedInstance.itemQuoter
                }
            }
            if indexPath.row >= 2
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell3")!
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                (cell as! TableViewCell3).detailLabel.text = "Quote:"
                if ProjectManager.sharedInstance.itemQuote == ""
                {
                    (cell as! TableViewCell3).descLabel.text = "Not Available"
                }else{
                    (cell as! TableViewCell3).descLabel.text = ProjectManager.sharedInstance.itemQuote
                }
            }
            if indexPath.row >= 3
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell3")!
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                (cell as! TableViewCell3).detailLabel.text = "Created:"
                if ProjectManager.sharedInstance.itemCreated == ""
                {
                    (cell as! TableViewCell3).descLabel.text = "Not Available"
                }else{
                    let dateFormatter = DateFormatter()
                    let tempLocale = dateFormatter.locale
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let date = dateFormatter.date(from: ProjectManager.sharedInstance.itemCreated)
                    dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
                    dateFormatter.locale = tempLocale
                    if date != nil{
                        let dateString = dateFormatter.string(from: date!)
                        (cell as! TableViewCell3).descLabel.text = dateString
                    }else if date == nil{
                        (cell as! TableViewCell3).descLabel.text = ProjectManager.sharedInstance.itemCreated
                    }
                    
                    
                }
                
            }
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var heightRow:CGFloat = 0.0
        if indexPath.section == 0
        {
            
            switch indexPath.row {
            case 0:
                heightRow = 375
                return 375
                
            case 1:
                heightRow = 50
                return 50
                
            default:
                return UITableViewAutomaticDimension
            }
        }
        else if indexPath.section == 1
        {
            switch indexPath.row {
            case 0:
                heightRow = 50
                return 50
                
            case 1:
                heightRow = 50
                return 50
                
            default:
                return UITableViewAutomaticDimension
            }
        }
        
        return heightRow
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
            
        case 1:
            return 50
            
        default:
            return UITableViewAutomaticDimension
        }
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
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
