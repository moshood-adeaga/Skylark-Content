//
//  TableViewCell2.swift
//  Skylark-Content1
//
//  Created by Moshood Adeaga on 09/04/2018.
//  Copyright © 2018 Moshood Adeaga. All rights reserved.
//

import UIKit

class TableViewCell2: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var bodyTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        detailImageView?.layer.cornerRadius = 30
        detailImageView?.layer.borderWidth = 4
        detailImageView?.layer.borderColor = UIColor.black.cgColor
        detailImageView.clipsToBounds = true
        titleLabel.layer.borderWidth = 4
        titleLabel.layer.borderColor = UIColor.black.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
