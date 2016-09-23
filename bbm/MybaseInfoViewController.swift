//
//  MybaseInfoViewController.swift
//  bbm
//
//  Created by songgc on 16/8/17.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire


    
class MybaseInfoViewController: UIViewController,UINavigationControllerDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UITextViewDelegate,ChangeXiaoquDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var row1: UIView!
    @IBOutlet weak var row2: UIView!
    
    @IBOutlet weak var row3: UIView!
    
    @IBOutlet weak var row4: UIView!
    
    @IBOutlet weak var row5: UIView!
    
    @IBOutlet weak var headface: UIImageView!
    
    @IBOutlet weak var my_nickname: UILabel!
    
    @IBOutlet weak var my_userid: UILabel!
    

    @IBOutlet weak var iv_photo: UIImageView!
    
    
    @IBOutlet weak var update_nickname: UIView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var update_brithday: UIView!
    
    @IBOutlet weak var brithday_tv: UILabel!
    
    @IBOutlet weak var update_sex: UIView!
    
    
    @IBOutlet weak var sex_tv: UILabel!
    
    @IBOutlet weak var update_tel: UIView!
    
    @IBOutlet weak var telphone_tv: UILabel!
    
    
    @IBOutlet weak var update_weixin: UIView!
    
    @IBOutlet weak var weixin_tv: UILabel!
    
    @IBOutlet weak var update_xiaoqu: UIView!
    
    @IBOutlet weak var xiaoqu_tv: UILabel!
    
    @IBOutlet weak var update_othertel: UIView!
    
    @IBOutlet weak var emergencycontact_tv: UILabel!
    
    @IBOutlet weak var update_remess: UIView!
    
    @IBOutlet weak var switch_remess: UISwitch!
    
    @IBOutlet weak var SystenSetting: UIView!
    @IBOutlet weak var update_share: UIView!
    
    @IBOutlet weak var exit: UIView!
    
    var fullPath:String = "";
    var img = UIImage()
    var community:String = "";

    var community_id:String = "";

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        scrollView.delegate = self
        //scrollView.frame=self.view.bounds
        
        //为了让内容横向滚动，设置横向内容宽度为3个页面的宽度总和
        
        //var pageWidth=self.view.frame.size.width
        let pageHeight=self.view.frame.size.height
        
        
        var screenpageHeight=UIScreen.mainScreen().applicationFrame.size.height
        var aaa = self.view.frame.size.height - 210
        scrollView.frame=CGRectMake(0,0,self.view.frame.size.width,CGFloat(aaa));
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,pageHeight*3);
        
        self.scrollView.contentInset=UIEdgeInsetsMake(0, 0, 210, 0)

        self.scrollView.showsHorizontalScrollIndicator = false;
        scrollView.scrollsToTop = false
        headface.layer.cornerRadius = (headface.frame.width) / 2
        headface.layer.masksToBounds = true
        
        
        iv_photo.layer.cornerRadius = (iv_photo.frame.width) / 2
        iv_photo.layer.masksToBounds = true
  
        var rect  =  UIScreen.mainScreen().applicationFrame
        var posx = rect.width / 3;
        
        var ww = rect.width / 3;
        
        var posy = CGFloat(10)
        
        row2.backgroundColor=UIColor.whiteColor()
        addtagarea(1,posx: 2,posy: 0,w: ww-4,h: 60)
        addtagarea(3,posx: posx+2,posy: 0,w: ww-4,h: 60)
        addtagarea(5,posx: posx*2+2,posy: 0,w: ww-4,h: 60)
        addline(posx,posy: posy)
        addline(posx*2,posy: posy)
        
        
      
        let defaults = NSUserDefaults.standardUserDefaults();
        let userid = defaults.objectForKey("userid") as! NSString;
        loaduserinfo(userid as String)
        loadusersummaryinfo(userid as String)
        /////////////////////////////
        modifyheadface()//修改头像
        modifynickname()//修改头像
        modifybrithday()//修改头像
        modifysex()//修改头像
        modiftel()//修改头像
        modifweixin()//修改头像
        modifxiaoqu()//修改头像
        modifshare()//修改头像
        modifothertel()//修改头像
        
        ///////////
         AddsugguestClick()//修改头像
      
        AddexitClick()//修改头像
        

    }
    
    func modifyheadface()
    {
        iv_photo.userInteractionEnabled = true
        
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "goImagesel")
         iv_photo .addGestureRecognizer(singleTap)
    }
    
    func modifynickname()
    {
        update_nickname.userInteractionEnabled = true
        
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "gomodiffynickname")
        update_nickname .addGestureRecognizer(singleTap)
    }
    func modifybrithday()
    {
        update_brithday.userInteractionEnabled = true
        
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "gomodifybrithday")
        update_brithday .addGestureRecognizer(singleTap)
    
    }
    func modifysex()
    {
        sex_tv.userInteractionEnabled = true
        
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "gomodifysex")
        sex_tv .addGestureRecognizer(singleTap)
    }
    
    func modiftel()
    {
        update_tel.userInteractionEnabled = true
        
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "gomodifytelphone")
        update_tel .addGestureRecognizer(singleTap)
    }

    
    func modifweixin()
    {
        update_weixin.userInteractionEnabled = true
        
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "gomodifyweixin")
        update_weixin .addGestureRecognizer(singleTap)
    }
    
    func modifxiaoqu()
    {
        update_xiaoqu.userInteractionEnabled = true
        
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "gomodifyxiaoqu")
        update_xiaoqu .addGestureRecognizer(singleTap)
    }
  //    func changeXiaoqu(controller:SouXiaoQuViewController,name:String,code:String)
