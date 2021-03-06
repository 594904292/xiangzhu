//
//  ResetPassViewController.swift
//  bbm
//
//  Created by ericsong on 16/2/22.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class ResetPassViewController: UIViewController {

    var telphone:String="";
    
    @IBOutlet weak var pass1: UITextField!
    
    @IBOutlet weak var pass2: UITextField!
    
     var alertView:UIAlertView?
    
    
    
    @IBOutlet weak var submit: UIButton!
    
    
    @IBAction func uicontrolTouchDown(sender: UIControl) {
        pass1.resignFirstResponder()
        pass2.resignFirstResponder()
    }
    
    
    @IBAction func resetpass(sender: UIButton) {
        if(pass1.text != pass2.text)
        {
            
            self.alertView = UIAlertView()
            self.alertView!.title = "提示"
            self.alertView!.message = "电话不能为空"
            self.alertView!.addButtonWithTitle("关闭")
            NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"dismiss:", userInfo:self.alertView!, repeats:false)
            self.alertView!.show()
            return;

        }
        
        let  dic:Dictionary<String,String> = ["_telphone" : telphone,"_password" : pass1.text!]
        Alamofire.request(.POST, "http://api.bbxiaoqu.com/resetpass.php", parameters: dic)
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
                        self.alertView!.title = "提示"
                        self.alertView!.message = "重设成功"
                        self.alertView!.addButtonWithTitle("关闭")
                        NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"dismiss:", userInfo:self.alertView!, repeats:false)
                        self.alertView!.show()
                        
                        let sb = UIStoryboard(name:"Main", bundle: nil)
                        let vc = sb.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
                        self.presentViewController(vc, animated: true, completion: nil)

                        
                    } else
                    {
                        self.alertView = UIAlertView()
                        self.alertView!.title = "提示"
                        self.alertView!.message = "重设失败"
                        self.alertView!.addButtonWithTitle("关闭")
                        NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"dismiss:", userInfo:self.alertView!, repeats:false)
                        self.alertView!.show()
                    }
                }
        }

    }
    
    
    func dismiss(timer:NSTimer){
        alertView!.dismissWithClickedButtonIndex(0, animated:true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="重设密码"
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        let navBar=UINavigationBar.appearance()
        navBar.barTintColor=UIColor(red: 204/255, green: 0, blue: 0, alpha: 1)
        var arrs=[String:AnyObject]();
        arrs[NSForegroundColorAttributeName]=UIColor.whiteColor()
        navBar.titleTextAttributes=arrs
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        
        
        
        let usView_pass = UIView.init(frame:CGRectMake(0,0, 25,20))
        let userImageV_pass = UIImageView()
        userImageV_pass.image = UIImage(named: "pass")
        userImageV_pass.frame = CGRectMake(10,0, 11,16)
        usView_pass.addSubview(userImageV_pass)
        pass1.leftView = usView_pass
        pass1.leftViewMode = UITextFieldViewMode.Always
        
        let usView_pass1 = UIView.init(frame:CGRectMake(0,0, 25,20))
        let userImageV_pass1 = UIImageView()
        userImageV_pass1.image = UIImage(named: "pass")
        userImageV_pass1.frame = CGRectMake(10,0, 11,16)
        usView_pass1.addSubview(userImageV_pass1)
        pass2.leftView = usView_pass1
        pass2.leftViewMode = UITextFieldViewMode.Always
        
    }
    
    func backClick()
    {
        NSLog("back");
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
        //创建导航控制器
        //let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        //self.view.window!.rootViewController=nvc;
        self.presentViewController(vc, animated: true, completion: nil)

       
        
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
