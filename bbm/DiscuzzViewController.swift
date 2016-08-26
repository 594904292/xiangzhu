//
//  DiscuzzViewController.swift
//  bbm
//
//  Created by songgc on 16/8/18.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire

class DiscuzzViewController: UIViewController,UINavigationControllerDelegate,UITextViewDelegate{
    var guid:String = "";
    var infoid:String = "";
    var puserid:String=""
    var puser:String=""
    
    var senduserid:String=""
    var senduser:String=""
    var headface:String=""

    @IBOutlet weak var headface_img: UIImageView!
    @IBOutlet weak var status_img: UIImageView!
  
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var time_lbl: UILabel!
    @IBOutlet weak var address_lbl: UILabel!
    @IBOutlet weak var content_lbl: UILabel!
    @IBOutlet weak var discuzzbody: UITextView!
    
    
    
    @IBAction func toptouchdown(sender: UIControl) {
        //self.successNotice("aaa")
        self.view.endEditing(true)


    }
    @IBAction func controltouchdown(sender: UIControl) {
        //self.successNotice("bbb")
        self.view.endEditing(true)


    }
    
    
    func textViewShouldBeginEditing(textView: UITextView!) -> Bool {
        return true;
    }
    
    func textViewShouldEndEditing(textView: UITextView!) -> Bool {
        return true;
    }
    
    func textViewDidBeginEditing(textView: UITextView!) {
    }
    
    func textViewDidEndEditing(textView: UITextView!) {
    }
    
    func textView(textView: UITextView!, shouldChangeTextInRange range: NSRange, replacementText text: String!) -> Bool {
        if(text=="\n")
        {
            self.view.endEditing(true)
            return false;
        }
        return true;
    }
    
    func textViewDidChange(textView: UITextView!) {
    }
    
    func textViewDidChangeSelection(textView: UITextView!) {
    }
    
    func textView(textView: UITextView!, shouldInteractWithURL URL: NSURL!, inRange characterRange: NSRange) -> Bool {
        return true;
    }
    
    func textView(textView: UITextView!, shouldInteractWithTextAttachment textAttachment: NSTextAttachment!, inRange characterRange: NSRange) -> Bool {
        return true;
    }
    
//    @IBAction func atouchdown(sender: UIControl) {
//        self.successNotice("aaa")
//    }
//    @IBAction func controlTouchDown(sender: UIControl) {
//        discuzzbody.resignFirstResponder()
//
//    }
    @IBAction func sendDiscuzz(sender: UIButton) {
        let sender = discuzzbody
        
        if(sender.text?.characters.count==0)
        {
            self.successNotice("评论不能为空")
            return;
        }
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let strNowTime = timeFormatter.stringFromDate(date) as String
        
        let defaults = NSUserDefaults.standardUserDefaults();
        senduserid = defaults.objectForKey("userid") as! String;
        senduser = defaults.objectForKey("nickname") as! String;
        
        headface = defaults.objectForKey("headface") as! String;
        let  dic:Dictionary<String,String> = ["_infoid" : infoid,"_sendtime" : strNowTime,"_puserid" : puserid,"_puser" : puser,"_touserid" : senduserid,"_touser" : senduser,"_message" : sender.text!]
         activityIndicatorView.startAnimating()
        let url_str:String = "http://api.bbxiaoqu.com/discuzz.php";
        Alamofire.request(.POST,url_str, parameters:dic)
            .responseString{ response in
                if(response.result.isSuccess)
                {
                    if let ret = response.result.value  {
                        //if String(ret)=="1"
                        //{
                            self.successNotice("提交成功")
                            self.AddInfoHelpUserThread();
                        //}
                    }
                }else
                {
                    self.activityIndicatorView.stopAnimating()
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }
    }
    
    var activityIndicatorView: UIActivityIndicatorView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initnavbar("发布文字评论")
        // Do any additional setup after loading the view.
        loadinfo("guid",id: guid)
         discuzzbody.delegate = self;
        //self.discuzzbody.returnKeyType=UIReturnKeyDone;
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        
        activityIndicatorView.frame = CGRectMake(self.view.frame.size.width/2 - 50, 250, 100, 100)
        
        
        
        activityIndicatorView.hidesWhenStopped = true
        
        activityIndicatorView.color = UIColor.blackColor()
        
        self.view.addSubview(activityIndicatorView)
    }
    
