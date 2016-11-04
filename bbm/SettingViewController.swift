//
//  SettingViewController.swift
//  bbm
//
//  Created by ericsong on 15/12/22.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class SettingViewController: UIViewController,UINavigationControllerDelegate {
    
    
    @IBAction func uicontroldown(_ sender: UIControl) {
        self.content.resignFirstResponder()
        //sender.resignFirstResponder()
    }
    
    
    var alertView:UIAlertView?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
//        self.navigationItem.title="关于建议"
//        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
//        
        self.navigationItem.title="建议"
        let returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(SettingViewController.backClick))
        
        item3.tintColor=UIColor.white
        
        self.navigationItem.leftBarButtonItem=item3
        
        
        let searchimg=UIImage(named: "xz_nav_icon_search")
        
        let item4=UIBarButtonItem(image: searchimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(SettingViewController.searchClick))
        
        item4.tintColor=UIColor.white
        
        self.navigationItem.rightBarButtonItem=item4

        
        let contentlayer:CALayer = content.layer
        contentlayer.borderColor=UIColor.lightGray.cgColor
        contentlayer.opacity=0.3
        contentlayer.borderWidth = 1.0;
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchClick()
    {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "souviewcontroller") as! SouViewController
        self.navigationController?.pushViewController(vc, animated: true)
        //var vc = SearchViewController()
        //self.navigationController?.pushViewController(vc, animated: true)
    }

    
    @IBOutlet weak var content: UITextView!
    @IBAction func submit(_ sender: UIButton) {
        if(content.text?.characters.count==0)
        {
            self.alertView = UIAlertView()
            self.alertView!.title = "提示"
            self.alertView!.message = "建议为空"
            self.alertView!.addButton(withTitle: "关闭")
            Timer.scheduledTimer(timeInterval: 1, target:self, selector:#selector(SettingViewController.dismiss(_:)), userInfo:self.alertView!, repeats:false)
            self.alertView!.show()
            return;
        }
        let alertView = UIAlertView()
        alertView.title = "系统提示"
        alertView.message = "您确定提交建议吗？"
        alertView.addButton(withTitle: "取消")
        alertView.addButton(withTitle: "确定")
        alertView.cancelButtonIndex=0
        alertView.delegate=self;
        alertView.show()
        
        
       
    }
    func dismiss(_ timer:Timer){
        alertView!.dismiss(withClickedButtonIndex: 0, animated:true)
    }
    
    func alertView(_ alertView:UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if(buttonIndex==alertView.cancelButtonIndex){
            print("点击了取消")
        }
        else
        {
            NSLog("add")
            let defaults = UserDefaults.standard;
            let userid = defaults.object(forKey: "userid") as! String;
            let date = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
            let strNowTime = timeFormatter.string(from: date) as String
            let mess:String = content.text!
            let  dic:Dictionary<String,String> = ["content" : mess, "userid": userid, "addtime": strNowTime]
            Alamofire.request("http://api.bbxiaoqu.com/savesuggest.php",method:HTTPMethod.post, parameters: dic)
                .responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    print(response.result.value)
                    //                if let JSON = response.result.value {
                    //                    print("JSON: \(JSON)")
                    //                }
                    self.content.text = "";
                    self.successNotice("提交成功")
                    self.backClick()

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

}
