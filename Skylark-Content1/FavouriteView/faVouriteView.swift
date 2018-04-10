//
//  faVouriteView.swift
//  Skylark-Content1
//
//  Created by Moshood Adeaga on 09/04/2018.
//  Copyright © 2018 Moshood Adeaga. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class faVouriteView: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ProjectManager.sharedInstance.faveItemName.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        if ProjectManager.sharedInstance.faveItemImageUrl.object(at: indexPath.row) as! String == "NoImageAvailable" {
            cell.textLabel?.text = (ProjectManager.sharedInstance.faveItemName.object(at: indexPath.row) as! String)
            cell.imageView?.image = (UIImage(named: "NoImage")?.withRenderingMode(.alwaysOriginal))!
        }else if ProjectManager.sharedInstance.faveItemImageUrl.object(at: indexPath.row) is String{
            if (ProjectManager.sharedInstance.image(forKey:ProjectManager.sharedInstance.faveItemImageUrl.object(at: indexPath.row)as! String)) != nil{
                let cachedImage = ProjectManager.sharedInstance.image(forKey:ProjectManager.sharedInstance.faveItemImageUrl.object(at: indexPath.row)as! String)
                cell.textLabel?.text = (ProjectManager.sharedInstance.faveItemName.object(at: indexPath.row) as! String)
                cell.imageView?.image = (cachedImage)
            }else {
                cell.textLabel?.text = (ProjectManager.sharedInstance.faveItemName.object(at: indexPath.row) as! String)
                cell.imageView?.image = (UIImage(named: "NoImage")?.withRenderingMode(.alwaysOriginal))!
                
                //Download Image and Caching image
                Alamofire.request(ProjectManager.sharedInstance.faveItemImageUrl.object(at: indexPath.row)as! String).responseImage{response in
                    if let image = response.result.value {
                        print("image downloaded: \(image)")
                        cell.textLabel?.text = (ProjectManager.sharedInstance.faveItemName.object(at: indexPath.row) as! String)
                        cell.imageView?.image = image
                        // Caching Image
                        ProjectManager.sharedInstance.save(image: image, forKey: ProjectManager.sharedInstance.faveItemImageUrl.object(at: indexPath.row)as! String)
                        
                    }
                    
                }
            }
        }
        
        return cell
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
