//
//  SystemSettingViewController.swift
//  bbm
//
//  Created by songgc on 16/5/23.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import AudioToolbox
import Alamofire

class SystemSettingViewController: UIViewController,XxDL {
    var openmessflag=false;
    var openvoiceflag=false;
    @IBOutlet weak var openmessswitch: UISwitch!
    @IBOutlet weak var openvoiceswitch: UISwitch!
    
    @IBAction func openmess(_ sender: UISwitch) {
        var open:String="0"
        if sender.isOn == true
        {
            self.openmessflag=true
            open="1"
        }else
        {
            self.openmessflag=false
            open="0"

        }
        
        let defaults = UserDefaults.standard;
       
        defaults.set(self.openmessflag, forKey: "openmessflag");
        defaults.synchronize();
        
        Alamofire.request( "http://api.bbxiaoqu.com/resetuserfield.php", method:HTTPMethod.post,parameters:["userid" : self.userid,"field":"isrecvmess","fieldvalue":open])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                print(response.result.value)
                
                
        }


    }
    
    @IBAction func openvoice(_ sender: UISwitch) {
          var open:String="0"
        if sender.isOn == true
        {
            self.openvoiceflag=true
            open="1"

        }else
        {
            self.openvoiceflag=false
            open="0"
            
        }
        
        let defaults = UserDefaults.standard;

        defaults.set(self.openvoiceflag, forKey: "openvoiceflag");
        defaults.synchronize();
        Alamofire.request( "http://api.bbxiaoqu.com/resetuserfield.php",method:HTTPMethod.post, parameters:["userid" : self.userid,"field":"isopenvoice","fieldvalue":open])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                print(response.result.value)
                
                
        }
    }
    
    func newMsg(_ aMsg: WXMessage) {
        //无需实现
    }

    
    @IBAction func exit(_ sender: UIButton) {
        NSLog("offlineClick")
        zdl().disConnect()

        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "loginController") as! LoginViewController
        vc.reloadInputViews();
        self.present(vc, animated: true, completion: nil)
    }
    var userid:String = "";
    var flag1:String = "";
    var flag2:String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        super.viewDidLoad()
        self.title="我的"
        //self.view.backgroundColor=UIColor.grayColor()
        // Do any additional setup after loading the view.
        self.navigationItem.title="系统设置"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.done, target: self, action: #selector(SystemSettingViewController.backClick))
        //self.appDelegate().connect()
        
        let defaults = UserDefaults.standard;
        userid = defaults.object(forKey: "userid") as! String;
        
        flag1 = defaults.object(forKey: "openmessflag") as! String;
        flag2 = defaults.object(forKey: "openvoiceflag") as! String;
        
        if flag1=="1"
        {
            openmessswitch.isOn=true
        }else
        {
            openmessswitch.isOn=false
        }
        if flag2=="1"
        {
            openvoiceswitch.isOn=true
        }else
        {
            openvoiceswitch.isOn=false
        }

//        defaults.setObject(isrecvmess, forKey: "openmessflag");
//        defaults.setObject(isopenvice, forKey: "openvoiceflag");
        zdl().xxdl = self
        
        zdl().connect()
    }

    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewController(animated: true)
    }
    //获取总代理
    func zdl() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
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
