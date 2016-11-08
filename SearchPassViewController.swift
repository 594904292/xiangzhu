//
//  SearchPassViewController.swift
//  bbm
//
//  Created by ericsong on 16/2/22.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class SearchPassViewController: UIViewController {

    @IBOutlet weak var telphone: UITextField!
   
    @IBOutlet weak var authcode: UITextField!
    
    @IBOutlet weak var authonbtn: RFCodeCountdownBtn!
    
    @IBOutlet weak var nextbtn: UIButton!
    var lastauthcode:String = "9811";
    
    @IBAction func controltouchdown(_ sender: AnyObject) {
        telphone.resignFirstResponder()
        authcode.resignFirstResponder()
    }
    
    @IBAction func telphone_exit(_ sender: UITextField) {
        self.resignFirstResponder()
        
    }
    
    @IBAction func authcode_exit(_ sender: UITextField) {
        
        self.resignFirstResponder()
    }
    
    @IBAction func GetAuthCode(_ sender: RFCodeCountdownBtn) {
        if(self.telphone.text!.characters.count==0)
        {
            self.alertView = UIAlertController(title: "提示", message: "电话不能为空", preferredStyle: .alert)
            self.alertView?.addAction(UIAlertAction(title: "关闭", style: .default, handler: nil))
            self.present(self.alertView!, animated: true, completion: nil)
            return;
        }
        authonbtn.countDown = true
        authonbtn.maxTimer = 60
        let tel:String = self.telphone.text as String!
        let  dic:Dictionary<String,String> = ["_telphone" : tel]
        Alamofire.request("http://api.bbxiaoqu.com/getauthcode.php?show=true",method:HTTPMethod.post, parameters: dic)
            .responseJSON { response in
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    //self.authcode.text=String(describing: JSON as! NSNumber);
                    self.lastauthcode=String(describing: JSON as! NSNumber);
                }
        }
        

    }
    
    @IBAction func GetAuthcode(_ sender: UIButton) {
        
        if(self.telphone.text!.characters.count==0)
        {
            self.alertView = UIAlertController(title: "提示", message: "电话不能为空", preferredStyle: .alert)
            self.alertView?.addAction(UIAlertAction(title: "关闭", style: .default, handler: nil))
            self.present(self.alertView!, animated: true, completion: nil)
            return;

        }
        authonbtn.countDown = true
        authonbtn.maxTimer = 60
        let tel:String = self.telphone.text as String!
        let  dic:Dictionary<String,String> = ["_telphone" : tel]
        Alamofire.request("http://api.bbxiaoqu.com/getauthcode.php?show=true",method:HTTPMethod.post, parameters: dic)
            .responseJSON { response in
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    //self.authcode.text=String(describing: JSON as! NSNumber);
                    //self.lastauthcode=String(describing: JSON as! NSNumber);
                }
        }

    }
    
    @IBAction func authcodechange(_ sender: UITextField) {
        if(self.lastauthcode == sender.text)
        {
        
            self.nextbtn.isEnabled = true

        }else
        {
            self.nextbtn.isEnabled = false

        }
    
    }
    var alertView:UIAlertController?

    @IBAction func NextAction(_ sender: UIButton) {
        
        
        
        if(self.telphone.text!.characters.count==0)
        {
            self.alertView = UIAlertController(title: "提示", message: "电话不能为空", preferredStyle: .alert)
            self.alertView?.addAction(UIAlertAction(title: "关闭", style: .default, handler: nil))
            self.present(self.alertView!, animated: true, completion: nil)
            return;

        }
        if(self.authcode.text!.characters.count==0)
        {
            self.alertView = UIAlertController(title: "提示", message: "认证码不能为空", preferredStyle: .alert)
            self.alertView?.addAction(UIAlertAction(title: "关闭", style: .default, handler: nil))
            self.present(self.alertView!, animated: true, completion: nil)
            return;
        }
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "resetpassController") as! ResetPassViewController
        vc.telphone = telphone.text!
        //创建导航控制器
        let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        self.view.window!.rootViewController=nvc;

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title="忘记密码"
        self.title="忘记密码"
        let navBar=UINavigationBar.appearance()
        navBar.barTintColor=UIColor(red: 204/255, green: 0, blue: 0, alpha: 1)
        var arrs=[String:AnyObject]();
        arrs[NSForegroundColorAttributeName]=UIColor.white
        navBar.titleTextAttributes=arrs
        nextbtn.isEnabled=false
        // Do any additional setup after loading the view.
        let item3 = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.done, target: self, action: #selector(SearchPassViewController.backClick))
        item3.tintColor=UIColor.white
        self.navigationItem.leftBarButtonItem=item3
        
        //添加左边view
        let usView = UIView.init(frame:CGRect(x: 0,y: 0, width: 25,height: 20))
        //把imageView添加到view中可以设置左边和右边的输入距离
        let userImageV = UIImageView()
        userImageV.image = UIImage(named: "tel")
        userImageV.frame = CGRect(x: 10,y: 0, width: 11,height: 16)
        //图片变形
        //userImageV.contentMode = UIViewContentMode.ScaleAspectFit
        usView.addSubview(userImageV)
        telphone.leftView = usView
        //显示leftview的方法
        telphone.leftViewMode = UITextFieldViewMode.always
        
        
        let usView_auth = UIView.init(frame:CGRect(x: 0,y: 0, width: 25,height: 20))
        let userImageV_auth = UIImageView()
        userImageV_auth.image = UIImage(named: "register_icon_authcode")
        userImageV_auth.frame = CGRect(x: 10,y: 0, width: 11,height: 16)
        usView_auth.addSubview(userImageV_auth)
        authcode.leftView = usView_auth
        authcode.leftViewMode = UITextFieldViewMode.always

        
        
    }
    
    func backClick()
    {
        NSLog("back");
        //self.navigationController?.popViewControllerAnimated(true)
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "loginController") as! LoginViewController
        //创建导航控制器
        //let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        //self.view.window!.rootViewController=nvc;
         self.present(vc, animated: true, completion: nil)
        
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