//    {
//        
//        NSLog("select \(name)")
//
//        xiaoqu_tv.text=name;
//    
//    }
    
    func modifothertel()
    {
        update_othertel.userInteractionEnabled = true
        
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "gomodifyothertel")
        update_othertel .addGestureRecognizer(singleTap)
    }
    
    
    
    func AddsugguestClick()
    {
        
        SystenSetting.userInteractionEnabled = true
        
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "gosugguestaboutViewController")
        SystenSetting .addGestureRecognizer(singleTap)
        
    }
    func modifshare()
    {
        update_share.userInteractionEnabled = true
        
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "gomodifyshare")
        update_share .addGestureRecognizer(singleTap)
    }
    func gosugguestaboutViewController()
    {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("sugguestabout") as! SugguestAboutViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
    func AddexitClick()
    {
        exit.userInteractionEnabled = true
        
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "exitClick")
        exit .addGestureRecognizer(singleTap)
    }
    func updb(field:String,fieldvalue:String)
    {
        NSLog("add")
        let defaults = NSUserDefaults.standardUserDefaults();
        let userid = defaults.objectForKey("userid") as! String;
        
        var  dica:Dictionary<String,String> = ["userid" : userid]
        dica["field"]=field
         dica["fieldvalue"]=fieldvalue
        NSLog(String(dica.count))
        Alamofire.request(.POST, "http://api.bbxiaoqu.com/updateuserfield.php", parameters: dica) .response { request, response, data, error in
            print(request)
            print(response)
            print(error)
            print(data)
            if(error==nil)
            {
                let str:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                
                print(str)
                print(str)
               
                    self.successNotice("修改成功")
                
            }
        }

    }
    
    func gomodiffynickname()
    {
        var nickNameTextField: UITextField?
        // 2.
        let alertController = UIAlertController(
            title: "昵称修改",
            message: "请输入您的新昵称",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        // 3.
        let modifyAction = UIAlertAction(
        title: "确认", style: UIAlertActionStyle.Default) {
            (action) -> Void in
            
            if let usernamestr = nickNameTextField?.text {
                print(" Username = \(usernamestr)")
                self.username.text=usernamestr
                self.updb("username",fieldvalue: usernamestr)
                
            } else {
                print("No Username entered")
            }
        }
        
        // 4.
        alertController.addTextFieldWithConfigurationHandler {
            (txtUsername) -> Void in
            nickNameTextField = txtUsername
            nickNameTextField!.placeholder = "新昵称"
        }
        
        
        // 5.
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler:nil))
        alertController.addAction(modifyAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func gomodifybrithday()
    {
        let alertController:UIAlertController=UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        // 初始化 datePicker
        let datePicker = UIDatePicker( )
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.date = NSDate()
        // 响应事件（只要滚轮变化就会触发）
        // datePicker.addTarget(self, action:Selector("datePickerValueChange:"), forControlEvents: UIControlEvents.ValueChanged)
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default){
            (alertAction)->Void in
            
            
            print("date select: \(datePicker.date.description)")
            
            var formatter:NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            
            var brithday = formatter.stringFromDate(datePicker.date)
            
            NSLog("now:\(brithday)")
            
            var todayDate: NSDate = NSDate()
            // let second =todayDate.timeIntervalSinceDate(<#T##anotherDate: NSDate##NSDate#>)
            let second = todayDate.timeIntervalSinceDate(datePicker.date)
            let year=Int(second/(60*60*24*365))

            
            self.brithday_tv.text=brithday
            
            self.updb("brithday,age",fieldvalue: brithday.stringByAppendingString(",").stringByAppendingString(String(year)))
            //获取上一节中自定义的按钮外观DateButton类，设置DateButton类属性thedate
            //let myDateButton=self.Datebutt as? DateButton
            //myDateButton?.thedate=datePicker.date
            //强制刷新
            //myDateButton?.setNeedsDisplay()
            })
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler:nil))
        
        alertController.view.addSubview(datePicker)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    
    }
    
    var action=""
    
    func gomodifysex()
    {
        action="sex"
        var actionSheet=UIActionSheet()
        //actionSheet.title = "请选择操作"
        actionSheet.addButtonWithTitle("取消")
        actionSheet.addButtonWithTitle("男")
        actionSheet.addButtonWithTitle("女")
        actionSheet.cancelButtonIndex=0
        actionSheet.delegate=self
        actionSheet.showInView(self.view);
    }
    
    
    
    
    func gomodifytelphone()
    {
        var telPhoneTextField: UITextField?
        // 2.
        let alertController = UIAlertController(
            title: "电话修改",
            message: "请输入您的新电话",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        // 3.
        let modifyAction = UIAlertAction(
        title: "确认", style: UIAlertActionStyle.Default) {
            (action) -> Void in
            
            if let username = telPhoneTextField?.text {
                print(" Username = \(username)")
                self.telphone_tv.text=username
                self.updb("telphone",fieldvalue: username)
            } else {
                print("No Username entered")
            }
        }
        
        // 4.
        alertController.addTextFieldWithConfigurationHandler {
            (txtUsername) -> Void in
            telPhoneTextField = txtUsername
            telPhoneTextField!.placeholder = "新电话"
        }
        
        
        // 5.
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler:nil))
        alertController.addAction(modifyAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    
    
    func gomodifyweixin()
    {
        var WeixinTextField: UITextField?
        // 2.
        let alertController = UIAlertController(
            title: "微信修改",
            message: "请输入您的新微信",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        // 3.
        let modifyAction = UIAlertAction(
        title: "确认", style: UIAlertActionStyle.Default) {
            (action) -> Void in
            
            if let username = WeixinTextField?.text {
                print(" Username = \(username)")
                self.weixin_tv.text=username
                self.updb("weixin",fieldvalue: username)

            } else {
                print("No Username entered")
            }
        }
        
        // 4.
        alertController.addTextFieldWithConfigurationHandler {
            (txtUsername) -> Void in
            WeixinTextField = txtUsername
            WeixinTextField!.placeholder = "新微信"
        }
        
        
        // 5.
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler:nil))
        alertController.addAction(modifyAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func gomodifyxiaoqu()
    {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("souxiaoquviewcontroller") as! SouXiaoQuViewController
        vc.delegate=self
        self.navigationController?.pushViewController(vc, animated: true)


    }
    //var returncommunity:String="";
    //var returncommunity_id:String="";
    
    func ChangeXiaoqu(controller:SouXiaoQuViewController,name:String,code:String){
        
            self.xiaoqu_tv.text = name
            NSLog("qzLabel.text == \(name)")
            self.community=name
            self.community_id=code
            //保存到临时数据库
            let defaults = NSUserDefaults.standardUserDefaults();
            defaults.setObject(self.community, forKey: "community");//省直辖市
            defaults.setObject(self.community_id, forKey: "community_id");//省直辖市
            defaults.synchronize();
             //保存到服务器
            self.updb("community,community_id",fieldvalue: self.community.stringByAppendingString(",").stringByAppendingString(String(self.community_id)))
    }

    
    func gomodifyshare()
    {
        let sheet = UIAlertController(title: "襄助 ", message: "分享到微信", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: {(action) -> Void in
            print("cancel share")
        })
        let shareToFriend = UIAlertAction(title: "好友", style: .Destructive, handler: {(action) -> Void in
            self.shareToWChat(WXSceneSession)
        })
        let shareToGroupsFriends = UIAlertAction(title: "朋友圈", style: .Destructive, handler: {(action) -> Void in
            self.shareToWChat(WXSceneTimeline)
        })
        
        sheet.addAction(cancelAction)
        sheet.addAction(shareToFriend)
        sheet.addAction(shareToGroupsFriends)
        self.presentViewController(sheet, animated: true, completion: {() -> Void in
            print("present over")
        })


    }
    
    
    func shareToWChat(scene: WXScene) {
        let page = WXWebpageObject()
        page.webpageUrl =  "http://www.bbxiaoqu.com/wap/about.html";
        let msg = WXMediaMessage()
        msg.mediaObject = page
        msg.title = "襄助何必曾相识"
        msg.description = "襄助是基于位置的是传播正能量的联网互助平台。让附近的人互相帮忙，我们希望把大众的力量组织起来，有一技之长的人可以通过“襄助”为附近的人提供帮助；普通大众可以通过“襄助” 快速寻求帮助。 “涓滴之水成海洋，颗颗爱心变希望”。"
        
    
//        let url = NSURL(string: "http://www.bbxiaoqu.com/pc/img/qrcode.png")
//        //从网络获取数据流
//        let data = NSData(contentsOfURL: url!)
        //let newImage = UIImage(data: data!)
        //downqrcode
//        
 //let newImage = UIImage(named: "downqrcode")
//msg.setThumbImage(newImage)
        
         msg.setThumbImage(UIImage(named: "icon.png"));
        
        let req = SendMessageToWXReq()
        req.message = msg
        req.scene = Int32(scene.rawValue)
        WXApi.sendReq(req)
    }

    func gomodifyothertel()
    {
        var usernameTextField: UITextField?
        var ＴelphoneTextField: UITextField?
        
        // 2.
        let alertController = UIAlertController(
            title: "紧急联系人",
            message: "请输入你的紧急联系人",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        // 3.
        let loginAction = UIAlertAction(
        title: "确认", style: UIAlertActionStyle.Default) {
            (action) -> Void in
            var a=""
            var b=""
            if let usernamestr = usernameTextField?.text {
                print(" Username = \(usernamestr)")
                self.emergencycontact_tv.text=usernamestr
                a=usernamestr;
                
            } else {
                print("No Username entered")
                self.emergencycontact_tv.text="未设置"
            }
            
            if let telstr = ＴelphoneTextField?.text {
                print("tel = \(telstr)")
                 b=telstr;
            } else {
                print("No tel entered")
            }
            
            self.updb("emergencycontact,emergencycontacttelphone",fieldvalue: a.stringByAppendingString(",").stringByAppendingString(b))

            
//            var aa:String="".stringByAppendingString(usernamestr).stringByAppendingString(",").stringByAppendingString(telstr)
//            self.updb("emergencycontact,emergencycontacttelphone",fieldvalue: aa)
        }
        
        // 3.
        let cancleAction = UIAlertAction(
        title: "取消", style: UIAlertActionStyle.Default) {
            (action) -> Void in
            
       
        }

        
        // 4.
        alertController.addTextFieldWithConfigurationHandler {
            (txtUsername) -> Void in
            usernameTextField = txtUsername
            usernameTextField!.placeholder = "紧急联系人"
        }
        
        alertController.addTextFieldWithConfigurationHandler {
            (txtTelphone) -> Void in
            ＴelphoneTextField = txtTelphone
            ＴelphoneTextField!.placeholder = "紧急联系人电话"
        }
        
        // 5.
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler:nil));       alertController.addAction(loginAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    var Numtag:[UILabel] = [];

    
    func addtagarea(index:Int,posx:CGFloat,posy:CGFloat,w:CGFloat,h:CGFloat)
    {
        
        //let posy=CGFloat(row1.f);
        let customView = UIView(frame: CGRect(x: posx+5, y: posy, width:w-10, height: h))
        //customView.backgroundColor=UIColor.greenColor()
        let labnum=UILabel(frame: CGRect(x: 10, y: 10, width:w-20, height: 20))
        
        
        labnum.font = UIFont.systemFontOfSize(18);
        //labnum.backgroundColor = XZA_BACKGROUND_COLOR;
        //labnum.textColor = UIColor.grayColor();
        
        labnum.text = "10";
        labnum.textAlignment = NSTextAlignment.Center;
        labnum.layer.masksToBounds = true;
        
//        labnum.layer.cornerRadius = 3.0;
//        labnum.layer.borderColor = UIColor.lightGrayColor().CGColor;
//        labnum.layer.borderWidth = 0.8;
        
        labnum.numberOfLines = 0;
        labnum.lineBreakMode = NSLineBreakMode.ByCharWrapping;
        
        labnum.tag = index;
        labnum.userInteractionEnabled = true;
        Numtag.append(labnum)
        var tap = UITapGestureRecognizer(target:self, action:"tapLabel:");
        labnum.addGestureRecognizer(tap);

        
        
        
        let labname=UILabel(frame: CGRect(x: 10, y: 30, width:w-20, height: 20))
        labname.font = UIFont.systemFontOfSize(15);
         labname.textAlignment = NSTextAlignment.Center;
        labnum.textColor = UIColor.grayColor();
        if(index==1)
        {
          labname.text="求帮助"
        }else if(index==3)
        {
          labname.text="关注"
        }else if(index==5)
        {
          labname.text="收藏"
        }
        labnum.tag = index;
        labnum.addGestureRecognizer(tap);

        customView.addSubview(labnum)
        customView.addSubview(labname)
        customView.tag = index;
        customView.addGestureRecognizer(tap);

        self.row2.addSubview(customView)
    
    }
    func tapLabel(recognizer:UITapGestureRecognizer){
        let labelView:UIView = recognizer.view!;
        let tapTag:NSInteger = labelView.tag;
        if(tapTag==1)
        {
            var vc = ListViewController()
            vc.selectedTabNumber=2
            self.navigationController?.pushViewController(vc, animated: true)

        }else if(tapTag==3)
        {
            var sb = UIStoryboard(name:"Main", bundle: nil)
            var vc = sb.instantiateViewControllerWithIdentifier("friendsviewcontroller") as! FriendsTableViewController
            self.navigationController?.pushViewController(vc, animated: true)

        }else if(tapTag==5)
        {
            var sb = UIStoryboard(name:"Main", bundle: nil)
            var vc = sb.instantiateViewControllerWithIdentifier("gzinfosviewcontroller") as! GzInfosTableViewController
            self.navigationController?.pushViewController(vc, animated: true)

        }
        
        //let labelString:String = textArray?.objectAtIndex(tapTag) as! String;
    }
    
    func exitClick()
    {
        NSLog("exitClick")
        //exit(0)
        var alertView = UIAlertView()
        alertView.title = "系统提示"
        alertView.message = "您确定要退出吗？"
        alertView.addButtonWithTitle("取消")
        alertView.addButtonWithTitle("确定")
        alertView.cancelButtonIndex=0
        alertView.delegate=self;
        alertView.show()
        
        
    }
    
    
    
    func alertView(alertView:UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if(buttonIndex==alertView.cancelButtonIndex){
            
        }
        else
        {
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
            //创建导航控制器
            let nvc=UINavigationController(rootViewController:vc);
            //设置根视图
            self.view.window!.rootViewController=nvc;
            
        }
    }
    
    
    func addline(posx:CGFloat,posy:CGFloat)
    {
        
        //let posy=CGFloat(row1.f);
        let customView = UIView(frame: CGRect(x: posx, y: posy, width:1, height: 75))
        let imageView=UIImageView(image:UIImage(named:"xz_xi_icon"))
        imageView.frame=CGRectMake(0,0,1,30)
        customView.addSubview(imageView)
        self.row2.addSubview(customView)
    }

    
    override func viewDidLayoutSubviews() {
        
        var rect  =  UIScreen.mainScreen().applicationFrame
        _ = rect.width ;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //scrollView.contentOffset = CGPoint(x: 1000, y: 450)
        //let scrollviewW:CGFloat = galleryScrollView.frame.size.width;

        
    }

    
    func loadusersummaryinfo(userid:String)
    {
        
        var url_str:String = "http://api.bbxiaoqu.com/getusersummary.php?userid=".stringByAppendingString(userid)
        Alamofire.request(.POST,url_str, parameters:nil)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                print(response.result.value)

                if(response.result.isSuccess)
                {
                    if let data = response.result.value{
                             print("data: \(data)")
                            var num1:NSNumber = data.objectForKey("num1") as! NSNumber;
                            var num2:NSNumber = data.objectForKey("num3") as! NSNumber;
                            var num3:NSNumber = data.objectForKey("num5") as! NSNumber;
                            (self.Numtag[0] as UILabel).text=num1.stringValue
                            (self.Numtag[1] as UILabel).text=num2.stringValue
                            (self.Numtag[2] as UILabel).text=num3.stringValue
                            
                       
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }

    }

    
    
    func loaduserinfo(userid:String)
    {
        var url_str:String = "http://api.bbxiaoqu.com/getuserinfo.php?userid=".stringByAppendingString(userid)
        Alamofire.request(.POST,url_str, parameters:nil)
            .responseJSON { response in
                //                print(response.request)  // original URL request
                //                print(response.response) // URL response
                //                print(response.data)     // server data
                //                print(response.result)   // result of response serialization
                print(response.result.value)
                if let JSON = response.result.value {
                    print("JSON1: \(JSON.count)")
                    if(JSON.count==0)
                    {
                        
                    }else
                    {
                        let telphone:String = JSON[0].objectForKey("telphone") as! String;
                        let headfaceurl:String = JSON[0].objectForKey("headface") as! String;
                        let username:String = JSON[0].objectForKey("username") as! String;
                        var age:String;
                        if(JSON[0].objectForKey("age")!.isKindOfClass(NSNull))
                        {
                            age="";
                        }else
                        {
                            age = JSON[0].objectForKey("age") as! String;
                        }
                        
                        var usersex:String;
                        if(JSON[0].objectForKey("sex")!.isKindOfClass(NSNull))
                        {
                            usersex="1";
                        }else
                        {
                            usersex = JSON[0].objectForKey("sex") as! String;
                        }
                        
                        var weixin:String;
                        if(JSON[0].objectForKey("weixin")!.isKindOfClass(NSNull))
                        {
                            weixin="";
                        }else
                        {
                            weixin = JSON[0].objectForKey("weixin") as! String;
                        }
                        
                       
                        if(JSON[0].objectForKey("community")!.isKindOfClass(NSNull))
                        {
                            self.community="";
                        }else
                        {
                            self.community = JSON[0].objectForKey("community") as! String;
                        }
                        
                        if(JSON[0].objectForKey("community_id")!.isKindOfClass(NSNull))
                        {
                            self.community_id="";
                        }else
                        {
                            self.community_id = JSON[0].objectForKey("community_id") as! String;
                        }

                        
                        var emergency:String;
                        if(JSON[0].objectForKey("emergencycontact")!.isKindOfClass(NSNull))
                        {
                            emergency="";
                        }else
                        {
                            emergency = JSON[0].objectForKey("emergencycontact") as! String;
                        }
                        var emergencytelphone:String;
                        if(JSON[0].objectForKey("emergencycontacttelphone")!.isKindOfClass(NSNull))
                        {
                            emergencytelphone="";
                        }else
                        {
                            emergencytelphone = JSON[0].objectForKey("emergencycontacttelphone") as! String;
                        }
                        self.my_nickname.text=username;
                        self.my_userid.text=Util.hiddentelphonechartacter(telphone);
                        self.weixin_tv.text=weixin
                        self.username.text=username;
                        self.telphone_tv.text=telphone;
                        self.xiaoqu_tv.text=self.community;
                        if(usersex=="1")
                        {//男
                            self.sex_tv.text="女";
                        }else
                        {//女
                             self.sex_tv.text="男"
                        }
                        
                        
                        if(JSON[0].objectForKey("brithday")!.isKindOfClass(NSNull))
                        {
                            self.brithday_tv.text="1970-01-01";
                        }else
                        {
                            var brithday:String = JSON[0].objectForKey("brithday") as! String;
                            if(brithday.characters.count<10)
                            {
                                self.brithday_tv.text="1970-01-01";
                            }
                            else
                            {
                            self.brithday_tv.text=brithday;
                            }
                        }
                        if(emergency.characters.count>0)
                        {
                            self.emergencycontact_tv.text=emergency
                        }else
                        {
                            self.emergencycontact_tv.text="未设置"
                        }
                        if(headfaceurl.characters.count>0)
                        {
                            let url="http://api.bbxiaoqu.com/uploads/"+headfaceurl;
                            Util.loadheadface(self.headface, url: url)
                            Util.loadheadface(self.iv_photo, url: url)
                        }else
                        {
                            self.headface?.image = UIImage(named: "logo")
                            self.iv_photo?.image = UIImage(named: "logo")
                        }
                    }
                    
                    
                }
        }
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func goImagesel()
    {
        action="pic"
        let actionSheet = UIActionSheet(title: "图片来源", delegate: self, cancelButtonTitle: "照片", destructiveButtonTitle: "相机")
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if(action=="pic")
        {
        if(buttonIndex==0)
        {
            goCamera()
        }else
        {
            goImage()
        }
        }else
        {//男 1 女2 数据库中 要减1
            if(buttonIndex>0)
            {
            print("点击了："+actionSheet.buttonTitleAtIndex(buttonIndex)!)
            sex_tv.text=actionSheet.buttonTitleAtIndex(buttonIndex)!
                if(buttonIndex==1)
                {
                    self.updb("sex",fieldvalue: "0")

                }else
                {
                    self.updb("sex",fieldvalue: "1")

                }
                
                
            }
        }
    }
    
    var openmessflag=false;
    var openvoiceflag=false;
    @IBAction func openmess(sender: UISwitch) {
        var open:String="0"
        
        if sender.on == true
        {
            self.openmessflag=false
            self.openvoiceflag=true
            open="1"
            
        }else
        {
            self.openmessflag=false
            self.openvoiceflag=false
            open="0"
            
        }
        self.updb("sex",fieldvalue: "1")
        
        
        let defaults = NSUserDefaults.standardUserDefaults();
        defaults.setObject(self.openmessflag, forKey: "openvoiceflag");

        defaults.setObject(self.openvoiceflag, forKey: "openvoiceflag");
        defaults.synchronize();
        self.updb("isrecvmess",fieldvalue: open)
        self.updb("isopenvoice",fieldvalue: open)
//        Alamofire.request(.POST, "http://api.bbxiaoqu.com/resetuserfield.php", parameters:["userid" : self.userid,"field":"isopenvoice","fieldvalue":open])
//            .responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
//                print(response.result.value)
//                
//                
//        }

    }
    
    //打开相机
    func goCamera(){
        //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
        var sourceType = UIImagePickerControllerSourceType.Camera
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true//设置可编辑
        picker.sourceType = sourceType
        self.presentViewController(picker, animated: true, completion: nil)//进入照相界面
    }
    
    
    //打开相册
    func goImage(){
        let pickerImage = UIImagePickerController()
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            pickerImage.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            pickerImage.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(pickerImage.sourceType)!
        }
        pickerImage.delegate = self
        pickerImage.allowsEditing = true
        self.presentViewController(pickerImage, animated: true, completion: nil)
        
    }
    
    
    //UIImagePicker回调方法
    //    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    //        //获取照片的原图
    //        //let image = (info as NSDictionary).objectForKey(UIImagePickerControllerOriginalImage)
    //        //获得编辑后的图片
    //        let image = (info as NSDictionary).objectForKey(UIImagePickerControllerEditedImage)
    //        //保存图片至沙盒
    //        self.saveImage(image as! UIImage, imageName: iconImageFileName)
    //        let fullPath = ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent(iconImageFileName)
    //        //存储后拿出更新头像
    //        let savedImage = UIImage(contentsOfFile: fullPath)
    //        self.icon.image=savedImage
    //        picker.dismissViewControllerAnimated(true, completion: nil)
    //    }
    
    //选择好照片后choose后执行的方法
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        //获取照片的原图
        img = info[UIImagePickerControllerEditedImage] as! UIImage
        headface.image=img
        iv_photo.image=img
        let defaults = NSUserDefaults.standardUserDefaults();
        let userid = defaults.objectForKey("userid") as! NSString;
        
        
        var date = NSDate()
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyMMddHHmmss"
        var strNowTime = timeFormatter.stringFromDate(date) as String
        
        
        var iconImageFileName=userid.stringByAppendingString("_").stringByAppendingString(strNowTime).stringByAppendingString(".jpg")
        //        //保存图片至沙盒
        //        //self.saveImage(img, newSize: CGSize(width: 256, height: 256), percent: 0.5, imageName: imgname)
        self.saveImage(img, newSize: CGSize(width: 256, height: 256), percent: 0.5,imageName: iconImageFileName)
        //
        //        //let fullPath: String = NSHomeDirectory().stringByAppendingString("/").stringByAppendingString("Documents").stringByAppendingString("/").stringByAppendingString(pos).stringByAppendingString(".png")
        fullPath = ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent(iconImageFileName)
        //
        print("imagePickerController fullPath=\(fullPath)")
        //        imgarr.append(fullPath);
        //
        //        print("pos\(imgarr.count)")
        //
        //
        //
        //        if(mCurrent<5)
        //        {
        //            mCurrent=mCurrent+1;
        //            let addbtn:UIButton = arr[mCurrent] as UIButton;
        //            addbtn.setTitle("添加", forState:UIControlState.Normal)
        //            addbtn.enabled=true
        //            addbtn.setImage(UIImage(named:"ic_add_picture"), forState:UIControlState.Normal)
        //
        //        }
        //
        
        uploadpiccall()
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func uploadpiccall()
    {
        let defaults = NSUserDefaults.standardUserDefaults();
        let userid = defaults.objectForKey("userid") as! String;
            var date = NSDate()
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyMMddHHmmss"
        var strNowTime = timeFormatter.stringFromDate(date) as String
        var fname:String = userid.stringByAppendingString("_").stringByAppendingString(strNowTime).stringByAppendingString(".jpg")
        // NSLog(fullPath)
        
        print("savemyinfo fullPath=\(fullPath)")
        print("savemyinfo fname=\(fname)")
        if(fullPath.characters.count>0)
        {
            uploadImg(fullPath,filename: fname)
            self.updb("headface",fieldvalue: fname)
            
        }

        


    }
    
    
    func uploadImg(image: String,filename: String){
        //设定路径
        var furl: NSURL = NSURL(fileURLWithPath: image)
        /** 把UIImage转化成NSData */
        let imageData = NSData(contentsOfURL: furl)
        if (imageData != nil) {
            
            /** 设置上传图片的URL和参数 */
            let defaults = NSUserDefaults.standardUserDefaults();
            let user_id = defaults.stringForKey("userid")
            let url = "http://api.bbxiaoqu.com/upload.php"
            let request = NSMutableURLRequest(URL: NSURL(string:url)!)
            
            /** 设定上传方法为Post */
            request.HTTPMethod = "POST"
            let boundary = NSString(format: "---------------------------14737809831466499882746641449")
            
            /** 上传文件必须设置 */
            let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
            request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
            
            /** 设置上传Image图片属性 */
            let body = NSMutableData()
            body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            
            body.appendData(NSString(format:"Content-Disposition: form-data; name=\"uploadfile\"; filename=\"%@\"\r\n",filename).dataUsingEncoding(NSUTF8StringEncoding)!)
            
            body.appendData(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(imageData! as! NSData)
            
            body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            request.HTTPBody = body
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                
                if (error == nil && data?.length > 0) {
                    
                    /** 设置解码方式 */
                    let returnString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    let returnData = returnString?.dataUsingEncoding(NSUTF8StringEncoding)
                    
                    print("returnString----\(returnString)")
                }
            })
        }
    }

    
    //MARK: - 保存图片至沙盒
    func saveImage(currentImage:UIImage,newSize: CGSize, percent: CGFloat,imageName:String){
        
        UIGraphicsBeginImageContext(newSize)
        currentImage.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let imageData: NSData = UIImageJPEGRepresentation(newImage, percent)!
        
        
        //var imageData = NSData()
        //imageData = UIImageJPEGRepresentation(currentImage, 0.5)!
        // 获取沙盒目录
        fullPath = ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent(imageName)
        print("saveImage fullPath=\(fullPath)")
        
        // 将图片写入文件
        imageData.writeToFile(fullPath, atomically: false)
    }
    
    //    func saveImage(currentImage: UIImage, newSize: CGSize, percent: CGFloat, imageName: String){
    //                 //压缩图片尺寸
    //                 UIGraphicsBeginImageContext(newSize)
    //                  currentImage.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    //                 let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    //                 UIGraphicsEndImageContext()
    //                  //高保真压缩图片质量
    //                  //UIImageJPEGRepresentation此方法可将图片压缩，但是图片质量基本不变，第二个参数即图片质量参数。
    //                 let imageData: NSData = UIImageJPEGRepresentation(newImage, percent)!
    //                  // 获取沙盒目录,这里将图片放在沙盒的documents文件夹中
    //                  //应用程序目录的路径
    //                  let fullPath: String = NSHomeDirectory().stringByAppendingString("/").stringByAppendingString(imageName)
    //                 // 将图片写入文件
    //                 imageData.writeToFile(fullPath, atomically: false)
    //              }
    
    
    //cancel后执行的方法
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        //println("cancel--------->>")
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    /**
     解决textview遮挡键盘代码
     
     :param: textView textView description
     */
    func textViewDidBeginEditing(textView: UITextView) {
        var frame:CGRect = textView.frame
        var offset:CGFloat = frame.origin.y + 100 - (self.view.frame.size.height-330)
        
        if offset > 0  {
            
            self.view.frame = CGRectMake(0.0, -offset, self.view.frame.size.width, self.view.frame.size.height)
        }
        
    }
    
    
    /**
     恢复视图
     
     :param: textView textView description
     */
    func textViewDidEndEditing(textView: UITextView) {
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
    }
    
    
    /**
     
     解决textField遮挡键盘代码
     :param: textField textField description
     */
    func textFieldDidBeginEditing(textField: UITextField) {
        //
        var frame:CGRect = textField.frame
        var offset:CGFloat = frame.origin.y + 100 - (self.view.frame.size.height-216)
        
        if offset > 0  {
            
            self.view.frame = CGRectMake(0.0, -offset, self.view.frame.size.width, self.view.frame.size.height)
        }
    }
    
    /**
     恢复视图
     
     :param: textField textField description
     */
    func textFieldDidEndEditing(textField: UITextField) {
        //
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        
    }


}
