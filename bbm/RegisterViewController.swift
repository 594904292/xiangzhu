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
    
    var alertView:UIAlertController?
    @IBOutlet weak var telphone_edit: UITextField!
    @IBOutlet weak var password_edit: UITextField!
    @IBOutlet weak var authoncode: UITextField!
    @IBOutlet weak var authonbtn: RFCodeCountdownBtn!

    
    @IBAction func uicontrolTouchDown(_ sender: UIControl) {
        telphone_edit.resignFirstResponder()
        password_edit.resignFirstResponder()

        authoncode.resignFirstResponder()


    }
    @IBAction func telphone_exit(_ sender: UITextField) {
        telphone_edit.resignFirstResponder()
    }
    
    @IBAction func pass_exit(_ sender: UITextField) {
        password_edit.resignFirstResponder()
    }
    
    @IBAction func auth_exit(_ sender: UITextField) {
        authoncode.resignFirstResponder()
    }
       
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="注册"
         // Do any additional setup after loading the view.
        let navBar=UINavigationBar.appearance()
        navBar.barTintColor=UIColor(red: 204/255, green: 0, blue: 0, alpha: 1)
        var arrs=[String:AnyObject]();
        arrs[NSForegroundColorAttributeName]=UIColor.white
        navBar.titleTextAttributes=arrs

        let item3 = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.done, target: self, action: #selector(RegisterViewController.backClick))
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
        telphone_edit.leftView = usView
        //显示leftview的方法
        telphone_edit.leftViewMode = UITextFieldViewMode.always
        
        
        let usView_pass = UIView.init(frame:CGRect(x: 0,y: 0, width: 25,height: 20))
        let userImageV_pass = UIImageView()
        userImageV_pass.image = UIImage(named: "pass")
        userImageV_pass.frame = CGRect(x: 10,y: 0, width: 11,height: 16)
        usView_pass.addSubview(userImageV_pass)
        password_edit.leftView = usView_pass
        password_edit.leftViewMode = UITextFieldViewMode.always
        
        
        let usView_auth = UIView.init(frame:CGRect(x: 0,y: 0, width: 25,height: 20))
        let userImageV_auth = UIImageView()
        userImageV_auth.image = UIImage(named: "register_icon_authcode")
        userImageV_auth.frame = CGRect(x: 10,y: 0, width: 11,height: 16)
        usView_auth.addSubview(userImageV_auth)
        authoncode.leftView = usView_auth
        authoncode.leftViewMode = UITextFieldViewMode.always

        
        
        
    }
    
    
    func onecall()
    {
        var textF1 = UITextField()
        let alertController = UIAlertController(title: "Alert Title", message: "Subtitle", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField { (textField1) -> Void in
            textF1 = textField1
            textF1.placeholder = "hello grandre"
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        let callOkActionHandler = { (action:UIAlertAction!) -> Void in
            let alertMessage = UIAlertController(title: "Service Unavailable", message: "Sorry,the call feature is not available yet. Please retry later."+textF1.text!, preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }
        let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.default, handler: callOkActionHandler)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    
    }
    
    func backClick()
    {
        NSLog("back");
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "loginController") as! LoginViewController
        self.present(vc, animated: true, completion: nil)
        
    }
    

    
    @IBAction func getauthcode(_ sender: RFCodeCountdownBtn) {
        print("getauthcode")
        if(self.telphone_edit.text!.characters.count==0)
        {
            self.alertView = UIAlertController(title: "提示", message: "用户手机号不能为空", preferredStyle: .alert)
            self.alertView?.addAction(UIAlertAction(title: "关闭", style: .default, handler: nil))
            self.present(self.alertView!, animated: true, completion: nil)
            return;
        }

        authonbtn.countDown = true
        authonbtn.maxTimer = 60
        let tel:String = self.telphone_edit.text as String!
        let  dic:Dictionary<String,String> = ["_telphone" : tel]
        Alamofire.request("http://api.bbxiaoqu.com/getauthcode.php?show=true", method:HTTPMethod.post,parameters: dic)
            .responseJSON { response in
                print(response.result)   // result of response serialization
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    //self.authoncode.text=String(describing: JSON as! NSNumber);
                }
        }

    }
    
    
    
    @IBAction func regmember(_ sender: UIButton) {
        if(self.telphone_edit.text!.characters.count==0)
        {
            self.alertView = UIAlertController(title: "提示", message: "用户手机号不能为空", preferredStyle: .alert)
            self.alertView?.addAction(UIAlertAction(title: "关闭", style: .default, handler: nil))
            self.present(self.alertView!, animated: true, completion: nil)
            return;
           
        }
        if(self.password_edit.text!.characters.count==0)
        {
            self.alertView = UIAlertController(title: "提示", message: "密码不能为空", preferredStyle: .alert)
            self.alertView?.addAction(UIAlertAction(title: "关闭", style: .default, handler: nil))
            self.present(self.alertView!, animated: true, completion: nil)
            return;
        }
        if(self.authoncode.text!.characters.count==0)
        {
            self.alertView = UIAlertController(title: "提示", message: "验证码不能为空", preferredStyle: .alert)
            self.alertView?.addAction(UIAlertAction(title: "关闭", style: .default, handler: nil))
            self.present(self.alertView!, animated: true, completion: nil)
            return;
        }

        let tel:String = self.telphone_edit.text as String!
        let password:String = self.password_edit.text as String!
        let authcode:String = self.authoncode.text as String!
        let  dic:Dictionary<String,String> = ["_userid" : tel,"_telphone" : tel,"_password" : password,"_authoncode" : authcode]
        Alamofire.request("http://api.bbxiaoqu.com/save.php", method:HTTPMethod.post,parameters: dic)
            .responseJSON { response in
                print(response.result)   // result of response serialization
                if let ret = response.result.value  {
                    // print("JSON: \(JSON)")
                   if String(describing: ret)=="1"
                   {
                        self.alertView = UIAlertController(title: "注册提示", message: "保存成功", preferredStyle: .alert)
                        self.alertView?.addAction(UIAlertAction(title: "关闭", style: .default, handler: nil))
                        self.present(self.alertView!, animated: true, completion: nil)
                        return;
                   } else if String(describing: ret)=="2"
                   {
                        self.alertView = UIAlertController(title: "注册提示", message: "用户ID已注册", preferredStyle: .alert)
                        self.alertView?.addAction(UIAlertAction(title: "关闭", style: .default, handler: nil))
                        self.present(self.alertView!, animated: true, completion: nil)
                        return;
                    
                   } else if String(describing: ret)=="3"
                   {
                    
                        self.alertView = UIAlertController(title: "注册提示", message: "手机号已注册", preferredStyle: .alert)
                        self.alertView?.addAction(UIAlertAction(title: "关闭", style: .default, handler: nil))
                        self.present(self.alertView!, animated: true, completion: nil)
                        return;
                   }else if String(describing: ret)=="4"
                   {
                        self.alertView = UIAlertController(title: "注册提示", message: "保存成功", preferredStyle: .alert)
                        self.alertView?.addAction(UIAlertAction(title: "关闭", style: .default, handler: nil))
                        self.present(self.alertView!, animated: true, completion: nil)
                        return;

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
    
}
