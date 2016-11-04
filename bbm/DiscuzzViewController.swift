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
    
    
    
    @IBAction func toptouchdown(_ sender: UIControl) {
        //self.successNotice("aaa")
        self.view.endEditing(true)


    }
    @IBAction func controltouchdown(_ sender: UIControl) {
        //self.successNotice("bbb")
        self.view.endEditing(true)


    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView!) -> Bool {
        return true;
    }
    
    func textViewShouldEndEditing(_ textView: UITextView!) -> Bool {
        return true;
    }
    
    func textViewDidBeginEditing(_ textView: UITextView!) {
    }
    
    func textViewDidEndEditing(_ textView: UITextView!) {
    }
    
    func textView(_ textView: UITextView!, shouldChangeTextIn range: NSRange, replacementText text: String!) -> Bool {
        if(text=="\n")
        {
            self.view.endEditing(true)
            return false;
        }
        return true;
    }
    
    func textViewDidChange(_ textView: UITextView!) {
    }
    
    func textViewDidChangeSelection(_ textView: UITextView!) {
    }
    
    func textView(_ textView: UITextView!, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return true;
    }
    
    func textView(_ textView: UITextView!, shouldInteractWith textAttachment: NSTextAttachment!, in characterRange: NSRange) -> Bool {
        return true;
    }
    
//    @IBAction func atouchdown(sender: UIControl) {
//        self.successNotice("aaa")
//    }
//    @IBAction func controlTouchDown(sender: UIControl) {
//        discuzzbody.resignFirstResponder()
//
//    }
    @IBAction func sendDiscuzz(_ sender: UIButton) {
        let sender = discuzzbody
        
        if(sender?.text?.characters.count==0)
        {
            self.successNotice("评论不能为空")
            return;
        }
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        
        let defaults = UserDefaults.standard;
        senduserid = defaults.object(forKey: "userid") as! String;
        senduser = defaults.object(forKey: "nickname") as! String;
        
        headface = defaults.object(forKey: "headface") as! String;
        let  dic:Dictionary<String,String> = ["_infoid" : infoid,"_sendtime" : strNowTime,"_puserid" : puserid,"_puser" : puser,"_touserid" : senduserid,"_touser" : senduser,"_message" : sender!.text!]
         activityIndicatorView.startAnimating()
        let url_str:String = "http://api.bbxiaoqu.com/discuzz.php";
        Alamofire.request(url_str,method:HTTPMethod.post,parameters:dic)
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
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        
        activityIndicatorView.frame = CGRect(x: self.view.frame.size.width/2 - 50, y: 250, width: 100, height: 100)
        
        
        
        activityIndicatorView.hidesWhenStopped = true
        
        activityIndicatorView.color = UIColor.black
        
        self.view.addSubview(activityIndicatorView)
    }
    
    func initnavbar(_ titlestr:String)
    {
        self.title=titlestr
        let returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(DiscuzzViewController.backClick))
        
        item3.tintColor=UIColor.white
        
        self.navigationItem.leftBarButtonItem=item3
        
        
        
        
        let searchimg=UIImage(named: "xz_nav_icon_search")
        
        let item4=UIBarButtonItem(image: searchimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(DiscuzzViewController.searchClick))
        
        item4.tintColor=UIColor.white
        
        self.navigationItem.rightBarButtonItem=item4
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
    
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var photo:String=""
    func loadinfo(_ idtype:String,id:String)
    {
        var url_str:String = "";
        if(idtype == "guid")
        {
            url_str = "http://api.bbxiaoqu.com/getinfo_v1.php?idtype=guid&guid=" + id
            
        }else
        {
            url_str = "http://api.bbxiaoqu.com/getinfo_v1.php?idtype=infoid&guid=" + id
        }
        Alamofire.request(url_str)
            .responseJSON {response in
                if(response.result.isSuccess)
                {
                    print(response.result.value)
                    if let JSON = response.result.value {
                        
                        let array:NSArray = JSON as! NSArray;
                        let data:NSDictionary = array[0] as! NSDictionary;

                        
                            self.infoid = data.object(forKey: "id") as! String;
                            self.title = data.object(forKey: "title") as? String;
                            self.headface = data.object(forKey: "headface") as! String
                            self.puserid = data.object(forKey: "senduser") as! String;
                            self.puser = data.object(forKey: "username") as! String;
                            let contentstr:String = data.object(forKey: "content") as! String;
                            let sendtimestr:String = data.object(forKey: "sendtime") as! String;
                            let sendaddress = data.object(forKey: "address") as! String
                            let status = data.object(forKey: "status") as! String
                            DispatchQueue.main.async(execute: { () -> Void in
                                
                                let options:NSStringDrawingOptions = .usesLineFragmentOrigin
                                let boundingRect = contentstr.boundingRect(with: CGSize(width: self.view.frame.width, height: 0), options: options, attributes:[NSFontAttributeName:self.content_lbl.font], context: nil)
                                
                                self.content_lbl.frame = CGRect(x: self.content_lbl.frame.origin.x, y: self.content_lbl.frame.origin.y, width: self.view.frame.width, height: boundingRect.height)
                                
                                
                                
                                
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
                                    let myhead:String="http://api.bbxiaoqu.com/uploads/" + self.headface
                                    Util.loadheadface(self.headface_img, url: myhead)
                                    self.headface_img.layer.cornerRadius = (self.headface_img.frame.width) / 2
                                    self.headface_img.layer.masksToBounds = true

                                    
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
        let defaults = UserDefaults.standard;
        let senduseridstr = defaults.object(forKey: "userid") as! String;
        
        let  dics:Dictionary<String,String> = ["_userid" : self.puserid,"_senduserid" : senduseridstr,"_infoid" : self.infoid,"_guid" : self.guid,"_type" : "pl","_content" : discuzzbody.text,"_action" : "add"]
        
        let url_str:String = "http://api.bbxiaoqu.com/addinfohelpuser_v1.php";
        Alamofire.request(url_str,method:HTTPMethod.post, parameters:dics)
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
                    let vc = ListViewController()
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
