//
//  SettingViewController.swift
//  bbm
//
//  Created by ericsong on 15/12/22.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class AboutSugguestViewController: UIViewController,UINavigationControllerDelegate {
    
    
    @IBAction func uicontroldown(_ sender: UIControl) {
        self.content.resignFirstResponder()
        //sender.resignFirstResponder()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title="关于建议"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.done, target: self, action: #selector(AboutSugguestViewController.backClick))

        let contentlayer:CALayer = content.layer
        contentlayer.borderColor=UIColor.lightGray.cgColor
        contentlayer.opacity=0.3
        contentlayer.borderWidth = 1.0;
        
        let infoDictionary = Bundle.main.infoDictionary
        
        //let appDisplayName: AnyObject? = infoDictionary![ "CFBundleDisplayName"] as AnyObject?
        
        let majorVersion : String = infoDictionary! [ "CFBundleShortVersionString"] as! String
        
        let minorVersion : String = infoDictionary! [ "CFBundleVersion"] as! String
        
        desc.text=((("襄助(" + majorVersion) + ".") + minorVersion) + ")是基于位置的是传播正能量的联网互助平台。让附近的人互相帮忙，我们希望把大众的力量组织起来，有一技之长的人可以通过“襄助”为附近的人提供帮助；普通大众可以通过“襄助” 快速寻求帮助。 “涓滴之水成海洋，颗颗爱心变希望”。"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backClick()
    {
        self.navigationController!.popViewController(animated: true)
    }

    
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var desc: UILabel!
    @IBAction func submit(_ sender: UIButton) {
        if(content.text?.characters.count==0)
        {
            let alertMessage  = UIAlertController(title: "提示", message: "建议不能为空", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "关闭", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
            return;
        }
        
        
        let alertMessage  = UIAlertController(title: "系统提示", message: "您确定提交建议吗？", preferredStyle: .alert)
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
            Alamofire.request( "http://api.bbxiaoqu.com/savesuggest.php", method:.post,parameters: dic)
                .responseJSON { response in
                    self.content.text = "";
            }
        }
        let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.default, handler: callOkActionHandler)
        alertMessage.addAction(cancelAction)
        alertMessage.addAction(okAction)
        self.present(alertMessage, animated: true, completion: nil)
       
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
