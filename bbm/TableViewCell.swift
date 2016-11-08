

import UIKit
import Alamofire
class TableViewCell:UITableViewCell
{
    var customView:UIView!
    var bubbleImage:UIImageView!
    var avatarImage:UIImageView!
    var msgItem:MessageItem!
    
    required init?(coder aDecoder: (NSCoder!)) {
        super.init(coder: aDecoder)
    }
    //- (void) setupInternalData
    init(data:MessageItem, reuseIdentifier cellId:String)
    {
        self.msgItem = data
        super.init(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
        //self.backgroundColor=UIColor.redColor()
        rebuildUserInterface()
    }
    
    
    func rebuildUserInterface()
    {
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        if (self.bubbleImage == nil)
        {
            self.bubbleImage = UIImageView()
            self.addSubview(self.bubbleImage)
            
        }
        let type =  self.msgItem.mtype
        let screenw = UIScreen.main.bounds.size.width
        self.frame.size.width=screenw;//针对大屏要重设frame.size.width
        _ =  self.frame.size.width
        let width =  self.msgItem.view.frame.size.width
        let height =  self.msgItem.view.frame.size.height
        
         var x =  (type == ChatType.someone) ? 0 : self.frame.size.width - width - self.msgItem.insets.left - self.msgItem.insets.right
        
        
        var y:CGFloat =  0
        //if we have a chatUser show the avatar of the YDChatUser property
        //if (self.msgItem.user.username != "")
        //{
            let thisUser =  self.msgItem.user
            let picname:String = thisUser.avatar
            if(picname.characters.count>0)
            {
                let logo = "http://api.bbxiaoqu.com/uploads/" + picname;
//                Alamofire.request( logo,method:HTTPMethod.get).response { (_, _, data, _) -> Void in
//                    if let d = data as? Data!
//                    {
                        //self.avatarImage?.image=UIImage(data: d)
                        //self.avatarImage = UIImageView(image:UIImage(data: d))
                        self.avatarImage = UIImageView()
                        self.avatarImage.layer.cornerRadius = 25
                        self.avatarImage.layer.masksToBounds = true
                        self.avatarImage.layer.borderColor = UIColor(white:0.0 ,alpha:0.2).cgColor
                        self.avatarImage.layer.borderWidth = 1.0
                
                                               //别人头像，在左边，我的头像在右边
                       let avatarX =  (type == ChatType.someone) ? 2 : self.frame.size.width - 52
                        //头像消息底部
                        let avatarY =  height
                        //set the frame correctly
                        self.avatarImage.frame = CGRect(x: avatarX, y: avatarY, width: 50, height: 50)
                
                        self.avatarImage.af_setImage(withURL: URL(string:logo)!)

                
                        self.addSubview(self.avatarImage)
//                    }
//                }
                let delta =  self.frame.size.height - (self.msgItem.insets.top + self.msgItem.insets.bottom + self.msgItem.view.frame.size.height)
                print("delta:\(delta)")
                if (delta > 0)
                {
                    y = delta
                }
                if (type == ChatType.someone)
                {
                    x += 54
                }
                if (type == ChatType.mine)
                {
                    x -= 54
                }
            }else
            {
                
                 self.avatarImage = UIImageView(image:UIImage(named: "xz_wo_icon"))
                self.avatarImage.layer.cornerRadius = self.avatarImage.frame.width/2
                self.avatarImage.layer.masksToBounds = true
                //self.avatarImage.layer.borderColor = UIColor(white:0.0 ,alpha:0.2).CGColor
               // self.avatarImage.layer.borderWidth = 1.0
                        //别人头像，在左边，我的头像在右边
                let avatarX =  (type == ChatType.someone) ? 2 : self.frame.size.width - 52
                        //头像消息底部
                let avatarY =  height
                        //set the frame correctly
                self.avatarImage.frame = CGRect(x: avatarX, y: avatarY, width: 50, height: 50)
                self.addSubview(self.avatarImage)
                
                let delta =  self.frame.size.height - (self.msgItem.insets.top + self.msgItem.insets.bottom + self.msgItem.view.frame.size.height)
                if (delta > 0)
                {
                    y = delta
                }
                if (type == ChatType.someone)
                {
                    x += 54
                    //x = 54
                }
                if (type == ChatType.mine)
                {
                    x -= 54

                }
            }
        //}
        print("x:\(x)")
        print("Y:\(y)")
        //self.customView.removeFromSuperview()
        self.customView = self.msgItem.view
        self.customView.frame = CGRect(x: x + self.msgItem.insets.left, y: y + self.msgItem.insets.top, width: width, height: height)
        
        self.addSubview(self.customView)
        
        //depending on the ChatType a bubble image on the left or right
        if (type == ChatType.someone)
        {
            self.bubbleImage.image = UIImage(named:("yoububble.png"))!.stretchableImage(withLeftCapWidth: 21,topCapHeight:14)
            
        }
        else {
            self.bubbleImage.image = UIImage(named:"mebubble.png")!.stretchableImage(withLeftCapWidth: 15, topCapHeight:14)
        }
        self.bubbleImage.frame = CGRect(x: x, y: y, width: width + self.msgItem.insets.left + self.msgItem.insets.right, height: height + self.msgItem.insets.top + self.msgItem.insets.bottom)
    }
    
    
}
