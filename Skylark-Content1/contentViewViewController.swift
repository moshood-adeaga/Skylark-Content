//
//  contentViewViewController.swift
//  Skylark-Content1
//
//  Created by Moshood Adeaga on 09/04/2018.
//  Copyright © 2018 Moshood Adeaga. All rights reserved.
//

import UIKit

class contentViewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Variables Declaration
    var itemName = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting delegates and datasource for collectionview
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // Registering Collectionview Cell for use 
        let nibName = UINib(nibName: "itemCell", bundle:nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "CELL")
        
        let setsLink = "http://feature-code-test.skylark-cms.qa.aws.ostmodern.co.uk:8000/api/sets/"
        initParse(link: setsLink)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.collectionView.reloadData()
    }
    
    // Collection View Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section:Int)->Int
    {
        return itemName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:IndexPath)->UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! itemCell
        cell.fillItemCell(itemImage:(UIImage(named: "favourite")?.withRenderingMode(.alwaysOriginal))!
            , itemName: (itemName.object(at: indexPath.row) as! String))
        cell.clipsToBounds = true
       
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (view.safeAreaLayoutGuide.layoutFrame.width), height: 300);
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
               
            }
            print(itemName)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
            
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
    }
    
    
    
}
