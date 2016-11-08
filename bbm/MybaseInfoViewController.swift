//
//  MybaseInfoViewController.swift
//  bbm
//
//  Created by songgc on 16/8/17.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire



class MybaseInfoViewController: UIViewController,UINavigationControllerDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate,ChangeXiaoquDelegate{
    
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
        
        
        //var screenpageHeight=UIScreen.main.applicationFrame.size.height
        _=UIScreen.main.bounds.size.height
        let aaa = self.view.frame.size.height - 210
        scrollView.frame=CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: CGFloat(aaa))
            
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: pageHeight*3)
        
        self.scrollView.contentInset=UIEdgeInsetsMake(0, 0, 210, 0)
        
        self.scrollView.showsHorizontalScrollIndicator = false;
        scrollView.scrollsToTop = false
        headface.layer.cornerRadius = (headface.frame.width) / 2
        headface.layer.masksToBounds = true
        
        
        iv_photo.layer.cornerRadius = (iv_photo.frame.width) / 2
        iv_photo.layer.masksToBounds = true
        
        let rect  =  UIScreen.main.bounds
        let posx = rect.width / 3;
        
        let ww = rect.width / 3;
        
        let posy = CGFloat(10)
        
        row2.backgroundColor=UIColor.white
        addtagarea(index: 1,posx: 2,posy: 0,w: ww-4,h: 60)
        addtagarea(index: 3,posx: posx+2,posy: 0,w: ww-4,h: 60)
        addtagarea(index: 5,posx: posx*2+2,posy: 0,w: ww-4,h: 60)
        addline(posx: posx,posy: posy)
        addline(posx: posx*2,posy: posy)
        
        
        
        let defaults = UserDefaults.standard;
        let userid = defaults.object(forKey: "userid") as! NSString;
        loaduserinfo(userid: userid as String)
        loadusersummaryinfo(userid: userid as String)
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
        iv_photo.isUserInteractionEnabled = true
        
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MybaseInfoViewController.goImagesel))
        iv_photo .addGestureRecognizer(singleTap)
    }
    
    func modifynickname()
    {
        update_nickname.isUserInteractionEnabled = true
        
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MybaseInfoViewController.gomodiffynickname))
        update_nickname .addGestureRecognizer(singleTap)
    }
    func modifybrithday()
    {
        update_brithday.isUserInteractionEnabled = true
        
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MybaseInfoViewController.gomodifybrithday))
        update_brithday .addGestureRecognizer(singleTap)
        
    }
    func modifysex()
    {
        sex_tv.isUserInteractionEnabled = true
        
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MybaseInfoViewController.gomodifysex))
        sex_tv .addGestureRecognizer(singleTap)
    }
    
    func modiftel()
    {
        update_tel.isUserInteractionEnabled = true
        
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MybaseInfoViewController.gomodifytelphone))
        update_tel .addGestureRecognizer(singleTap)
    }
    
    
    func modifweixin()
    {
        update_weixin.isUserInteractionEnabled = true
        
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MybaseInfoViewController.gomodifyweixin))
        update_weixin .addGestureRecognizer(singleTap)
    }
    
    func modifxiaoqu()
    {
        update_xiaoqu.isUserInteractionEnabled = true
        
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MybaseInfoViewController.gomodifyxiaoqu))
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
        update_othertel.isUserInteractionEnabled = true
        
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MybaseInfoViewController.gomodifyothertel))
        update_othertel .addGestureRecognizer(singleTap)
    }
    
    
    
    func AddsugguestClick()
    {
        
        SystenSetting.isUserInteractionEnabled = true
        
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MybaseInfoViewController.gosugguestaboutViewController))
        SystenSetting .addGestureRecognizer(singleTap)
        
    }
    func modifshare()
    {
        update_share.isUserInteractionEnabled = true
        
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MybaseInfoViewController.gomodifyshare))
        update_share .addGestureRecognizer(singleTap)
    }
    func gosugguestaboutViewController()
    {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "sugguestabout") as! SugguestAboutViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func AddexitClick()
    {
        exit.isUserInteractionEnabled = true
        
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MybaseInfoViewController.exitClick))
        exit .addGestureRecognizer(singleTap)
    }
    func updb(field:String,fieldvalue:String)
    {
        NSLog("add")
        let defaults = UserDefaults.standard;
        let userid = defaults.object(forKey: "userid") as! String;
        
        var  dica:Dictionary<String,String> = ["userid" : userid]
        dica["field"]=field
        dica["fieldvalue"]=fieldvalue
        NSLog(String(dica.count))
        Alamofire.request( "http://api.bbxiaoqu.com/updateuserfield.php",method:HTTPMethod.post, parameters: dica).response { response in
            print("Request: \(response.request)")
            print("Response: \(response.response)")
            print("Error: \(response.error)")
            if(response.error != nil)
            {
                if let data = response.data, let str = String(data: data, encoding: .utf8) {
                    print("Data: \(str)")
                    print(str)
                    print(str)
                    
                    self.successNotice("修改成功")
                }
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
            preferredStyle: UIAlertControllerStyle.alert)
        
        // 3.
        let modifyAction = UIAlertAction(
        title: "确认", style: UIAlertActionStyle.default) {
            (action) -> Void in
            
            if let usernamestr = nickNameTextField?.text {
                print(" Username = \(usernamestr)")
                self.username.text=usernamestr
                self.updb(field: "username",fieldvalue: usernamestr)
                
            } else {
                print("No Username entered")
            }
        }
        
        // 4.
        alertController.addTextField {
            (txtUsername) -> Void in
            nickNameTextField = txtUsername
            nickNameTextField!.placeholder = "新昵称"
            nickNameTextField!.text = self.loadusername

        }
        
        
        // 5.
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel,handler:nil))
        alertController.addAction(modifyAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func gomodifybrithday()
    {
        let alertController:UIAlertController=UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        // 初始化 datePicker
        let datePicker = UIDatePicker( )
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN") as Locale
        datePicker.datePickerMode = UIDatePickerMode.date
        if(self.loadbrithday.characters.count>0)
        {
            let formatter:DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let outputA:Date = formatter.date(from: loadbrithday)!
            
            datePicker.date = outputA
        }else
        {
            datePicker.date = NSDate() as Date
        }
        // 响应事件（只要滚轮变化就会触发）
        // datePicker.addTarget(self, action:Selector("datePickerValueChange:"), forControlEvents: UIControlEvents.ValueChanged)
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default){
            (alertAction)->Void in
            
            
            print("date select: \(datePicker.date.description)")
            
            let formatter:DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            
            let brithday = formatter.string(from: datePicker.date)
            
            NSLog("now:\(brithday)")
            
            let todayDate: NSDate = NSDate()
            // let second =todayDate.timeIntervalSinceDate(<#T##anotherDate: NSDate##NSDate#>)
            let second = todayDate.timeIntervalSince(datePicker.date)
            let year=Int(second/(60*60*24*365))
            
            
            self.brithday_tv.text=brithday
            
            self.updb(field: "brithday,age",fieldvalue: brithday.appending(",").appending(String(year)))
            //获取上一节中自定义的按钮外观DateButton类，设置DateButton类属性thedate
            //let myDateButton=self.Datebutt as? DateButton
            //myDateButton?.thedate=datePicker.date
            //强制刷新
            //myDateButton?.setNeedsDisplay()
        })
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel,handler:nil))
        
        alertController.view.addSubview(datePicker)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    var action=""
    
    func gomodifysex()
    {
        action="sex"
        let actionSheet = UIAlertController(title: "性别", message: "请选择性别", preferredStyle: UIAlertControllerStyle.actionSheet)
        let option1 = UIAlertAction(title: "男", style: UIAlertActionStyle.destructive, handler: {(actionSheet: UIAlertAction!) in
            
            self.sex_tv.text="男"
            self.updb(field: "sex",fieldvalue: "0")
        })
        let option2 = UIAlertAction(title: "女", style: UIAlertActionStyle.destructive, handler: {(actionSheet: UIAlertAction!) in
            self.sex_tv.text="女"
             self.updb(field: "sex",fieldvalue: "1")
        })
        
        let CancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {(action) -> Void in
            print("Cancel Sex Select")
        })
        
        actionSheet.addAction(option1)
        actionSheet.addAction(option2)
         actionSheet.addAction(CancelAction)
        self.present(actionSheet, animated: true, completion: nil)

        
    }
    
    
    
    
    func gomodifytelphone()
    {
        var telPhoneTextField: UITextField?
        // 2.
        let alertController = UIAlertController(
            title: "电话修改",
            message: "请输入您的新电话",
            preferredStyle: UIAlertControllerStyle.alert)
        
        // 3.
        let modifyAction = UIAlertAction(
        title: "确认", style: UIAlertActionStyle.default) {
            (action) -> Void in
            
            if let telphonestr = telPhoneTextField?.text {
                print(" telphone = \(telphonestr)")
                self.telphone_tv.text=telphonestr
                self.updb(field: "telphone",fieldvalue: telphonestr)
            } else {
                print("No telphone entered")
            }
        }
        
        // 4.
        alertController.addTextField {
            (txtUsername) -> Void in
            telPhoneTextField = txtUsername
            telPhoneTextField!.placeholder = "新电话"
            telPhoneTextField?.text = self.loadtelphone
        }
        
        
        // 5.
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel,handler:nil))
        alertController.addAction(modifyAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func gomodifyweixin()
    {
        var WeixinTextField: UITextField?
        // 2.
        let alertController = UIAlertController(
            title: "微信修改",
            message: "请输入您的新微信",
            preferredStyle: UIAlertControllerStyle.alert)
        
        // 3.
        let modifyAction = UIAlertAction(
        title: "确认", style: UIAlertActionStyle.default) {
            (action) -> Void in
            
            if let username = WeixinTextField?.text {
                print(" Username = \(username)")
                self.weixin_tv.text=username
                self.updb(field: "weixin",fieldvalue: username)
                
            } else {
                print("No Username entered")
            }
        }
        
        // 4.
        alertController.addTextField {
            (txtUsername) -> Void in
            WeixinTextField = txtUsername
            WeixinTextField!.placeholder = "新微信"
            WeixinTextField?.text = self.loadweixin
        }
        
        
        // 5.
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel,handler:nil))
        alertController.addAction(modifyAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func gomodifyxiaoqu()
    {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "souxiaoquviewcontroller") as! SouXiaoQuViewController
        vc.delegate=self
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    //var returncommunity:String="";
    //var returncommunity_id:String="";
    
    func ChangeXiaoqu(_ controller:SouXiaoQuViewController,name:String,code:String){
        
        self.xiaoqu_tv.text = name
        NSLog("qzLabel.text == \(name)")
        self.community=name
        self.community_id=code
        //保存到临时数据库
        let defaults = UserDefaults.standard;
        defaults.set(self.community, forKey: "community");//省直辖市
        defaults.set(self.community_id, forKey: "community_id");//省直辖市
        defaults.synchronize();
        //保存到服务器
        self.updb(field: "community,community_id",fieldvalue: self.community.appending(",").appending(String(self.community_id)))
    }
    
    
    func gomodifyshare()
    {
        let sheet = UIAlertController(title: "襄助 ", message: "分享到微信", preferredStyle: .actionSheet)
        let CancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {(action) -> Void in
            print("Cancel share")
        })
        let shareToFriend = UIAlertAction(title: "好友", style: .destructive, handler: {(action) -> Void in
            self.shareToWChat(scene: WXSceneSession)
        })
        let shareToGroupsFriends = UIAlertAction(title: "朋友圈", style: .destructive, handler: {(action) -> Void in
            self.shareToWChat(scene: WXSceneTimeline)
        })
        
        sheet.addAction(CancelAction)
        sheet.addAction(shareToFriend)
        sheet.addAction(shareToGroupsFriends)
        self.present(sheet, animated: true, completion: {() -> Void in
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
        
        msg.setThumbImage(UIImage(named: "icon.png"));
        
        let req = SendMessageToWXReq()
        req.message = msg
        req.scene = Int32(scene.rawValue)
        WXApi.send(req)
    }
    
    func gomodifyothertel()
    {
        var usernameTextField: UITextField?
        var ＴelphoneTextField: UITextField?
        
        // 2.
        let alertController = UIAlertController(
            title: "紧急联系人",
            message: "请输入你的紧急联系人",
            preferredStyle: UIAlertControllerStyle.alert)
        
        // 3.
        let loginAction = UIAlertAction(
        title: "确认", style: UIAlertActionStyle.default) {
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
            
            self.updb(field: "emergencycontact,emergencycontacttelphone",fieldvalue: a.appending(",").appending(b))
            
            
            //            var aa:String="".appending(usernamestr).appending(",").appending(telstr)
            //            self.updb("emergencycontact,emergencycontacttelphone",fieldvalue: aa)
        }
        
        
        
        // 4.
        alertController.addTextField {
            (txtUsername) -> Void in
            usernameTextField = txtUsername
            usernameTextField!.placeholder = "紧急联系人"
        }
        
        alertController.addTextField {
            (txtTelphone) -> Void in
            ＴelphoneTextField = txtTelphone
            ＴelphoneTextField!.placeholder = "紧急联系人电话"
        }
        
        // 5.
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel,handler:nil));
        alertController.addAction(loginAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    var Numtag:[UILabel] = [];
    
    
    func addtagarea(index:Int,posx:CGFloat,posy:CGFloat,w:CGFloat,h:CGFloat)
    {
        
        let customView = UIView(frame: CGRect(x: posx+5, y: posy, width:w-10, height: h))
        let labnum=UILabel(frame: CGRect(x: 10, y: 10, width:w-20, height: 20))
        labnum.font = UIFont.systemFont(ofSize: 18);
        labnum.text = "10";
        labnum.textAlignment = NSTextAlignment.center;
        labnum.layer.masksToBounds = true;
        
        //        labnum.layer.cornerRadius = 3.0;
        //        labnum.layer.borderColor = UIColor.lightGrayColor().CGColor;
        //        labnum.layer.borderWidth = 0.8;
        
        labnum.numberOfLines = 0;
        labnum.lineBreakMode = NSLineBreakMode.byCharWrapping;
        labnum.tag = index;
        labnum.isUserInteractionEnabled = true;
        Numtag.append(labnum)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(_:)))
        labnum.addGestureRecognizer(tap);
        let labname=UILabel(frame: CGRect(x: 10, y: 30, width:w-20, height: 20))
        labname.font = UIFont.systemFont(ofSize: 15);
        labname.textAlignment = NSTextAlignment.center;
        labnum.textColor = UIColor.gray;
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
        labname.tag = index;
        labname.isUserInteractionEnabled = true;
        labname.addGestureRecognizer(tap);
        
        customView.addSubview(labnum)
        customView.addSubview(labname)
        customView.tag = index;
        customView.isUserInteractionEnabled = true;
        customView.addGestureRecognizer(tap);
        self.row2.addSubview(customView)
    }
    
   
    
    func tapLabel(_ recognizer: UITapGestureRecognizer) {
        print("long pressed....")
        let labelView:UIView = recognizer.view!;
        let tapTag:NSInteger = labelView.tag;
        if(tapTag==1)
        {
            let vc = ListViewController()
            vc.selectedTabNumber=2
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if(tapTag==3)
        {
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "friendsviewcontroller") as! FriendsTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if(tapTag==5)
        {
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "gzinfosviewcontroller") as! GzInfosTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        //let labelString:String = textArray?.objectAtIndex(tapTag) as! String;
    }
    
    func exitClick()
    {
         NSLog("exitClick")
        
        // 2.
        let alertController = UIAlertController(
            title: "系统提示",
            message: "您确定要退出吗？",
            preferredStyle: UIAlertControllerStyle.alert)
        
        // 3.
        let loginAction = UIAlertAction(
        title: "确认", style: UIAlertActionStyle.default) {
            (action) -> Void in
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "loginController") as! LoginViewController
            //创建导航控制器
            let nvc=UINavigationController(rootViewController:vc);
            //设置根视图
            self.view.window!.rootViewController=nvc;
         }
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel,handler:nil));
        alertController.addAction(loginAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    func addline(posx:CGFloat,posy:CGFloat)
    {
        
        //let posy=CGFloat(row1.f);
        let customView = UIView(frame: CGRect(x: posx, y: posy, width:1, height: 75))
        let imageView=UIImageView(image:UIImage(named:"xz_xi_icon"))
        imageView.frame=CGRect(x: 0, y: 0, width: 1, height: 30)
        customView.addSubview(imageView)
        self.row2.addSubview(customView)
    }
    
    
    override func viewDidLayoutSubviews() {
        
        let rect  =  UIScreen.main.bounds
        _ = rect.width ;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func loadusersummaryinfo(userid:String)
    {
        
        let url_str:String = "http://api.bbxiaoqu.com/getusersummary.php?userid=".appending(userid)
        Alamofire.request(url_str)
            .responseJSON { response in
                print(response.result)   // result of response serialization
                if(response.result.isSuccess)
                {
                    if let tempdata = response.result.value{
                        print("data: \(tempdata)")
                        let data:NSDictionary = tempdata as! NSDictionary;

                        let num1:NSNumber = data.object(forKey: "num1") as! NSNumber;
                        let num2:NSNumber = data.object(forKey: "num3") as! NSNumber;
                        let num3:NSNumber = data.object(forKey: "num5") as! NSNumber;
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
    
    
    var loadtelphone:String="";
    var loadusername:String="";
    var loadweixin:String=""
    
    var loademergencycontact:String="";
    var loadmergencytelphone:String="";
    var loadbrithday:String="";
    func loaduserinfo(userid:String)
    {
        let url_str:String = "http://api.bbxiaoqu.com/getuserinfo.php?userid=".appending(userid)
        Alamofire.request(url_str)
            .responseJSON { response in
                if let JSON:NSArray = response.result.value as? NSArray {
                    print("JSON1: \(JSON.count)")
                    if(JSON.count>0)
                    {
                        let data:NSDictionary = JSON[0] as! NSDictionary;

                        self.loadtelphone = data.object(forKey: "telphone") as! String;
                        let headfaceurl:String = data.object(forKey: "headface") as! String;
                        self.loadusername = data.object(forKey: "username") as! String;
                       //var age:String;
                        //if(data.object(forKey: "age")  == nil)
                        //{
                        //    age="";
                        //}else
                        //{
                        //    age = data.object(forKey: "age") as! String;
                        //}
                        
                        var usersex:String;
                        if(data.object(forKey: "sex")  == nil)
                        {
                            usersex="1";
                        }else
                        {
                            usersex = data.object(forKey: "sex") as! String;
                        }
                        
                                                if(data.object(forKey: "weixin")  == nil)
                        {
                            self.loadweixin="";
                        }else
                        {
                            self.loadweixin = data.object(forKey: "weixin") as! String;
                        }
                        
                        
                        if(data.object(forKey: "community")  == nil)
                        {
                            self.community="";
                        }else
                        {
                            self.community = data.object(forKey: "community") as! String;
                        }
                        
                        if(data.object(forKey: "community_id")  == nil)
                        {
                            self.community_id="";
                        }else
                        {
                            self.community_id = data.object(forKey: "community_id") as! String;
                        }
                        
                        
                        if(data.object(forKey: "emergencycontact")  == nil)
                        {
                            self.loademergencycontact="";
                        }else
                        {
                            self.loademergencycontact = data.object(forKey: "emergencycontact") as! String;
                        }
                        if(data.object(forKey: "emergencycontacttelphone") == nil)
                        {
                            self.loadmergencytelphone="";
                        }else
                        {
                            self.loadmergencytelphone = data.object(forKey: "emergencycontacttelphone") as! String;
                        }
                        self.my_nickname.text=self.loadusername;
                        self.my_userid.text=Util.hiddentelphonechartacter(self.loadtelphone);
                        self.weixin_tv.text=self.loadweixin
                        self.username.text=self.loadusername;
                        self.telphone_tv.text=self.loadtelphone;
                        self.xiaoqu_tv.text=self.community;
                        if(usersex=="1")
                        {//男
                            self.sex_tv.text="女";
                        }else
                        {//女
                            self.sex_tv.text="男"
                        }
                        
                        
                        if(data.object(forKey: "brithday") == nil)
                        {
                            self.brithday_tv.text="1970-01-01";
                            self.loadbrithday="1970-01-01";
                        }else
                        {
                            var brithday:String = data.object(forKey: "brithday") as! String;
                            if(brithday.characters.count<10)
                            {
                                self.brithday_tv.text="1970-01-01";
                                self.loadbrithday="1970-01-01";
                            }
                            else
                            {
                                self.brithday_tv.text=brithday;
                                self.loadbrithday=brithday;
                            }
                        }
                        if(self.loademergencycontact.characters.count>0)
                        {
                            self.emergencycontact_tv.text=self.loademergencycontact
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
        let actionSheet = UIAlertController(title: "图片来源", message: "请选择获取方式", preferredStyle: UIAlertControllerStyle.actionSheet)
        let option1 = UIAlertAction(title: "照片", style: UIAlertActionStyle.destructive, handler: {(actionSheet: UIAlertAction!) in
             self.goImage()
        })
        let option2 = UIAlertAction(title: "相机", style: UIAlertActionStyle.destructive, handler: {(actionSheet: UIAlertAction!) in
             self.goCamera()
        })
        
        let CancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {(action) -> Void in
            print("Cancel Sex Select")
        })

        actionSheet.addAction(option1)
        actionSheet.addAction(option2)
        actionSheet.addAction(CancelAction)
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    
    var openmessflag=false;
    var openvoiceflag=false;
    @IBAction func openmess(sender: UISwitch) {
        var open:String="0"
        
        if sender.isOn == true
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
        self.updb(field: "sex",fieldvalue: "1")
        
        
        let defaults = UserDefaults.standard;
        defaults.set(self.openmessflag, forKey: "openvoiceflag");
        
        defaults.set(self.openvoiceflag, forKey: "openvoiceflag");
        defaults.synchronize();
        self.updb(field: "isrecvmess",fieldvalue: open)
        self.updb(field: "isopenvoice",fieldvalue: open)
        
    }
    
    //打开相机
    func goCamera(){
        //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
        var sourceType = UIImagePickerControllerSourceType.camera
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true//设置可编辑
        picker.sourceType = sourceType
        self.present(picker, animated: true, completion: nil)//进入照相界面
    }
    
    
    //打开相册
    func goImage(){
        let pickerImage = UIImagePickerController()
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            pickerImage.sourceType = UIImagePickerControllerSourceType.photoLibrary
            pickerImage.mediaTypes = UIImagePickerController.availableMediaTypes(for: pickerImage.sourceType)!
        }
        pickerImage.delegate = self
        pickerImage.allowsEditing = true
        self.present(pickerImage, animated: true, completion: nil)
        
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        //获取照片的原图
        img = info[UIImagePickerControllerEditedImage] as! UIImage
        headface.image=img
        iv_photo.image=img
        let defaults = UserDefaults.standard;
        let userid = defaults.object(forKey: "userid") as! NSString;
        
        
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyMMddHHmmss"
        let strNowTime = timeFormatter.string(from: date as Date) as String
        
        
        let iconImageFileName=userid.appending("_").appending(strNowTime).appending(".jpg")
        //        //保存图片至沙盒
        //        //self.saveImage(img, newSize: CGSize(width: 256, height: 256), percent: 0.5, imageName: imgname)
        self.saveImage(currentImage: img, newSize: CGSize(width: 256, height: 256), percent: 0.5,imageName: iconImageFileName)
        //
        //        //let fullPath: String = NSHomeDirectory().appending("/").appending("Documents").appending("/").appending(pos).appending(".png")
        fullPath = ((NSHomeDirectory() as NSString).appendingPathComponent("Documents") as NSString).appendingPathComponent(iconImageFileName)
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
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func uploadpiccall()
    {
        let defaults = UserDefaults.standard;
        let userid = defaults.object(forKey: "userid") as! String;
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyMMddHHmmss"
        let strNowTime = timeFormatter.string(from: date as Date) as String
        let fname:String = userid.appending("_").appending(strNowTime).appending(".jpg")
        // NSLog(fullPath)
        
        print("savemyinfo fullPath=\(fullPath)")
        print("savemyinfo fname=\(fname)")
        if(fullPath.characters.count>0)
        {
            uploadImg(image: fullPath,filename: fname)
            self.updb(field: "headface",fieldvalue: fname)
            
        }
        
        
        
        
    }
    
    
    func uploadImg(image: String,filename: String){
        //设定路径
        let furl: NSURL = NSURL(fileURLWithPath: image)
        /** 把UIImage转化成NSData */
        let imageData = NSData(contentsOf: furl as URL)
        if (imageData != nil) {
            
            /** 设置上传图片的URL和参数 */
            let defaults = UserDefaults.standard;
            _ = defaults.string(forKey: "userid")
            let url = "http://api.bbxiaoqu.com/upload.php"
            let request = NSMutableURLRequest(url: NSURL(string:url)! as URL)
            
            /** 设定上传方法为Post */
            request.httpMethod = "POST"
            let boundary = NSString(format: "---------------------------14737809831466499882746641449")
            
            /** 上传文件必须设置 */
            let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
            request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
            
            /** 设置上传Image图片属性 */
            let body = NSMutableData()
            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
            
            body.append(NSString(format:"Content-Disposition: form-data; name=\"uploadfile\"; filename=\"%@\"\r\n",filename).data(using: String.Encoding.utf8.rawValue)!)
            
            body.append(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append((imageData! ) as Data)
            
            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
            request.httpBody = body as Data
            
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main, completionHandler: { (response, data, error) -> Void in
                
                if (error == nil && (data?.count)! > 0) {
                    
                    /** 设置解码方式 */
                    let returnString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    _ = returnString?.data(using: String.Encoding.utf8.rawValue)
                    
                    print("returnString----\(returnString)")
                }
            })
        }
    }
    
    
    //MARK: - 保存图片至沙盒
    func saveImage(currentImage:UIImage,newSize: CGSize, percent: CGFloat,imageName:String){
        
        UIGraphicsBeginImageContext(newSize)
        currentImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let imageData: NSData = UIImageJPEGRepresentation(newImage, percent)! as NSData
        
        
        //var imageData = NSData()
        //imageData = UIImageJPEGRepresentation(currentImage, 0.5)!
        // 获取沙盒目录
        fullPath = ((NSHomeDirectory() as NSString).appendingPathComponent("Documents") as NSString).appendingPathComponent(imageName)
        print("saveImage fullPath=\(fullPath)")
        
        // 将图片写入文件
        imageData.write(toFile: fullPath, atomically: false)
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
    //                  let fullPath: String = NSHomeDirectory().appending("/").appending(imageName)
    //                 // 将图片写入文件
    //                 imageData.writeToFile(fullPath, atomically: false)
    //              }
    
    
    //cancel后执行的方法
    private func imagePickerControllerDidCancel(picker: UIImagePickerController){
        //println("cancel--------->>")
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    /**
     解决textview遮挡键盘代码
     
     :param: textView textView description
     */
    private func textViewDidBeginEditing(textView: UITextView) {
        let frame:CGRect = textView.frame
        let offset:CGFloat = frame.origin.y + 100 - (self.view.frame.size.height-330)
        
        if offset > 0  {
            
            self.view.frame = CGRect(origin: CGPoint(x: 0,y :-offset), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
                
                //CGRectMake(0.0, -offset, self.view.frame.size.width, self.view.frame.size.height)
        }
        
    }
    
    
    /**
     恢复视图
     
     :param: textView textView description
     */
    private func textViewDidEndEditing(textView: UITextView) {
        self.view.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
    }
    
    
    /**
     
     解决textField遮挡键盘代码
     :param: textField textField description
     */
    private func textFieldDidBeginEditing(textField: UITextField) {
        //
        let frame:CGRect = textField.frame
        let offset:CGFloat = frame.origin.y + 100 - (self.view.frame.size.height-216)
        
        if offset > 0  {
            
            self.view.frame = CGRect(x:0.0, y:-offset, width:self.view.frame.size.width, height:self.view.frame.size.height)
        }
    }
    
    /**
     恢复视图
     
     :param: textField textField description
     */
    private func textFieldDidEndEditing(textField: UITextField) {
        //
        self.view.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        
    }
    
    
}
