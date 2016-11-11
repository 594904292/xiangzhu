//
//  LoginViewController.swift
//  bbm
//
//  Created by ericsong on 15/9/24.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController,XMLParserDelegate {
    @IBOutlet weak var loginbtn: UIButton!
    @IBOutlet weak var searchpassbtn: UIButton!
    @IBOutlet weak var savepassbtn: UIButton!
    @IBOutlet weak var savepassimg: UIImageView!
    
    @IBOutlet weak var login_username: UITextField!
    @IBOutlet weak var login_password: UITextField!
    var alertView:UIAlertController?
    var db: SQLiteDB!

    var issavepass:Bool=true;
    //键盘的出现
    func keyBoardWillShow(_ notification: Notification){
        //获取userInfo
        let kbInfo = notification.userInfo
        //获取键盘的size
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let screenSize: CGRect = UIScreen.main.bounds
        
        //let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        
        //键盘的y偏移量
        let changeY = kbRect.origin.y - screenHeight
        //键盘弹出的时间
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        //界面偏移动画
        UIView.animate(withDuration: duration) {
            
            self.view.transform = CGAffineTransform(translationX: 0, y: changeY)
        }
    }
    
    //键盘的隐藏
    func keyBoardWillHide(_ notification: Notification){
        
        let kbInfo = notification.userInfo
        //let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //let changeY = kbRect.origin.y
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        //界面偏移动画
        UIView.animate(withDuration: duration) {
            
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let navBar=UINavigationBar.appearance()
        navBar.barTintColor=UIColor(red: 204/255, green: 0, blue: 0, alpha: 1)
        var arrs=[String:AnyObject]();
        arrs[NSForegroundColorAttributeName]=UIColor.white
        
        navBar.titleTextAttributes=arrs
        
        db = SQLiteDB.sharedInstance
        let dbHelp = DbHelp()
        dbHelp.initdb()//生成表
        //设置用户名textfiled圆角
        //login_username.layer.cornerRadius = login_username.bounds.height * 0.8
        //背景图片背景色
        
        //username.background = UIImage(named:"login_textFiled_backgroundImage")
        //username.backgroundColor =UIColor.init(red:97/255, green:193/255, blue:171/255, alpha:1)
        
        //添加左边view
        let usView = UIView.init(frame:CGRect(x: 0,y: 0, width: 25,height: 20))
         //把imageView添加到view中可以设置左边和右边的输入距离
        let userImageV = UIImageView()
        userImageV.image = UIImage(named: "tel")
        userImageV.frame = CGRect(x: 10,y: 0, width: 11,height: 16)
        //图片变形
         //userImageV.contentMode = UIViewContentMode.ScaleAspectFit
        usView.addSubview(userImageV)
        login_username.leftView = usView
        //显示leftview的方法
        login_username.leftViewMode = UITextFieldViewMode.always
        
        
        let usView_pass = UIView.init(frame:CGRect(x: 0,y: 0, width: 25,height: 20))
        let userImageV_pass = UIImageView()
        userImageV_pass.image = UIImage(named: "pass")
        userImageV_pass.frame = CGRect(x: 10,y: 0, width: 11,height: 16)
        usView_pass.addSubview(userImageV_pass)
        login_password.leftView = usView_pass
        login_password.leftViewMode = UITextFieldViewMode.always
        

        
        
        let name:String=getuser();
        self.login_username.text=name;
        
        
        let defaults = UserDefaults.standard;
        if defaults.bool(forKey: "savepass") == false
        {
            issavepass=false
            savepassimg.image=UIImage(named: "against")

        }else
        {
            issavepass=true
            savepassimg.image=UIImage(named: "agree")
            if defaults.object(forKey: "password") != nil
            {
                self.login_password.text = defaults.object(forKey: "password") as? String
            }

        }
        
        
        
        let url = URL(string:"http://api.bbxiaoqu.com/sys.xml")!
        guard let parserXML = XMLParser(contentsOf: url) else {
            return
        }
        
        //1
        parserXML.delegate = self
        parserXML.parse()
               
    }
    
    
    var currentNodeName:String!
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentNodeName = elementName
        if elementName == "sys"{
            //print("id:\(attributeDict.count)")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //2
        let str = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if str != "" {
            print("\(currentNodeName):\(str)")
            if currentNodeName=="xmpphost"{
                zdl().xmpphost = str;
            }else if currentNodeName=="xmppport"{
                 zdl().xmppport = UInt16(str)!;
            }else if currentNodeName=="xmppdomain"{
                 zdl().xmppdomain = str;
            }
        }
    }
    
    //获取总代理
    func zdl() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func getuser()->String{
        let sql="select * from [user] order by lastlogintime desc limit 0,1";
        NSLog(sql)
        let row = db.query(sql: sql)
        if row.count > 0 {
            
            let item = row[0]
            let nickname = item["userid"] as! String
            
            return nickname
            
        }else
        {
            return "";
        }
    }
    //控件失去焦点
    @IBAction func usernameExit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    //控件失去焦点
    @IBAction func passExit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    //login_username控件失去焦点旁边
    @IBAction func uicontrolTouchDown(_ sender: UIControl) {
        login_username.resignFirstResponder()
    }
    
    
    @IBAction func loginAction(_ sender: AnyObject) {
        let a = self.login_username.text as String!
        let b = self.login_password.text as String!
        //let date:Date = Date()
        //let formatter:DateFormatter = DateFormatter()
        //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //var lastlogintime = formatter.string(from: date)
        //updateuserlogintime(a,lastlogintime: lastlogintime);
        login_r(a!,password:b!)
//        if(login(a,pass:b))
//        {
//            
//            let sb = UIStoryboard(name:"Main", bundle: nil)
//            let vc = sb.instantiateViewControllerWithIdentifier("mainController") as! TabOneViewController
//            
//            
//            let defaults = NSUserDefaults.standardUserDefaults();
//            if defaults.boolForKey("openmessflag")
//            {
//            
//            }else
//            {
//                defaults.setObject("1", forKey: "openmessflag");
//
//            }
//            
//            if defaults.boolForKey("openvoiceflag")
//            {
//                
//            }else
//            {
//                 defaults.setObject("1", forKey: "openvoiceflag");
//            }
//            
//            
//            defaults.synchronize();
//            let root  = RootTabBarController()
//            let nvc=UINavigationController(rootViewController:root);
//            //设置根视图
//            self.view.window!.rootViewController=nvc;
//            
//           
//           // let toporder = TopOrderViewController ()
//
//            //////////////////////////////////////////
//            //self.view.window! = UIWindow(frame: UIScreen.mainScreen().bounds)
//            // Override point for customization after application launch.
//            //self.view.window!.backgroundColor = UIColor.whiteColor()
//            
//            
//            /////////////////////////////////////////
//
//        }else
//        {
//            login_r(a,password:b)
//        }
    }
    
    @IBAction func register(_ sender: UIButton) {
        self.navigationItem.title=""
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "registerController") as! RegisterViewController
        //创建导航控制器
        let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        self.view.window!.rootViewController=nvc;
        
        
        
        
    }
    
    
    @IBAction func savepassact(_ sender: UIButton) {
        if issavepass == true{
            issavepass=false
            savepassimg.image=UIImage(named: "against")
            
            let defaults = UserDefaults.standard;
            defaults.set(false, forKey: "savepass");
            defaults.synchronize();


        }else
        {
            issavepass=true
            savepassimg.image=UIImage(named: "agree")
            let defaults = UserDefaults.standard;
            defaults.set(true, forKey: "savepass");
            defaults.synchronize();

        }
    }
    
    
    @IBAction func jumpsearchpass(_ sender: UIButton) {
        self.navigationItem.title=""
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "searchController") as! SearchPassViewController
        //创建导航控制器
        let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        self.view.window!.rootViewController=nvc;
        
    }
    

    
    func login_r(_ username:String,password:String)
    {
        if(username.characters.count==0)
        {
            
            self.alertView = UIAlertController(title: "登陆提示", message: "用户名不能为空", preferredStyle: .alert)
            self.alertView?.addAction(UIAlertAction(title: "关闭", style: .default, handler: nil))
            self.present(self.alertView!, animated: true, completion: nil)
            return;
            
            
        }
        Alamofire.request("http://api.bbxiaoqu.com/login.php", method:HTTPMethod.post,parameters:["_userid" : username])
            .responseJSON { response in
                
                 print("JSON1: \(response.result.value)")
                if(response.result.isSuccess)
                {
                    if let JSON:NSDictionary = response.result.value as? NSDictionary
                    {
                    print("JSON1: \(JSON.count)")
                   if(JSON.count==0)
                    {
                        self.alertView = UIAlertController(title: "登陆提示", message: "用户名不存在", preferredStyle: .alert)
                        self.alertView?.addAction(UIAlertAction(title: "关闭", style: .default, handler: nil))
                        self.present(self.alertView!, animated: true, completion: nil)

                    }else
                    {
                        let userid:String = JSON.object(forKey: "userid") as! String;
                        let pass:String = JSON.object(forKey: "pass") as! String;
                        if(pass==password)
                        {
                            let telphone:String = JSON.object(forKey: "telphone") as! String;
                            let headface:String = JSON.object(forKey: "headface") as! String;
                            let username:String = JSON.object(forKey: "username") as! String;
                            let isrecvmess:String = JSON.object(forKey: "isrecvmess") as! String;
                            let isopenvoice:String = JSON.object(forKey: "isopenvoice") as! String;
                            //lastlogintime
                            let date:Date = Date()
                            let formatter:DateFormatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let lastlogintime = formatter.string(from: date)
                            //println(dateString)
                            
                            let defaults = UserDefaults.standard;
                            
                            defaults.set(userid, forKey: "userid");
                            if username.characters.count>0
                            {
                                defaults.set(username, forKey: "username");
                            }else
                            {
                                defaults.set(userid, forKey: "username");
                            }
  
                            defaults.set(pass, forKey: "pass");

                            
                            defaults.set(isrecvmess, forKey: "openmessflag");
                            defaults.set(isopenvoice, forKey: "openvoiceflag");
                            defaults.synchronize();

                            self.saveuser(userid, nickname: username, password: pass, telphone: telphone, headface: headface,lastlogintime:lastlogintime)
                            let flag:Bool = self.login(userid, pass:pass)
                            if(flag)
                            {
                                let root  = RootTabBarController()
                                let nvc=UINavigationController(rootViewController:root);
                                //设置根视图
                                self.view.window!.rootViewController=nvc;

                            }else
                            {
                                
                                self.alertView = UIAlertController(title: "登陆提示", message: "密码错误", preferredStyle: .alert)
                                self.alertView?.addAction(UIAlertAction(title: "关闭", style: .default, handler: nil))
                                self.present(self.alertView!, animated: true, completion: nil)

                            
                            }
                        }else
                        {
                            self.successNotice("密码错误")
                        }
                    
                    }
                    }else
                    {
                        self.alertView = UIAlertController(title: "登陆提示", message: "用户名不存在", preferredStyle: .alert)
                        self.alertView?.addAction(UIAlertAction(title: "关闭", style: .default, handler: nil))
                        self.present(self.alertView!, animated: true, completion: nil)
                        
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }
    }
    
    
    func login(_ username:String,pass:String)->Bool{
        let sql="select * from [user] where userid='\(username)'and password='\(pass)'";
        NSLog(sql)
        let row = db.query(sql: sql)
        if row.count > 0 {
            
                let item = row[0]
                let nickname = item["nickname"] as! String
                let userid = item["userid"] as! String
                let telphone = item["telphone"] as! String
                let headface = item["headface"] as! String
            
                //使用NSUserDefaults存储数据
                let defaults = UserDefaults.standard;
                defaults.set(nickname, forKey: "nickname");
                defaults.set(userid, forKey: "userid");
                defaults.set(pass, forKey: "password");
                defaults.set(telphone, forKey: "telphone");
                defaults.set(headface, forKey: "headface");
                defaults.set("0", forKey: "lng");
                defaults.set("0", forKey: "lat");
                defaults.set(issavepass, forKey: "savepass");
                
                defaults.synchronize();
                let name = defaults.object(forKey: "nickname") as! NSString;
                print("\(name)");
            
                return true
        
        }else
        {
            return false;
        }
    }
    
    
    func saveuser(_ userid: String, nickname: String, password: String, telphone: String,headface:String,lastlogintime:String)  {
        let sql = "insert into user(userid,nickname,password,telphone,headface,pass,online,lastlogintime) values('\(userid)','\(nickname)','\(password)','\(telphone)','\(headface)','1','0','\(lastlogintime)')"
        NSLog("sql: \(sql)")
        //通过封装的方法执行sql
        _ = db.execute(sql: sql)
    }
    
    
    func updateuserlogintime(_ userid: String,lastlogintime:String)  {
        //let sql = "update user (userid,lastlogintime) values('\(userid)','\(lastlogintime)')";
        let sql = "update user set lastlogintime='\(lastlogintime)' where userid='\(userid)'";
        NSLog("sql: \(sql)")
        //通过封装的方法执行sql
        _ = db.execute(sql: sql)
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
