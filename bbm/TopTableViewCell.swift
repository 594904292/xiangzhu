//
//  TopTableViewCell.swift
//  bbm
//
//  Created by songgc on 16/3/29.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class TopTableViewCell: UITableViewCell {

    
    @IBOutlet weak var order: UILabel!
    
    @IBOutlet weak var headface: UIImageView!
    
    
    @IBOutlet weak var username: UILabel!
    
    
    @IBOutlet weak var score: RatingBar!
   
    //@IBOutlet weak var rate: RatingBar!
    @IBOutlet weak var seximg: UIImageView!
    //@IBOutlet weak var score: UILabel!
    @IBOutlet weak var nums: UILabel!
    
    
    override func awakeFromNib() {
       
        super.awakeFromNib()
        // Initialization code
        var namestr:String=username.text!
        
        let options:NSStringDrawingOptions = .UsesLineFragmentOrigin
        
        
        
        let boundingRect = namestr.boundingRectWithSize(CGSizeMake(200, 0), options: options, attributes:[NSFontAttributeName:username.font], context: nil)
        
        
        
        var pox=boundingRect.size.width+36+10
        
        seximg.frame = CGRectMake(pox, 20, 10, 15)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
