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
    
    
    var alertView:UIAlertController?
    override func viewDidLoad() {
        super.viewDidLoad()

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
        self.navigationController!.popViewController(animated: true)
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
            self.alertView = UIAlertController(title: "系统提示", message: "建议不能为空", preferredStyle: .alert)
            self.alertView?.addAction(UIAlertAction(title: "关闭", style: .default, handler: nil))
            self.present(self.alertView!, animated: true, completion: nil)
            return;
        }
        self.alertView = UIAlertController(title: "系统提示", message: "您确定提交建议吗?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        let callOkActionHandler = { (action:UIAlertAction!) -> Void in
            NSLog("add")
            let defaults = UserDefaults.standard;
            let userid = defaults.object(forKey: "userid") as! String;
            let date = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
            let strNowTime = timeFormatter.string(from: date) as String
            let mess:String = self.content.text!
            let  dic:Dictionary<String,String> = ["content" : mess, "userid": userid, "addtime": strNowTime]
            Alamofire.request("http://api.bbxiaoqu.com/savesuggest.php",method:HTTPMethod.post, parameters: dic)
                .responseJSON { response in
                    print(response.result)
                     self.content.text = "";
                    self.successNotice("提交成功")
                    self.backClick()
                    
            }
        }
        let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.default, handler: callOkActionHandler)
        self.alertView?.addAction(cancelAction)
        self.alertView?.addAction(okAction)
        self.present(self.alertView!, animated: true, completion: nil)
        return;
        
       
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
