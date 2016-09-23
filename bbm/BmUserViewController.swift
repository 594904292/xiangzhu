//
//  BmUserViewController.swift
//  bbm
//
//  Created by songgc on 16/3/30.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class BmUserViewController: UIViewController,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var _tableview: UITableView!
    var items:[ItemBm]=[]
    var isbm:DarwinBoolean = false
    var guid:String = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="帮助我的人"
        // Do any additional setup after loading the view.
        initnavbar("帮助我的人")

        _tableview.delegate=self
        _tableview.dataSource=self
        _tableview.estimatedRowHeight = 150
        //setSeparatorInset:UIEdgeInsetsMake
        _tableview.rowHeight = UITableViewAutomaticDimension
        
       _tableview.separatorStyle = UITableViewCellSeparatorStyle.None
        querydata();
    }
    
    func initnavbar(titlestr:String)
    {
        self.navigationItem.title=titlestr
        var returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.Plain, target: self,  action: #selector(BmUserViewController.backClick))
        
        item3.tintColor=UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem=item3
        
        
        
        
        var searchimg=UIImage(named: "xz_nav_icon_search")
        
        let item4=UIBarButtonItem(image: searchimg, style: UIBarButtonItemStyle.Plain, target: self,  action: "searchClick")
        
        item4.tintColor=UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem=item4
    }
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func searchClick()
    {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("souviewcontroller") as! SouViewController
        self.navigationController?.pushViewController(vc, animated: true)
        //var vc = SearchViewController()
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     
    func querydata()
    {
            var url:String="http://api.bbxiaoqu.com/getbmuserlist_v1.php?guid=".stringByAppendingString(guid);
            print("url: \(url)")
            Alamofire.request(.GET, url, parameters: nil).responseJSON
            { response in
                if(response.result.isSuccess)
                {
                    if let jsonItem = response.result.value as? NSArray{
                        for data in jsonItem{
                            print("data: \(data)")
                            let id:String = data.objectForKey("id") as! String;
                            let userid:String = data.objectForKey("userid") as! String;
                            let senduserid:String = data.objectForKey("senduserid") as! String;
                            let username:String = data.objectForKey("username") as! String;
                            let telphone:String = data.objectForKey("telphone") as! String;
                            let headface:String = data.objectForKey("headface") as! String;
                            let sex:String = data.objectForKey("sex") as! String;
                            let guid:String = data.objectForKey("guid") as! String;
                            let infoid:String = data.objectForKey("infoid") as! String;
                            let type:String = data.objectForKey("type") as! String;
                            let content:String = data.objectForKey("content") as! String;
                            let contentid:String = data.objectForKey("contentid") as! String;
                            let status:String = data.objectForKey("status") as! String;
                            if(self.isbm==false)
                            {
                                if(status != "0")
                                {
                                    self.isbm=true
                                }
                            }
                            let  item_obj:ItemBm = ItemBm(id: id, userid: userid, senduserid: senduserid, username: username, telphone: telphone, headface: headface, sex: sex, guid: guid, infoid: infoid, type: type, content: content, contentid: contentid, status: status)
                            //let item_obj:ItemBm = ItemBm(id: id, userid: userid, username: username, telphone: telphone, headface: headface, status: status)
                            self.items.append(item_obj)
                        
                        }
                        self._tableview.reloadData()
                    
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
            }
                
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat
    {
        //计算行高，返回，textview根据数据计算高度
            var fixedWidth:CGFloat = 176;
            var contextLab:UITextView=UITextView()
            contextLab.text=(items[indexPath.row] as ItemBm).content
            var newSize:CGSize = contextLab.sizeThatFits(CGSizeMake(fixedWidth, 123));
            var height=(newSize.height)
            print("height---\(height)")
            return height+80
          }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return self.items.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var ppp:String = (items[indexPath.row] as itemMess).photo;
        let cellId="bmcell"
        var cell:BmuserUITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as! BmuserUITableViewCell?
        if(cell == nil)
        {
            cell = BmuserUITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
        }
        
        var avatar:String = (items[indexPath.row] as ItemBm).headface;
        
        var head = "http://api.bbxiaoqu.com/uploads/".stringByAppendingString(avatar)
        Util.loadheadface((cell?.headface)!,url: head);
        cell?.headface.layer.cornerRadius = (cell?.headface.frame.width)! / 2
        cell?.headface.layer.masksToBounds = true
        cell?.username.text=(items[indexPath.row] as ItemBm).username
        
        let string:NSString = (items[indexPath.row] as ItemBm).username
        let options:NSStringDrawingOptions = .UsesLineFragmentOrigin
        let boundingRect = string.boundingRectWithSize(CGSizeMake(200, 0), options: options, attributes:[NSFontAttributeName:UIFont(name: "Heiti SC", size: 18.0)!], context: nil)

        
        var sex:String=(items[indexPath.row] as ItemBm).sex
        if sex=="0"
        {
            cell?.sex.image=UIImage(named: "xz_nan_icon");
        }else
        {
            cell?.sex.image=UIImage(named: "xz_nv_icon");
        }
        var posx=(cell?.username.frame.origin.x)!+boundingRect.width+10
        cell?.sex.frame=CGRectMake(posx, 5, 15, 15)
        
       var typestr:String=(items[indexPath.row] as ItemBm).type
        
        cell?.type.layer.masksToBounds = true;
        cell?.type.layer.cornerRadius = 5
        if typestr=="pl"
        {
            cell?.type.text="来自私聊"
        }else
        {
           cell?.type.hidden=true
        }
        
        cell?.content.text=(items[indexPath.row] as ItemBm).content
        cell?.content.backgroundColor=UIColor(colorLiteralRed: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        cell?.content.layer.masksToBounds = true;
        cell?.content.layer.cornerRadius = 3

       // cell?.content.textColor=UIColor(colorLiteralRed: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        

        if(self.isbm)
        {
             //cell?.zanbtn.titleLabel?.textColor=UIColor(colorLiteralRed: 183/255.0, green: 80/255.0, blue: 76/255.0, alpha: 1)
            cell?.zanbtn.enabled=false;
            if((items[indexPath.row] as ItemBm).status=="0")
            {
                cell?.zanbtn.hidden=true;
            }else if((items[indexPath.row] as ItemBm).status=="1")
            {
                 cell?.zanbtn.hidden=false;
                cell?.zanbtn.setTitle("已采纳", forState: UIControlState.Normal)
                
            }
        }else
        {
           // cell?.zanbtn.titleLabel?.textColor=UIColor(colorLiteralRed: 183/255.0, green: 80/255.0, blue: 76/255.0, alpha: 1)

            cell?.zanbtn.tag = indexPath.row
            

                    
            cell?.zanbtn.addTarget(self,action:Selector("tapped:"),forControlEvents:.TouchUpInside)
        }
        
        //cell?.zanbtn.titlePositionAdjustment=UIOffset(horizontal: 0,vertical: -6)
       
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("select \(indexPath.row)")
        //NSLog("select \(items[indexPath.row])")
        
        
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("userinfoviewcontroller") as! UserInfoViewController
        //创建导航控制器
        vc.userid=(items[indexPath.row] as ItemBm).userid
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    var selpos:Int=0;
    func tapped(button:UIButton){
            //print(button.titleForState(.Normal))
        selpos = button.tag
        //self.setupSendPanel1()
        
        
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("appraiseviewcontroller") as! AppraiseViewController
        //创建导航控制器
        vc.id=(items[selpos] as ItemBm).id
        vc.guid=(items[selpos] as ItemBm).guid
        vc.infoid=(items[selpos] as ItemBm).infoid
        vc.username=(items[selpos] as ItemBm).username
        vc.headface=(items[selpos] as ItemBm).headface
        vc.senduserid=(items[selpos] as ItemBm).senduserid
        vc.type=(items[selpos] as ItemBm).type
        vc.content=(items[selpos] as ItemBm).content
        vc.contentid=(items[selpos] as ItemBm).contentid
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
            
    

    var sendView:UIView!;
    var txtMsg:UITextField!;
    var rate:RatingBar!;
    func setupSendPanel1()
    {
                self.sendView = UIView(frame:CGRectMake(0,self.view.frame.size.height-102,self.view.frame.size.width,102))
                self.sendView.backgroundColor=UIColor(colorLiteralRed: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
                self.sendView.alpha=0.9
                self.sendView.layer.borderWidth=1
                self.sendView.layer.borderColor = UIColor.grayColor().CGColor
    
                rate = RatingBar(frame:CGRectMake(7,10,self.view.frame.size.width/2,36))
                rate.rating=CGFloat(4.00)
                self.sendView.addSubview(rate)
    
                txtMsg = UITextField(frame:CGRectMake(7,56,self.view.frame.size.width-84,36))
                txtMsg.backgroundColor = UIColor.whiteColor()
                txtMsg.textColor=UIColor.blackColor()
                txtMsg.font=UIFont.boldSystemFontOfSize(12)
                txtMsg.layer.cornerRadius = 10.0
                txtMsg.placeholder = "输入消息内容"
                self.sendView.addSubview(txtMsg)
    
    
                let sendButton = UIButton(frame:CGRectMake(self.view.frame.size.width-66,56,66,36))
                sendButton.backgroundColor=UIColor.lightGrayColor()
                sendButton.layer.cornerRadius=6.0
                sendButton.addTarget(self, action:Selector("send") ,forControlEvents:UIControlEvents.TouchUpInside)
                 sendButton.setTitle("发送", forState:UIControlState.Normal)
        
                self.sendView.addSubview(sendButton)
    
                self.view.addSubview(sendView)
    
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:"handleTouches:")
                tapGestureRecognizer.cancelsTouchesInView = false
                self.view.addGestureRecognizer(tapGestureRecognizer)
                

                
                NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyBoardWillShow:", name:UIKeyboardWillShowNotification, object: nil)
                NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyBoardWillHide:", name:UIKeyboardWillHideNotification, object: nil)
    
    }
    func close()
    {
                    if(sendView != nil)
                {
                     sendView.hidden=true
                    }
    }
    
    func send()
    {
    //
        if(txtMsg.text?.characters.count==0)
        {
            self.successNotice("评价不能为空")
            return;
        }
        var sqlitehelpInstance1=sqlitehelp.shareInstance()
        
        let defaults = NSUserDefaults.standardUserDefaults();
        var userid = defaults.objectForKey("userid") as! String;
        
        var  dic:Dictionary<String,String> =  ["_guid": guid]
        
        dic["_fromuser"] = userid
        dic["_userid"] = (items[selpos] as ItemBm).userid
        dic["_status"] = "2"
        dic["_rating"] = String(rate.rating)
        dic["_content"] = txtMsg.text
        Alamofire.request(.POST, "http://api.bbxiaoqu.com/genfinshorder.php", parameters: dic)
            
            .response { (request, response, data, error) in
        
                let tn:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                print(tn)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                     self.successNotice("评论成功")
                    
                    if(self.sendView != nil)
                    {
                        self.sendView.hidden=true
                    }

                });
        }

        

    }
    
    func sendMessage()
    {
    }
   
    func textFieldShouldReturn(textField:UITextField) -> Bool
    {
                    
        return true
    }

    func keyBoardWillShow(note:NSNotification)
    {
        let userInfo  = note.userInfo as! NSDictionary
        var  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        var keyBoardBoundsRect = self.view.convertRect(keyBoardBounds, toView:nil)
        var keyBaoardViewFrame = sendView.frame
        var deltaY = keyBoardBounds.size.height
        let animations:(() -> Void) = {
                        self.sendView.transform = CGAffineTransformMakeTranslation(0,-deltaY)
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    
    func keyBoardWillHide(note:NSNotification)
    {
        let userInfo  = note.userInfo as! NSDictionary
         let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations:(() -> Void) = {
            self.sendView.transform = CGAffineTransformIdentity
         }
         if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
         }else{
            animations()
        }
     }
    
    func handleTouches(sender:UITapGestureRecognizer){
        if sender.locationInView(self.view).y < self.view.bounds.height - 250{
                            txtMsg.resignFirstResponder()
                            //close()
        }
    }

}
