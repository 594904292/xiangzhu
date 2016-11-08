
import UIKit
import Alamofire
class SimTableViewCell:UITableViewCell
{
    //消息内容视图
    var customView:UIView!
    //消息背景
    var bubbleImage:UIImageView!
    //头像
    var avatarImage:UIImageView!
    //消息数据结构
    var msgItem:SimMessageItem!
    
    //消息时间视图
    var customtimeView:UIView!
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    //- (void) setupInternalData
    init(data:SimMessageItem, reuseIdentifier cellId:String)
    {
        self.msgItem = data
        super.init(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
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
        
        _ =  self.msgItem.mtype
        let width =  self.msgItem.view.frame.size.width
        let height =  self.msgItem.view.frame.size.height
        var x :CGFloat = 0
        
        var y:CGFloat =  0
        //显示用户头像
        if (self.msgItem.logo != "")
        {
            
            let logo =  self.msgItem.logo
            let logou:String = "http://api.bbxiaoqu.com/uploads/" + logo;
            //Alamofire.request(logou).response { (_, _, data, _) -> Void in
              //  if let d = data as? Data!
              //  {
                    //self.avatarImage?.image=UIImage(data: d)
                    //self.avatarImage = UIImageView(image:UIImage(data: d))
                    self.avatarImage = UIImageView()

                    self.avatarImage.layer.cornerRadius = 9.0
                    self.avatarImage.layer.masksToBounds = true
                    self.avatarImage.layer.borderColor = UIColor(white:0.0 ,alpha:0.2).cgColor
                    self.avatarImage.layer.borderWidth = 1.0
                    //别人头像，在左边，我的头像在右边
                    let avatarX:CGFloat =  2
                    //头像居于消息底部
                    let avatarY:CGFloat =  height
                    //set the frame correctly
                    self.avatarImage.frame = CGRect(x: avatarX, y: avatarY, width: 30, height: 30)
                   // self.avatarImage.af_setImage(withURL: URL(String:logou))
                    self.avatarImage.af_setImage(withURL: URL(string: logou)!)
            
                    self.addSubview(self.avatarImage)
              //  }
            //}

            
            
            let delta =  self.frame.size.height - (self.msgItem.insets.top + self.msgItem.insets.bottom
                + self.msgItem.view.frame.size.height)
            if (delta > 0)
            {
                y = delta
            }
            x += 34
        }
        
        self.customView = self.msgItem.view
        self.customView.frame = CGRect(x: x + self.msgItem.insets.left, y: y + self.msgItem.insets.top, width: width, height: height)
        
        self.addSubview(self.customView)
        
        self.customtimeView = self.msgItem.timeview
        self.customtimeView.frame = CGRect(x: x + self.msgItem.insets.left, y: y + self.msgItem.insets.top+12, width: width, height: height)
        
        self.addSubview(self.customtimeView)
        
        
        self.bubbleImage.image = UIImage(named:("yoububble.png"))!.stretchableImage(withLeftCapWidth: 21,topCapHeight:24)
        
        self.bubbleImage.frame = CGRect(x: x, y: y, width: width + self.msgItem.insets.left
            + self.msgItem.insets.right, height: height + self.msgItem.insets.top + self.msgItem.insets.bottom)
    }
}
