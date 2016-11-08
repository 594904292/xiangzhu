//
//  OneTableViewCell.swift
//  bbm
//
//  Created by songgc on 16/8/16.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class OneTableViewCellForGg: UITableViewCell {
    var headface:UIImageView!
    var username:UILabel!
    var timesgo:UILabel!
    
    var content:UILabel!
    
    
    var fgview:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            let toph=CGFloat(15);
            let topfgview:UIView=UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: toph))
            topfgview.backgroundColor=UIColor(colorLiteralRed: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
            
            self.contentView.addSubview(topfgview)

            
            headface = UIImageView.init(frame: CGRect(x: 10, y: toph+5, width: 45, height: 45))
            headface.image=UIImage(named: "xz_xiang_icon")
            self.contentView.addSubview(headface)
           

            
            username = UILabel.init(frame: CGRect(x: 65, y: toph+5, width: 200, height: 30))
            self.contentView.addSubview(username)
            
            
            
            
            
            
            
            
            timesgo = UILabel.init(frame: CGRect(x: 65, y: toph+28, width: 200, height: 30))
            timesgo.text="2小时前"
            timesgo.font = UIFont.systemFont(ofSize: 14)
            timesgo.textColor=UIColor.lightGray
            self.contentView.addSubview(timesgo)
            
            fgview=UIView.init(frame: CGRect(x: 10, y: toph+65, width: UIScreen.main.bounds.width-20, height: 1))
            fgview.backgroundColor=UIColor(colorLiteralRed: 215/255.0, green: 212/255.0, blue: 212/255.0, alpha: 1)
            self.contentView.addSubview(fgview)
            

            
            
            
            content = UILabel.init()
            //content.backgroundColor = UIColor.grayColor()
            content.text = "1234567890edfdgddffgfgfggfggddfbyfru6y6r7iuymgnjnrtfugyu57t6injyunjokn89uilmghbjl,hknjlllllllllllllllllllllllllllllllllllllmimomomkjnijunbuygbtyfrtdrxcresxweaswa"
            
            content.font = UIFont.systemFont(ofSize: 14)
            //content.textColor = UIColor.redColor()
            let string:NSString = content.text! as NSString
            let options:NSStringDrawingOptions = .usesLineFragmentOrigin
            let boundingRect = string.boundingRect(with: CGSize(width: 200, height: 0), options: options, attributes:[NSFontAttributeName:content.font], context: nil)
            //content.frame = CGRectMake(10, toph+33, UIScreen.mainScreen().applicationFrame.width-20, boundingRect.height)
            content.frame = CGRect(x: 10, y: toph+33, width: UIScreen.main.bounds.width-20, height: boundingRect.height)
            content.numberOfLines = 10;
            //content.lineBreakMode = NSLineBreakMode.ByWordWrapping
            //content.lineBreakMode=NSLineBreakMode.ByTruncatingTail

            
            
            self.contentView.addSubview(content)
            
          
            
        }
    }
    
    
//    func labelSize(text:String ,attributes : [NSObject : AnyObject]) -> CGRect{
//        var size = CGRect();
//        var size2 = CGSize(width: 100, height: 0);//设置label的最大宽度
//        size = text.boundingRectWithSize(size2, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes , context: nil);
//        return size
//    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
