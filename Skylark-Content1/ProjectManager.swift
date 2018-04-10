//
//  ProjectManager.swift
//  Skylark-Content1
//
//  Created by Moshood Adeaga on 09/04/2018.
//  Copyright © 2018 Moshood Adeaga. All rights reserved.
//

import UIKit

class ProjectManager: NSObject {
    
    
    
    //Shared Instance
    static let sharedInstance : ProjectManager = {
        
        let instance = ProjectManager()
        return instance
    }()
    
    // Variable Declaration
    private let cache = NSCache<NSString, UIImage>()
    //favourite Tab Variables
    let faveItemName = NSMutableArray()
    let faveItemImageUrl = NSMutableArray()
    //DetailView Variable
    var itemName = String()
    var itemImageLink = String()
    var itemBody = String()
    var itemPublished = String()
    var itemQuoter = String()
    var itemQuote = String()
    var itemCreated = String()
    
    
    
    // Saving and Retrieving cached Images.
    func image(forKey key: String) -> UIImage?
    {
        return cache.object(forKey: key as NSString)
    }
    
    func save(image: UIImage, forKey key: String)
    {
        cache.setObject(image, forKey: key as NSString)
    }
}
