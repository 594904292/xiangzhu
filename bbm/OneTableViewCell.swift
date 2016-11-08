//
//  OneTableViewCell.swift
//  bbm
//
//  Created by songgc on 16/8/16.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class OneTableViewCell: UITableViewCell {
    var headface:UIImageView!
    var username:UILabel!
    var seximg:UIImageView!
    var statusimg:UIImageView!
    var street:UILabel!
    var distance:UILabel!
    var timesgo:UILabel!
    
    var content:UILabel!
    
    
    var fgview:UIView!
    var imgview:UIView!

    
    var clickBtn:UILabel!
    var tag1:UILabel!
    var tag2:UILabel!
    
     var delimg:UIImageView!
    var tag1img:UIImageView!
    var tag2img:UIImageView!
    
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
            
            seximg = UIImageView.init(frame: CGRect(x: 100, y: toph+5, width: 10, height: 15))
            seximg.image=UIImage(named: "xz_nan_icon")
            self.contentView.addSubview(seximg)
            
            
            
            
            //var w=self.superview?.frame.size.width
            let a=UIScreen.main.bounds.width
            let aa  = a-70
            statusimg = UIImageView.init(frame: CGRect(x: aa, y: toph+5, width: 70, height: 70))
            statusimg.image=UIImage(named: "xz_qiuzhu_icon")
            self.contentView.addSubview(statusimg)
            
            
            
            street = UILabel.init(frame: CGRect(x: 65, y: toph+28, width: 200, height: 30))
            street.font = UIFont.systemFont(ofSize: 14)
            street.text="东三旗"
            street.textColor=UIColor.lightGray
            

            self.contentView.addSubview(street)
            
            
            let options1:NSStringDrawingOptions = .usesLineFragmentOrigin
            let streetRect = street.text!.boundingRect(with: CGSize(width: 100, height: 0), options: options1, attributes:[NSFontAttributeName:street.font], context: nil)
            
            
            distance = UILabel.init(frame: CGRect(x: streetRect.size.width+65, y: toph+28, width: 80, height: 30))
            distance.text="三公里"
            distance.font = UIFont.systemFont(ofSize: 14)
            distance.textColor=UIColor.lightGray

            self.contentView.addSubview(distance)
            
            timesgo = UILabel.init(frame: CGRect(x: 202, y: toph+28, width: 120, height: 30))
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
            content.frame = CGRect(x: 10, y: toph+33, width: UIScreen.main.bounds.width-20, height: boundingRect.height)
            content.numberOfLines = 2;
            //content.lineBreakMode = NSLineBreakMode.ByWordWrapping
            content.lineBreakMode=NSLineBreakMode.byTruncatingTail

            
            
            self.contentView.addSubview(content)
            
            let img_posy = CGFloat(toph+105);
            imgview=UIView.init(frame: CGRect(x: 10, y: img_posy, width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.width/4))
            //imgview.backgroundColor=UIColor.greenColor()
            self.contentView.addSubview(imgview)

            
            let bottom_posy = img_posy+UIScreen.main.bounds.width/4;
            
            delimg = UIImageView.init(frame: CGRect(x: 10, y: bottom_posy+10, width: 10, height: 10))
            delimg.image=UIImage(named: "xz_la_icon")
            self.contentView.addSubview(delimg)
            
            clickBtn = UILabel.init(frame: CGRect(x: 20, y: bottom_posy, width: 60, height: 30))
                //UILabel(frame: CGRectMake(20, bottom_posy, 60, 30))
            //用户交互功能打开状态
            clickBtn.text="删除"

           
            
            clickBtn?.font = UIFont.systemFont(ofSize: 14)
            clickBtn.textColor=UIColor.black
            self.contentView.addSubview(clickBtn)
            
            tag1img = UIImageView.init(frame: CGRect(x: UIScreen.main.bounds.width-193, y: bottom_posy+10, width: 18, height: 10))
            tag1img.image=UIImage(named: "xz_yan_icon")
            self.contentView.addSubview(tag1img)
            

            tag1 = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width-175, y: bottom_posy, width: 80, height: 30))
            tag1.text="浏览:67次"
            tag1.font = UIFont.systemFont(ofSize: 14)
            self.contentView.addSubview(tag1)
            
            
            tag2 = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width-80, y: bottom_posy, width: 80, height: 30))
            tag2.text="评价:12次"
            tag2.font = UIFont.systemFont(ofSize: 14)
            
            self.contentView.addSubview(tag2)
            
            
            tag2img = UIImageView.init(frame: CGRect(x: UIScreen.main.bounds.width-100, y: bottom_posy+10, width: 20, height: 15))
            tag2img.image=UIImage(named: "xz_xin_icon")
            self.contentView.addSubview(tag2img)

            
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
