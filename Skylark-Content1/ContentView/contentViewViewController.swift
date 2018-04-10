//
//  contentViewViewController.swift
//  Skylark-Content1
//
//  Created by Moshood Adeaga on 09/04/2018.
//  Copyright © 2018 Moshood Adeaga. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class contentViewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Variables Declaration
    var itemName = NSMutableArray()
    var itemImageUrl = NSMutableArray()
    var itemImage = NSMutableArray()
    var setBody = NSMutableArray()
    var setQuoter = NSMutableArray()
    var setPublished = NSMutableArray()
    var setCreated = NSMutableArray()
    var setQuote = NSMutableArray()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Setting delegates and datasource for collectionview
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // Registering Collectionview Cell for use 
        let nibName = UINib(nibName: "itemCell", bundle:nil)
        collectionView.register(nibName, forCellWithReuseIdentifier:"CELL")
        
        //Parsing Data from Api
        let setsLink = "http://feature-code-test.skylark-cms.qa.aws.ostmodern.co.uk:8000/api/sets/"
        initParse(link: setsLink)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.collectionView.reloadData()
        print(itemImage)
    }
    
    // Collection View Delegates & Datasources
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section:Int)->Int
    {
        return itemName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:IndexPath)->UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! itemCell
        print(itemImage)
        
        if itemImage.object(at: indexPath.row) as! String == "NoImageAvailable"{
            cell.fillItemCell(itemImage:(UIImage(named: "NoImage")?.withRenderingMode(.alwaysOriginal))!,itemName:(itemName.object(at: indexPath.row) as! String))
            
        }else if itemImage.object(at: indexPath.row) is String{
            
            // Checking if image has been previously cached
            if (ProjectManager.sharedInstance.image(forKey: itemImage.object(at: indexPath.row) as! String)) != nil{
                let cachedImage = ProjectManager.sharedInstance.image(forKey: itemImage.object(at: indexPath.row) as! String)
                cell.fillItemCell(itemImage:cachedImage!, itemName: (itemName.object(at: indexPath.row) as! String))
                
            }else {
                cell.fillItemCell(itemImage:(UIImage(named: "NoImage")?.withRenderingMode(.alwaysOriginal))!,itemName:(itemName.object(at: indexPath.row) as! String))
                
                // Download Image and Caching image
                Alamofire.request(itemImage .object(at: indexPath.row) as! String).responseImage{response in
                    if let image = response.result.value {
                        print("image downloaded: \(image)")
                        cell.fillItemCell(itemImage:image, itemName: self.itemName .object(at: indexPath.row) as! String)
                        
                        // Caching Image
                        ProjectManager.sharedInstance.save(image: image, forKey: self.itemImage .object(at: indexPath.row) as! String)
                        
                    }
                    
                }
            }
        }
        let button = UIButton(frame: CGRect(x: 330, y: 242, width: 30, height: 30))
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 10
        button.setImage((UIImage(named: "favourite")?.withRenderingMode(.alwaysOriginal))!, for: UIControlState.normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.tag = indexPath.row
        cell.addSubview(button)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (view.safeAreaLayoutGuide.layoutFrame.width), height: 300);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        ProjectManager.sharedInstance.itemName = itemName.object(at: indexPath.row) as! String
        ProjectManager.sharedInstance.itemImageLink = itemImage.object(at: indexPath.row) as! String
        ProjectManager.sharedInstance.itemBody = setBody.object(at: indexPath.row) as! String
        ProjectManager.sharedInstance.itemPublished = setPublished.object(at: indexPath.row) as! String
        ProjectManager.sharedInstance.itemQuoter = setQuoter.object(at: indexPath.row) as! String
        ProjectManager.sharedInstance.itemQuote = setQuote.object(at: indexPath.row) as! String
        ProjectManager.sharedInstance.itemCreated = setCreated.object(at: indexPath.row) as! String
        
        
        let detailView = detailViewController(nibName: "detailViewController", bundle: nil)
        detailView.title = "DETAIL"
        navigationController?.pushViewController(detailView, animated: true)
        
    }
    // Parsing the Data
    func initParse (link: String)
    {
        let url = NSURL(string:link)
        let request = URLRequest(url: url! as URL)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            if (error != nil)
            {
                print("Error")
            }
            else if(data != nil)
            {
                self.parseJsonWithData(responseData: data!)
            }else
            {
                print("BIG ERROR")
            }
            DispatchQueue.main.async
                {
                    self.collectionView.reloadData()
            }
            
        })
        task.resume()
    }
    func parseJsonWithData(responseData:Data)
    {
        do {
            let json: NSDictionary = try JSONSerialization.jsonObject(with: responseData, options: []) as! NSDictionary
            
            let jsonObject = (json.value(forKeyPath:"objects") as? NSArray)!
            for items in jsonObject{
                
                let itemTitle = items as! NSDictionary
                let title = (itemTitle.value(forKeyPath:"title") as? String)!
                itemName.add(title)
                
                let imageUrls = (itemTitle.value(forKeyPath:"image_urls") as? NSArray)!
                if imageUrls.count > 0{
                    let imageLink = "http://feature-code-test.skylark-cms.qa.aws.ostmodern.co.uk:8000\(imageUrls[0] as! String)"
                    itemImageUrl.add(imageLink)
                } else{
                    itemImageUrl.add("NoImageAvailable")
                }
                
                let body = (itemTitle.value(forKeyPath:"body") as? String)!
                setBody.add(body)
                
                let publish = (itemTitle.value(forKeyPath:"publish_on") as? String)!
                setPublished.add(publish)
                
                let quoter = (itemTitle.value(forKeyPath:"quoter") as? String)!
                setQuoter.add(quoter)
                
                let quote = (itemTitle.value(forKeyPath:"quote") as? String)!
                setQuote.add(quote)
                
                let created = (itemTitle.value(forKeyPath:"created") as? String)!
                setCreated.add(created)
                
                
                
                
                
                
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        
        // Getting Image link
        
        for i in 0...itemImageUrl.count-1{
            
            let link = self.itemImageUrl[i] as! String
            if link == "NoImageAvailable"{
                self.itemImage.add("NoImageAvailable")
            }else{
                self.initParse2(link: link)
                //Thread.sleep(forTimeInterval: 1.0)
            }
            print("DONE")
            
        }
        print(itemImageUrl)
    }
    func initParse2(link: String)
    {
        let url = NSURL(string:link)
        let request = URLRequest(url: url! as URL)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            if (error != nil)
            {
                print("Error")
            }
            else if(data != nil)
            {
                self.parseJsonWithData2(responseData: data!)
            }else
            {
                print("BIG ERROR")
            }
            DispatchQueue.main.async
                {
                    self.collectionView.reloadData()
            }
            
        })
        task.resume()
    }
    func parseJsonWithData2(responseData:Data)
    {
        do {
            let json: NSDictionary = try JSONSerialization.jsonObject(with: responseData, options: []) as! NSDictionary
            let jsonObject = (json.value(forKeyPath:"url") as? String)!
            itemImage.add(jsonObject)
            //  print(itemImage)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
    }
    
    @objc func buttonAction(sender:UIButton!){
        var doubleTap : Bool! = true
        if (doubleTap) {
            doubleTap = false
            ProjectManager.sharedInstance.faveItemName.add(itemName.object(at: sender.tag))
            ProjectManager.sharedInstance.faveItemImageUrl.add(itemImage.object(at: sender.tag))
            sender.backgroundColor = UIColor.black
        } else {
            doubleTap = true
            
        }
        
    }
    
    
}
