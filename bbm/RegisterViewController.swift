//
//  RegisterViewController.swift
//  bbm
//
//  Created by ericsong on 15/10/23.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class RegisterViewController: UIViewController,UINavigationControllerDelegate{
    
    var alertView:UIAlertView?
    @IBOutlet weak var telphone_edit: UITextField!
    @IBOutlet weak var password_edit: UITextField!
    @IBOutlet weak var authoncode: UITextField!
    @IBOutlet weak var authonbtn: UIButton!

    
    @IBAction func uicontrolTouchDown(sender: UIControl) {
        telphone_edit.resignFirstResponder()
        password_edit.resignFirstResponder()

        authoncode.resignFirstResponder()


    }
    @IBAction func telphone_exit(sender: UITextField) {
        telphone_edit.resignFirstResponder()
    }
    
    @IBAction func pass_exit(sender: UITextField) {
        password_edit.resignFirstResponder()
    }
    
    @IBAction func auth_exit(sender: UITextField) {
        authoncode.resignFirstResponder()
    }
    //验证码倒计时
    func countDown(timeOut:Int){
        //倒计时时间
        var timeout = timeOut
        var queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        var _timer:dispatch_source_t  = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue)
        dispatch_source_set_timer(_timer, dispatch_walltime(nil, 0), 1*NSEC_PER_SEC, 0)
        //每秒执行
        var isinit:Bool=true
        dispatch_source_set_event_handler(_timer, { () -> Void in
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    //设置界面的按钮显示 根据自己需求设置
                    self.authonbtn.setTitle("再次获取", forState: UIControlState.Normal)
                })
            }else{//正在倒计时
                
                
                var seconds = timeout % 60
                if(isinit)
                {
                    seconds=60;
                }
                var strTime = NSString.localizedStringWithFormat("%.2d", seconds)
                
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    //                    NSLog("----%@", NSString.localizedStringWithFormat("%@S", strTime) as String)
                    
                    UIView.beginAnimations(nil, context: nil)
                    UIView.setAnimationDuration(1)
                    //设置界面的按钮显示 根据自己需求设置
                    self.authonbtn.setTitle(NSString.localizedStringWithFormat("%@S", strTime) as String, forState: UIControlState.Normal)
                    UIView.commitAnimations()
                    self.authonbtn.userInteractionEnabled = false
                })
                timeout--;
                isinit=false;
            }
            
        })
        dispatch_resume(_timer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="注册"
         // Do any additional setup after loading the view.
        let navBar=UINavigationBar.appearance()
        navBar.barTintColor=UIColor(red: 204/255, green: 0, blue: 0, alpha: 1)
        var arrs=[String:AnyObject]();
        arrs[NSForegroundColorAttributeName]=UIColor.whiteColor()
        navBar.titleTextAttributes=arrs


        
        var item3 = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        item3.tintColor=UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem=item3

        
        
        
        //添加左边view
        let usView = UIView.init(frame:CGRectMake(0,0, 25,20))
        //把imageView添加到view中可以设置左边和右边的输入距离
        let userImageV = UIImageView()
        userImageV.image = UIImage(named: "tel")
        userImageV.frame = CGRectMake(10,0, 11,16)
        //图片变形
        //userImageV.contentMode = UIViewContentMode.ScaleAspectFit
        usView.addSubview(userImageV)
        telphone_edit.leftView = usView
        //显示leftview的方法
        telphone_edit.leftViewMode = UITextFieldViewMode.Always
        
        
        let usView_pass = UIView.init(frame:CGRectMake(0,0, 25,20))
        let userImageV_pass = UIImageView()
        userImageV_pass.image = UIImage(named: "pass")
        userImageV_pass.frame = CGRectMake(10,0, 11,16)
        usView_pass.addSubview(userImageV_pass)
        password_edit.leftView = usView_pass
        password_edit.leftViewMode = UITextFieldViewMode.Always
        
        
        let usView_auth = UIView.init(frame:CGRectMake(0,0, 25,20))
        let userImageV_auth = UIImageView()
        userImageV_auth.image = UIImage(named: "register_icon_authcode")
        userImageV_auth.frame = CGRectMake(10,0, 11,16)
        usView_auth.addSubview(userImageV_auth)
        authoncode.leftView = usView_auth
        authoncode.leftViewMode = UITextFieldViewMode.Always


        
    }
    
    func backClick()
    {
        NSLog("back");
        //self.navigationController?.popViewControllerAnimated(true)
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
        //创建导航控制器
        //let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        //self.view.window!.rootViewController=nvc;
        
        // let sb = UIStoryboard(name:"Main", bundle: nil)
        //let vc = sb.instantiateViewControllerWithIdentifier("registerController") as! RegisterViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func getauthoncode(sender: UIButton) {
        self.countDown(60)
        let tel:String = self.telphone_edit.text as String!
        let  dic:Dictionary<String,String> = ["_telphone" : tel]
        Alamofire.request(.POST, "http://api.bbxiaoqu.com/getauthcode.php", parameters: dic)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                print(response.result.value)
                                if let JSON = response.result.value {
                                    print("JSON: \(JSON)")
                                    self.authoncode.text=String(JSON as! NSNumber);
                                }
        }
    }
    
    @IBAction func regmember(sender: UIButton) {
        let tel:String = self.telphone_edit.text as String!
        let password:String = self.password_edit.text as String!
        let authcode:String = self.authoncode.text as String!
        let  dic:Dictionary<String,String> = ["_userid" : tel,"_telphone" : tel,"_password" : password,"_authoncode" : authcode]
        Alamofire.request(.POST, "http://api.bbxiaoqu.com/save.php", parameters: dic)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                print(response.result.value)
                if let ret = response.result.value  {
                    // print("JSON: \(JSON)")
                   if String(ret)=="1"
                   {
                        self.alertView = UIAlertView()
                        self.alertView!.title = "注册提示"
                        self.alertView!.message = "保存成功"
                        self.alertView!.addButtonWithTitle("关闭")
                        NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"dismiss:", userInfo:self.alertView!, repeats:false)
                        self.alertView!.show()
                    
                   } else if String(ret)=="2"
                   {
                        self.alertView = UIAlertView()
                        self.alertView!.title = "注册提示"
                        self.alertView!.message = "用户ID已注册"
                        self.alertView!.addButtonWithTitle("关闭")
                        NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"dismiss:", userInfo:self.alertView!, repeats:false)
                        self.alertView!.show()
                   }else if String(ret)=="3"
                   {
                        self.alertView = UIAlertView()
                        self.alertView!.title = "注册提示"
                        self.alertView!.message = "手机号已注册"
                        self.alertView!.addButtonWithTitle("关闭")
                        NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"dismiss:", userInfo:self.alertView!, repeats:false)
                        self.alertView!.show()
                    }else if String(ret)=="4"
                   {
                        self.alertView = UIAlertView()
                        self.alertView!.title = "注册提示"
                        self.alertView!.message = "保存失败"
                        self.alertView!.addButtonWithTitle("关闭")
                        NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"dismiss:", userInfo:self.alertView!, repeats:false)
                        self.alertView!.show()
                    }
                }
        }

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
    
    func dismiss(timer:NSTimer){
        alertView!.dismissWithClickedButtonIndex(0, animated:true)
    }

}
