//
//  LoginViewController.swift
//  bbm
//
//  Created by ericsong on 15/9/24.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    @IBOutlet weak var loginbtn: UIButton!
    @IBOutlet weak var searchpassbtn: UIButton!
    @IBOutlet weak var savepassbtn: UIButton!
    @IBOutlet weak var savepassimg: UIImageView!
    
    @IBOutlet weak var login_username: UITextField!
    @IBOutlet weak var login_password: UITextField!
    var alertView:UIAlertView?
    var db: SQLiteDB!
    
    var issavepass:Bool=true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar=UINavigationBar.appearance()
        navBar.barTintColor=UIColor(red: 204/255, green: 0, blue: 0, alpha: 1)
        var arrs=[String:AnyObject]();
        arrs[NSForegroundColorAttributeName]=UIColor.whiteColor()
        
        navBar.titleTextAttributes=arrs
        
        db = SQLiteDB.sharedInstance()
        let dbHelp = DbHelp()
        dbHelp.initdb()//生成表
        //设置用户名textfiled圆角
        //login_username.layer.cornerRadius = login_username.bounds.height * 0.8
        //背景图片背景色
        
        //username.background = UIImage(named:"login_textFiled_backgroundImage")
        //username.backgroundColor =UIColor.init(red:97/255, green:193/255, blue:171/255, alpha:1)
        
        //添加左边view
        let usView = UIView.init(frame:CGRectMake(0,0, 25,20))
         //把imageView添加到view中可以设置左边和右边的输入距离
        let userImageV = UIImageView()
        userImageV.image = UIImage(named: "tel")
        userImageV.frame = CGRectMake(10,0, 11,16)
        //图片变形
         //userImageV.contentMode = UIViewContentMode.ScaleAspectFit
        usView.addSubview(userImageV)
        login_username.leftView = usView
        //显示leftview的方法
        login_username.leftViewMode = UITextFieldViewMode.Always
        
        
        let usView_pass = UIView.init(frame:CGRectMake(0,0, 25,20))
        let userImageV_pass = UIImageView()
        userImageV_pass.image = UIImage(named: "pass")
        userImageV_pass.frame = CGRectMake(10,0, 11,16)
        usView_pass.addSubview(userImageV_pass)
        login_password.leftView = usView_pass
        login_password.leftViewMode = UITextFieldViewMode.Always
        

        
        
        let name:String=getuser();
        self.login_username.text=name;
        
        
        let defaults = NSUserDefaults.standardUserDefaults();
        if defaults.boolForKey("savepass") == false
        {
            issavepass=false
            savepassimg.image=UIImage(named: "against")

        }else
        {
            issavepass=true
            savepassimg.image=UIImage(named: "agree")
            if defaults.objectForKey("password") != nil
            {
                self.login_password.text = defaults.objectForKey("password") as? String
            }

        }
               
    }
    
    
    func getuser()->String{
        let sql="select * from [user] order by lastlogintime desc limit 0,1";
        NSLog(sql)
        let row = db.query(sql)
        if row.count > 0 {
            
            let item = row[0] as SQLRow
            let nickname = item["userid"]!.asString()
            
            return nickname
            
        }else
        {
            return "";
        }
    }
    //控件失去焦点
    @IBAction func usernameExit(sender: UITextField) {
        sender.resignFirstResponder()
    }
    //控件失去焦点
    @IBAction func passExit(sender: UITextField) {
        sender.resignFirstResponder()
    }
    //login_username控件失去焦点旁边
    @IBAction func uicontrolTouchDown(sender: UIControl) {
        login_username.resignFirstResponder()
    }
    
    
    @IBAction func loginAction(sender: AnyObject) {
        var a = self.login_username.text as String!
        let b = self.login_password.text as String!
        var date:NSDate = NSDate()
        var formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var lastlogintime = formatter.stringFromDate(date)
        updateuserlogintime(a,lastlogintime: lastlogintime);
        if(login(a,pass:b))
        {
            
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("mainController") as! TabOneViewController
            
            
            let defaults = NSUserDefaults.standardUserDefaults();
            if defaults.boolForKey("openmessflag")
            {
            
            }else
            {
                defaults.setObject("1", forKey: "openmessflag");

            }
            
            if defaults.boolForKey("openvoiceflag")
            {
                
            }else
            {
                 defaults.setObject("1", forKey: "openvoiceflag");
            }
            
            
            defaults.synchronize();

            
             //创建导航控制器
            //let nvc=UINavigationController(rootViewController:vc);
            //设置根视图
            //self.view.window!.rootViewController=nvc;
            
            let root  = RootTabBarController()
            //self.view.window!.rootViewController=root
            
            
            let nvc=UINavigationController(rootViewController:root);
            //设置根视图
            self.view.window!.rootViewController=nvc;
            
           
           // let toporder = TopOrderViewController ()

            //////////////////////////////////////////
            //self.view.window! = UIWindow(frame: UIScreen.mainScreen().bounds)
            // Override point for customization after application launch.
            //self.view.window!.backgroundColor = UIColor.whiteColor()
            
            
            /////////////////////////////////////////

        }else
        {
            login_r(a,password:b)
        }
    }
    
    @IBAction func register(sender: UIButton) {
        self.navigationItem.title=""
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("registerController") as! RegisterViewController
        //创建导航控制器
        let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        self.view.window!.rootViewController=nvc;
        
        
        
        
    }
    
    
    @IBAction func savepassact(sender: UIButton) {
        if issavepass == true{
            issavepass=false
            savepassimg.image=UIImage(named: "against")
            
            let defaults = NSUserDefaults.standardUserDefaults();
            defaults.setObject(false, forKey: "savepass");
            defaults.synchronize();


        }else
        {
            issavepass=true
            savepassimg.image=UIImage(named: "agree")
            let defaults = NSUserDefaults.standardUserDefaults();
            defaults.setObject(true, forKey: "savepass");
            defaults.synchronize();

        }
    }
    
    
    @IBAction func jumpsearchpass(sender: UIButton) {
        self.navigationItem.title=""
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("searchController") as! SearchPassViewController
        //创建导航控制器
        let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        self.view.window!.rootViewController=nvc;
        
    }

    
    func login_r(username:String,password:String)
    {
        if(username.characters.count==0)
        {
            self.alertView = UIAlertView()
            self.alertView!.title = "登陆提示"
            self.alertView!.message = "用户名不能为空"
            self.alertView!.addButtonWithTitle("关闭")
            NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"dismiss:", userInfo:self.alertView!, repeats:false)
            self.alertView!.show()
            return;
        }
      Alamofire.request(.POST, "http://api.bbxiaoqu.com/login.php", parameters:["_userid" : username])
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                if let JSON = response.result.value {
                    print("JSON1: \(JSON.count)")
                   if(JSON.count==0)
                    {
                        
                        
                        self.alertView = UIAlertView()
                        self.alertView!.title = "登陆提示"
                        self.alertView!.message = "用户名不存在"
                        self.alertView!.addButtonWithTitle("关闭")
                        NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"dismiss:", userInfo:self.alertView!, repeats:false)
                        self.alertView!.show()

                    }else
                    {
                        let userid:String = JSON.objectForKey("userid") as! String;
                        let pass:String = JSON.objectForKey("pass") as! String;
                        if(pass==password)
                        {
                            let telphone:String = JSON.objectForKey("telphone") as! String;
                            let headface:String = JSON.objectForKey("headface") as! String;
                            let username:String = JSON.objectForKey("username") as! String;
                            let isrecvmess:String = JSON.objectForKey("isrecvmess") as! String;
                            let isopenvoice:String = JSON.objectForKey("isopenvoice") as! String;
                            //lastlogintime
                            var date:NSDate = NSDate()
                            var formatter:NSDateFormatter = NSDateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            var lastlogintime = formatter.stringFromDate(date)
                            //println(dateString)
                            
                            let defaults = NSUserDefaults.standardUserDefaults();
                            
                            defaults.setObject(userid, forKey: "userid");

                            defaults.setObject(pass, forKey: "pass");

                            
                            defaults.setObject(isrecvmess, forKey: "openmessflag");
                            defaults.setObject(isopenvoice, forKey: "openvoiceflag");
                            defaults.synchronize();

                            self.saveuser(userid, nickname: username, password: pass, telphone: telphone, headface: headface,lastlogintime:lastlogintime)
                            let flag:Bool = self.login(userid, pass:pass)
                            if(flag)
                            {
                                
                                let sb = UIStoryboard(name:"Main", bundle: nil)
                                let vc = sb.instantiateViewControllerWithIdentifier("mainController") as! TabOneViewController
                                //创建导航控制器
                                let nvc=UINavigationController(rootViewController:vc);
                                nvc.tabBarItem.title="襄助"
                                //设置根视图
                                self.view.window!.rootViewController=nvc;

                            }else
                            {
                                self.alertView = UIAlertView()
                                self.alertView!.title = "登陆提示"
                                self.alertView!.message = "密码错误"
                                self.alertView!.addButtonWithTitle("关闭")
                                NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"dismiss:", userInfo:self.alertView!, repeats:false)
                                self.alertView!.show()
                            }
                        }else
                        {
                            self.successNotice("密码错误")
                        }
                    
                    }
                }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }
    }
    
    func dismiss(timer:NSTimer){
        alertView!.dismissWithClickedButtonIndex(0, animated:true)
    }
    
    
    func login(username:String,pass:String)->Bool{
        let sql="select * from [user] where userid='\(username)'and password='\(pass)'";
        NSLog(sql)
        let row = db.query(sql)
        if row.count > 0 {
            
                let item = row[0] as SQLRow
                let nickname = item["nickname"]!.asString()
                let userid = item["userid"]!.asString()
                let telphone = item["telphone"]!.asString()
                let headface = item["headface"]!.asString()
            
                //使用NSUserDefaults存储数据
                let defaults = NSUserDefaults.standardUserDefaults();
                defaults.setObject(nickname, forKey: "nickname");
                defaults.setObject(userid, forKey: "userid");
                defaults.setObject(pass, forKey: "password");
                defaults.setObject(telphone, forKey: "telphone");
                defaults.setObject(headface, forKey: "headface");
                defaults.setObject("0", forKey: "lng");
                defaults.setObject("0", forKey: "lat");
                defaults.setObject(issavepass, forKey: "savepass");
                
                defaults.synchronize();
            
                
            
                let name = defaults.objectForKey("nickname") as! NSString;
                print("\(name)");
            
                return true
        
        }else
        {
            return false;
        }
    }
    
    
    func saveuser(userid: String, nickname: String, password: String, telphone: String,headface:String,lastlogintime:String)  {
        let sql = "insert into user(userid,nickname,password,telphone,headface,pass,online,lastlogintime) values('\(userid)','\(nickname)','\(password)','\(telphone)','\(headface)','1','0','\(lastlogintime)')"
        NSLog("sql: \(sql)")
        //通过封装的方法执行sql
        db.execute(sql)
    }
    
    
    func updateuserlogintime(userid: String,lastlogintime:String)  {
        //let sql = "update user (userid,lastlogintime) values('\(userid)','\(lastlogintime)')";
        let sql = "update user set lastlogintime='\(lastlogintime)' where userid='\(userid)'";
        NSLog("sql: \(sql)")
        //通过封装的方法执行sql
        db.execute(sql)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
