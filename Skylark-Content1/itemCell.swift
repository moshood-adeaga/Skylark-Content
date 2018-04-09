//
//  itemCell.swift
//  Skylark-Content1
//
//  Created by Moshood Adeaga on 09/04/2018.
//  Copyright © 2018 Moshood Adeaga. All rights reserved.
//

import UIKit

class itemCell: UICollectionViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        itemImageView?.layer.cornerRadius = 60
        itemImageView?.layer.borderWidth = 4
        itemImageView?.layer.borderColor = UIColor.black.cgColor


    }
    func fillItemCell (itemImage:UIImage, itemName:String)
    {
        self.itemTitle.text = itemName
        self.itemImageView?.image = itemImage
    }
}
