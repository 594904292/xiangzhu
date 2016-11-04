//
//  NoticeTableViewCell.swift
//  bbm
//
//  Created by songgc on 16/8/18.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {

    @IBOutlet weak var notice_img: UIImageView!
    
    @IBOutlet weak var notice_catagory: UILabel!
    
    @IBOutlet weak var notice_content: UILabel!
    @IBOutlet weak var notice_time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
