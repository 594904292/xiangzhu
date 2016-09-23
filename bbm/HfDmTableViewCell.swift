//
//  HfDmTableViewCell.swift
//  bbm
//
//  Created by songgc on 16/9/19.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class HfDmTableViewCell: UITableViewCell {

    @IBOutlet weak var xiaoqupic: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
