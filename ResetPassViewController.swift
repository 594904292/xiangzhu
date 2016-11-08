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
    
     var alertView:UIAlertController?
    
    
    
    @IBOutlet weak var submit: UIButton!
    
    
    @IBAction func uicontrolTouchDown(_ sender: UIControl) {
        pass1.resignFirstResponder()
        pass2.resignFirstResponder()
    }
    
    
    @IBAction func resetpass(_ sender: UIButton) {
        if(pass1.text != pass2.text)
        {
            
            self.alertView = UIAlertController(title: "提示", message: "电话不能为空", preferredStyle: .alert)
            self.alertView?.addAction(UIAlertAction(title: "关闭", style: .default, handler: nil))
            self.present(self.alertView!, animated: true, completion: nil)
            return;

           
        }
        
        let  dic:Dictionary<String,String> = ["_telphone" : telphone,"_password" : pass1.text!]
        Alamofire.request( "http://api.bbxiaoqu.com/resetpass.php",method:HTTPMethod.post, parameters: dic)
            .responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
                print(response.result)   // result of response serialization
                //print(response.result.value)
                if let ret = response.result.value  {
                    // print("JSON: \(JSON)")
                    if String(describing: ret)=="1"
                    {
                        self.noticeSuccess("重设成功")
                        let sb = UIStoryboard(name:"Main", bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: "loginController") as! LoginViewController
                        self.present(vc, animated: true, completion: nil)
                    } else
                    {
                        self.alertView = UIAlertController(title: "提示", message: "重设失败", preferredStyle: .alert)
                        self.alertView?.addAction(UIAlertAction(title: "关闭", style: .default, handler: nil))
                        self.present(self.alertView!, animated: true, completion: nil)
                        return;
                    }
                }
        }

    }
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="重设密码"
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        let navBar=UINavigationBar.appearance()
        navBar.barTintColor=UIColor(red: 204/255, green: 0, blue: 0, alpha: 1)
        var arrs=[String:AnyObject]();
        arrs[NSForegroundColorAttributeName]=UIColor.white
        navBar.titleTextAttributes=arrs
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.done, target: self, action: #selector(ResetPassViewController.backClick))
        
        
        
        let usView_pass = UIView.init(frame:CGRect(x: 0,y: 0, width: 25,height: 20))
        let userImageV_pass = UIImageView()
        userImageV_pass.image = UIImage(named: "pass")
        userImageV_pass.frame = CGRect(x: 10,y: 0, width: 11,height: 16)
        usView_pass.addSubview(userImageV_pass)
        pass1.leftView = usView_pass
        pass1.leftViewMode = UITextFieldViewMode.always
        
        let usView_pass1 = UIView.init(frame:CGRect(x: 0,y: 0, width: 25,height: 20))
        let userImageV_pass1 = UIImageView()
        userImageV_pass1.image = UIImage(named: "pass")
        userImageV_pass1.frame = CGRect(x: 10,y: 0, width: 11,height: 16)
        usView_pass1.addSubview(userImageV_pass1)
        pass2.leftView = usView_pass1
        pass2.leftViewMode = UITextFieldViewMode.always
        
    }
    
    func backClick()
    {
        NSLog("back");
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
