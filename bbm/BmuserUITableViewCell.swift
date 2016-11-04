//
//  BmuserUITableViewCell.swift
//  bbm
//
//  Created by songgc on 16/3/30.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class BmuserUITableViewCell: UITableViewCell {

    
    @IBOutlet weak var headface: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var sex: UIImageView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var zanbtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