    func initnavbar(titlestr:String)
    {
        self.title=titlestr
        var returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.Plain, target: self,  action: "backClick")
        
        item3.tintColor=UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem=item3
        
        
        
        
        var searchimg=UIImage(named: "xz_nav_icon_search")
        
        let item4=UIBarButtonItem(image: searchimg, style: UIBarButtonItemStyle.Plain, target: self,  action: "searchClick")
        
        item4.tintColor=UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem=item4
    }
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func searchClick()
    {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("souviewcontroller") as! SouViewController
        self.navigationController?.pushViewController(vc, animated: true)
        //var vc = SearchViewController()
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var photo:String=""
    func loadinfo(idtype:String,id:String)
    {
        var url_str:String = "";
        if(idtype == "guid")
        {
            url_str = "http://api.bbxiaoqu.com/getinfo_v1.php?idtype=guid&guid=".stringByAppendingString(id)
            
        }else
        {
            url_str = "http://api.bbxiaoqu.com/getinfo_v1.php?idtype=infoid&guid=".stringByAppendingString(id)
        }
        Alamofire.request(.GET,url_str, parameters:nil)
            .responseJSON {response in
                if(response.result.isSuccess)
                {
                    print(response.result.value)
                    if let JSON = response.result.value {
                            self.infoid = JSON[0].objectForKey("id") as! String;
                            self.title = JSON[0].objectForKey("title") as? String;
                            self.headface = JSON[0].objectForKey("headface") as! String
                            self.puserid = JSON[0].objectForKey("senduser") as! String;
                            self.puser = JSON[0].objectForKey("username") as! String;
                            let contentstr:String = JSON[0].objectForKey("content") as! String;
                            let sendtimestr:String = JSON[0].objectForKey("sendtime") as! String;
                            let sendaddress = JSON[0].objectForKey("address") as! String
                            let status = JSON[0].objectForKey("status") as! String
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.username_lbl.text = self.puser
                                self.address_lbl.text = sendaddress
                                self.time_lbl.text = sendtimestr;
                                self.content_lbl.text = contentstr
                                if(status=="2")
                                {
                                     self.status_img.image=UIImage(named: "xz_yijiejue_icon")
                                }else
                                {
                                    self.status_img.image=UIImage(named: "xz_qiuzhu_icon")
                                }
                                if(self.headface.characters.count>0)
                                {
                                    let myhead:String="http://api.bbxiaoqu.com/uploads/".stringByAppendingString(self.headface)
                                    Alamofire.request(.GET, myhead).response { (_, _, data, _) -> Void in
                                        if let d = data as? NSData!
                                        {
                                            self.headface_img?.image=UIImage(data: d)
                                            self.headface_img.layer.cornerRadius = 5.0
                                            self.headface_img.layer.masksToBounds = true
                                        }
                                    }
                                }else
                                {
                                    self.headface_img?.image=UIImage(named: "logo")
                                    self.headface_img.layer.cornerRadius = 5.0
                                    self.headface_img.layer.masksToBounds = true
                                }
                            })
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }
    }

    
    func AddInfoHelpUserThread()
    {
        let defaults = NSUserDefaults.standardUserDefaults();
        var senduseridstr = defaults.objectForKey("userid") as! String;
        
        let  dics:Dictionary<String,String> = ["_userid" : self.puserid,"_senduserid" : senduseridstr,"_infoid" : self.infoid,"_guid" : self.guid,"_type" : "pl","_content" : discuzzbody.text,"_action" : "add"]
        
        var url_str:String = "http://api.bbxiaoqu.com/addinfohelpuser_v1.php";
        Alamofire.request(.POST,url_str, parameters:dics)
            .responseString{ response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                print(response.result.value)
                if(response.result.isSuccess)
                {
                    self.activityIndicatorView.stopAnimating()
                    //self.navigationController?.popViewControllerAnimated(true)
                    var vc = ListViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
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
