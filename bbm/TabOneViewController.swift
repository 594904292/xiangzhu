//
//  MainViewController.swift
//  bbm
//
//  Created by ericsong on 15/12/10.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
import AudioToolbox

//class MainViewController: UIViewController,UIScrollViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,XxMainDL{
class TabOneViewController: UIViewController {
    var ggid:String = "";
    var tel3_phonenum:String=""
    var tel3:UIButton = UIButton()
    var tel3_label:UILabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        var w:CGFloat = self.view.frame.width
        var h1:CGFloat = self.view.frame.height/10;
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: w, height: h1*4))
        let imageView=UIImageView(image:UIImage(named:"banner1"))
        imageView.frame=CGRectMake(0,0,w,h1*4)
        customView.addSubview(imageView)
        self.view.addSubview(customView)
        ////////////////////////////////////
        
        var perww  = w/2/5
        let customView2 = UIView(frame: CGRect(x: 0, y: h1*4, width: w/2, height: h1*3))
         //let leftbtn = UIButton(frame:CGRectMake(x1-60, y1-60, 120, 120))
        let leftbtn = UIButton(frame:CGRectMake(perww, perww, perww*3, perww*3))
        leftbtn.frame = CGRectMake(perww, perww, perww*3, perww*3)
        leftbtn.setBackgroundImage(UIImage(named:"xz_si_icon"),forState:.Normal)
        leftbtn.addTarget(self, action: #selector(TabOneViewController.leftbtn(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        var label:UILabel = UILabel(frame:CGRectMake(0, perww*4, w/2, perww))
        label.text = "求帮助"
        label.textColor = UIColor.blackColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(name: "Bobz Type", size: 30)
        customView2.addSubview(label)
        customView2.addSubview(leftbtn)
        self.view.addSubview(customView2)
        
        let customView3 = UIView(frame: CGRect(x: w/2, y: h1*4, width: w/2, height: h1*3))
        // customView3.backgroundColor=UIColor.greenColor()
        let rightbtn = UIButton(frame:CGRectMake(perww, perww,perww*3, perww*3))
        rightbtn.setBackgroundImage(UIImage(named:"xz_yuan_icon"),forState:.Normal)
        rightbtn.addTarget(self, action: #selector(TabOneViewController.rightbtn(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        customView3.addSubview(rightbtn)
        var rightlabel:UILabel = UILabel(frame:CGRectMake(0, perww*4, w/2, perww))
        rightlabel.text = "我能帮"
        rightlabel.textColor = UIColor.blackColor()
        rightlabel.textAlignment = NSTextAlignment.Center
        rightlabel.font = UIFont(name: "Bobz Type", size: 30)
        customView3.addSubview(rightlabel)
        self.view.addSubview(customView3)
        ////////////////////////////////////
        let customView4 = UIView(frame: CGRect(x: 0, y: h1*7, width: w, height: h1*3))
        var w3 = w/6
        var y3 = w/6
        var totalh=h1*3;
        var childh=totalh/7;
        let tel1 = UIButton(frame:CGRectMake(w3-childh, childh, childh*2, childh*2))
        tel1.setBackgroundImage(UIImage(named:"xz_da_icon"),forState:.Normal)
         tel1.addTarget(self, action: "tel1btn:", forControlEvents: UIControlEvents.TouchUpInside)
        customView4.addSubview(tel1)
        var tel1_label:UILabel = UILabel(frame:CGRectMake(0, childh*3, w/3, childh))
        tel1_label.text = "110报警"
        tel1_label.textColor = UIColor.blackColor()
        tel1_label.textAlignment = NSTextAlignment.Center
        //tel1_label.font = UIFont(name: "Bobz Type", size: 10)
        tel1_label.font = UIFont.systemFontOfSize(14)

        customView4.addSubview(tel1_label)
        
        
        
        
        let tel2 = UIButton(frame:CGRectMake(3*w3-childh, childh, childh*2, childh*2))
        tel2.setBackgroundImage(UIImage(named:"xz_ji_icon"),forState:.Normal)
        tel2.addTarget(self, action: "tel2btn:", forControlEvents: UIControlEvents.TouchUpInside)
        customView4.addSubview(tel2)
        var tel2_label:UILabel = UILabel(frame:CGRectMake(2*w3, childh*3, w/3, childh))
        tel2_label.text = "120报警"
        tel2_label.textColor = UIColor.blackColor()
        tel2_label.textAlignment = NSTextAlignment.Center
        //tel2_label.font = UIFont(name: "Bobz Type", size: 10)
        tel2_label.font = UIFont.systemFontOfSize(14)

        customView4.addSubview(tel2_label)
        


        
        //tel3 = UIButton(frame:CGRectMake(5*w3-25, y3-25, 50, 50))
        tel3.frame=CGRectMake(5*w3-childh, childh, childh*2, childh*2)
        tel3.setBackgroundImage(UIImage(named:"xz_ren_icon"),forState:.Normal)
        tel3.addTarget(self, action: "tel3btn:", forControlEvents: UIControlEvents.TouchUpInside)

        customView4.addSubview(tel3)

        
        
        
        tel3_label.frame=CGRectMake(4*w3, childh*3, w/3, childh)
        tel3_label.text = "未设置"
        //tel3_label.attributedText = tel3strMutableString;
        tel3_label.textColor = UIColor.blackColor()
        tel3_label.textAlignment = NSTextAlignment.Center
        tel3_label.font = UIFont.systemFontOfSize(14)
        customView4.addSubview(tel3_label)
        

        
        
        self.view.addSubview(customView4)
        
        
        
        
        let customView5 = UIView(frame: CGRect(x: w/2, y: h1*4, width: 1, height: h1*3))
        customView5.backgroundColor=UIColor(colorLiteralRed: 215/255.0, green: 212/255.0, blue: 212/255.0, alpha: 1)
        self.view.addSubview(customView5)
        
        let customView6 = UIView(frame: CGRect(x: 0, y: h1*7, width: w, height: 1))
        customView6.backgroundColor=UIColor(colorLiteralRed: 215/255.0, green: 212/255.0, blue: 212/255.0, alpha: 1)

        self.view.addSubview(customView6)
        
        let defaults = NSUserDefaults.standardUserDefaults();
        let userid = defaults.objectForKey("userid") as! NSString;
        loaduserinfo(userid as String);
    }
    
    func leftbtn(sender:UIButton)
    {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("publishController") as! PublishViewController
        vc.cat=0;
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func rightbtn(sender:UIButton)
    {
        var vc = ListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tel1btn(sender:UIButton)
    {
        UIApplication.sharedApplication().openURL(NSURL(string :"tel://110")!)
    }
    func tel2btn(sender:UIButton)
    {
        
        UIApplication.sharedApplication().openURL(NSURL(string :"tel://120")!)
    }
    func tel3btn(sender:UIButton)
    {
        
        UIApplication.sharedApplication().openURL(NSURL(string :"tel://"+"\(self.tel3_phonenum)")!)
        
    }
    
//    func loaduser() {
//        let defaults = NSUserDefaults.standardUserDefaults();
//         let _userid = defaults.objectForKey("userid") as! NSString;
//        Alamofire.request(.POST, "http://api.bbxiaoqu.com/login.php", parameters:["_userid" : _userid])
//            .responseJSON { response in
//                if(response.result.isSuccess)
//                {
//                    if let JSON = response.result.value {
//                        print("JSON1: \(JSON.count)")
//                        if(JSON.count>0)
//                        {
//                            
//                                let isrecvmess:String = JSON.objectForKey("isrecvmess") as! String;
//                                let isopenvoice:String = JSON.objectForKey("isopenvoice") as! String;
//                            
//                                
//                                defaults.setObject(isrecvmess, forKey: "openmessflag");
//                                defaults.setObject(isopenvoice, forKey: "openvoiceflag");
//                                defaults.synchronize();
//                                
//                            
//                        }else
//                        {
//                            defaults.setObject("1", forKey: "openmessflag");
//                            defaults.setObject("1", forKey: "openvoiceflag");
//                            defaults.synchronize();
//                        }
//                    }
//                }else
//                {
//                    self.successNotice("网络请求错误")
//                    print("网络请求错误")
//                }
//        }
//    }
    
    
    func loaduserinfo(userid:String)
        
    {
        
        var url_str:String = "http://api.bbxiaoqu.com/getuserinfo.php?userid=".stringByAppendingString(userid)
        
        Alamofire.request(.POST,url_str, parameters:nil)
            
            .responseJSON { response in
                
                //                print(response.request)  // original URL request
                
                //                print(response.response) // URL response
                
                //                print(response.data)     // server data
                
                //                print(response.result)   // result of response serialization
                
                print(response.result.value)
                
                if let JSON = response.result.value {
                    
                    print("JSON1: \(JSON.count)")
                    
                    if(JSON.count>0)
                    {
                        var emergency:String;
                        if(JSON[0].objectForKey("emergencycontact")!.isKindOfClass(NSNull))
                        {
                            emergency="";
                        }else
                        {
                            emergency = JSON[0].objectForKey("emergencycontact") as! String;
                        }
                        var emergencytelphone:String;
                         if(JSON[0].objectForKey("emergencycontacttelphone")!.isKindOfClass(NSNull))
                        {
                            emergencytelphone="";
                        }else
                        {
                            emergencytelphone = JSON[0].objectForKey("emergencycontacttelphone") as! String;
                        }
                        if(emergency.characters.count>0)
                         {
                            self.tel3_label.text=emergency
                         }else
                        {
                             self.tel3_label.text="未设置"
                        }
                        
                        self.tel3_phonenum=emergencytelphone;
                    }
                    
                    
                    
                    
                    
                }
                
        }
        
    }
    
    
    
    
    

    
//     func openxmpp() {
//        zdl().xxmaindl = self
//        zdl().connect()
//    }
//    
    
    override func viewWillDisappear(animated: Bool) {
        print("-2");
    }

    
   override  func viewDidDisappear(animated: Bool)
   {
        print("-1");
    }
    
       

    //获取总代理
    func zdl() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    
   

  
    
    func newMainMsg(aMsg: WXMessage) {
        
        let defaults = NSUserDefaults.standardUserDefaults();
        var openmessflag:String=""
        if(defaults.boolForKey("openmessflag"))
        {
             openmessflag = defaults.objectForKey("openmessflag") as! String;
        }else
        {
            openmessflag="0"
        }
        //var openmessflag:Bool = defaults.objectForKey("openmessflag") as! Bool;
       // var openvoiceflag:Bool = defaults.objectForKey("openvoiceflag") as! Bool;
        var openvoiceflag:String=""
        if(defaults.boolForKey("openvoiceflag"))
        {
            openvoiceflag = defaults.objectForKey("openvoiceflag") as! String;
        }else
        {
            openvoiceflag="0"
        }

        if openmessflag=="1"
        {
            //对方正在输入
            if aMsg.isComposing {
                self.navigationItem.title = "对方正在输入。。。"
            }else if (aMsg.body != "") {
                
//                imageView.value=imageView.value+1
//                if(imageView.value>0)
//                {
//                    imageView.hidden=false
//                }else
//                {
//                    imageView.hidden=true
//                }
                if openvoiceflag=="1"
                {
                    
                    var o:Notice=Notice();
                    o.systemSound()
                    
                }
            }
            }
    }

       

    @IBAction func cansos(sender: UIButton) {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("tabone") as! OneViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func sos(sender: UIButton) {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("publishController") as! PublishViewController
        vc.cat=0;
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    
    @IBAction func top(sender: UIButton) {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("topviewController") as! TopViewController
       
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

    //处理方向变更信息
    func didUpdateUserHeading(userLocation: BMKUserLocation!) {
        if(userLocation.location != nil)
        {
            print("经度: \(userLocation.location.coordinate.latitude)")
            print("纬度: \(userLocation.location.coordinate.longitude)")
            let defaults = NSUserDefaults.standardUserDefaults();
            defaults.setObject(String(userLocation.location.coordinate.latitude), forKey: "lat");
            defaults.setObject(String(userLocation.location.coordinate.longitude), forKey: "lng");
            defaults.synchronize();
            
            
            //locService.stopUserLocationService()
        }else{
            NSLog("userLocation.location is nil")
        }
    }
    
    
    
    //处理位置坐标更新
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
         if(userLocation.location != nil)
         {
            print("经度: \(userLocation.location.coordinate.latitude)")
            print("纬度: \(userLocation.location.coordinate.longitude)")
            
            var defaults = NSUserDefaults.standardUserDefaults();
            defaults.setObject(String(userLocation.location.coordinate.latitude), forKey: "lat");
            defaults.setObject(String(userLocation.location.coordinate.longitude), forKey: "lng");
            
//            defaults.setNilValueForKey("province");//省直辖市
//            defaults.setNilValueForKey("city");//城市
//            defaults.setNilValueForKey("sublocality");//区县
//            defaults.setNilValueForKey("thoroughfare");//街道
//            defaults.setNilValueForKey("address");


            defaults.synchronize();
            
            
            let pt:CLLocationCoordinate2D=CLLocationCoordinate2D(latitude: userLocation.location.coordinate.latitude, longitude: userLocation.location.coordinate.longitude)
            
            var option:BMKReverseGeoCodeOption=BMKReverseGeoCodeOption();
            option.reverseGeoPoint=pt;
            //_search.reverseGeoCode(option)
            
//            let _userid = defaults.objectForKey("userid") as! NSString;
//            let _token = defaults.objectForKey("token") as! NSString;
//            
//            Alamofire.request(.POST, "http://api.bbxiaoqu.com/updatechannelid.php", parameters:["_userId" : _userid,"_channelId":_token])
//                                .responseJSON { response in
//                                    print(response.request)  // original URL request
//                                    print(response.response) // URL response
//                                    print(response.data)     // server data
//                                    print(response.result)   // result of response serialization
//                                    print(response.result.value)
//            
//            
//            }
//            
//            
//            
//            
//            Alamofire.request(.POST, "http://api.bbxiaoqu.com/updatelocation.php", parameters:["_userId" : _userid,"_lat":String(userLocation.location.coordinate.latitude),"_lng":String(userLocation.location.coordinate.longitude),"_os":"ios"])
//                                .responseJSON { response in
//                                    print(response.request)  // original URL request
//                                    print(response.response) // URL response
//                                    print(response.data)     // server data
//                                    print(response.result)   // result of response serialization
//                                    print(response.result.value)
//                                    
//            }
         }else{
            NSLog("userLocation.location is nil")
        }
    }
    
    
    func onGetReverseGeoCodeResult(searcher:BMKGeoCodeSearch, result:BMKReverseGeoCodeResult,  errorCode:BMKSearchErrorCode)
    {
        if(errorCode.rawValue==0)
        {
           
            print("province: \(result.addressDetail.province)")
            print("city: \(result.addressDetail.city)")
            print("district: \(result.addressDetail.district)")
            print("streetName: \(result.addressDetail.streetName)")
            print("streetNumber: \(result.addressDetail.streetNumber)")
            

            
            print("address: \(result.address)")
            let defaults = NSUserDefaults.standardUserDefaults();
            defaults.setObject(result.addressDetail.province, forKey: "province");//省直辖市
            defaults.setObject(result.addressDetail.city , forKey: "city");//城市
            defaults.setObject(result.addressDetail.district , forKey: "sublocality");//区县
            defaults.setObject(result.addressDetail.streetName, forKey: "thoroughfare");//街道
            defaults.setObject(result.address  , forKey: "address");
            defaults.synchronize();

        }else
        {
            let defaults = NSUserDefaults.standardUserDefaults();
            let a:String = "";
            defaults.setObject("", forKey: "province");//省直辖市
            defaults.setObject(a, forKey: "city");//城市
            defaults.setObject(a, forKey: "sublocality");//区县
            defaults.setObject(a, forKey: "thoroughfare");//街道
            defaults.setObject(a, forKey: "address");
            defaults.synchronize();

        }
    }
    

    override func viewWillAppear(animated: Bool) {
           // locService.delegate = self
    }
    
   
   
    
    
  
  
    

    func SetClick()
    {
        NSLog("SetClick")
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("tabfour") as! FourViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func exitClick()
    {
        NSLog("exitClick")
        //exit(0)
        var alertView = UIAlertView()
        alertView.title = "系统提示"
        alertView.message = "您确定要退出吗？"
        alertView.addButtonWithTitle("取消")
        alertView.addButtonWithTitle("确定")
        alertView.cancelButtonIndex=0
        alertView.delegate=self;
        alertView.show()
        
       
    }
    
    
    func alertView(alertView:UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if(buttonIndex==alertView.cancelButtonIndex){
            
        }
        else
        {
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
            //创建导航控制器
            let nvc=UINavigationController(rootViewController:vc);
            //设置根视图
            self.view.window!.rootViewController=nvc;

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
