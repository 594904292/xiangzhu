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
        let w:CGFloat = self.view.frame.width
        let h1:CGFloat = self.view.frame.height/10;
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: w, height: h1*4))
        let imageView=UIImageView(image:UIImage(named:"banner1"))
        imageView.frame=CGRect(x: 0,y: 0,width: w,height: h1*4)
        customView.addSubview(imageView)
        self.view.addSubview(customView)
        ////////////////////////////////////
        
        let perww  = w/2/5
        let customView2 = UIView(frame: CGRect(x: 0, y: h1*4, width: w/2, height: h1*3))
         //let leftbtn = UIButton(frame:CGRectMake(x1-60, y1-60, 120, 120))
        let leftbtn = UIButton(frame:CGRect(x: perww, y: perww, width: perww*3, height: perww*3))
        leftbtn.frame = CGRect(x: perww, y: perww, width: perww*3, height: perww*3)
        leftbtn.setBackgroundImage(UIImage(named:"xz_si_icon"),for:UIControlState())
        leftbtn.addTarget(self, action: #selector(TabOneViewController.leftbtn(_:)), for: UIControlEvents.touchUpInside)
        
        
        let label:UILabel = UILabel(frame:CGRect(x: 0, y: perww*4, width: w/2, height: perww))
        label.text = "求帮助"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Bobz Type", size: 30)
        customView2.addSubview(label)
        customView2.addSubview(leftbtn)
        self.view.addSubview(customView2)
        
        let customView3 = UIView(frame: CGRect(x: w/2, y: h1*4, width: w/2, height: h1*3))
        // customView3.backgroundColor=UIColor.greenColor()
        let rightbtn = UIButton(frame:CGRect(x: perww, y: perww,width: perww*3, height: perww*3))
        rightbtn.setBackgroundImage(UIImage(named:"xz_yuan_icon"),for:UIControlState())
        rightbtn.addTarget(self, action: #selector(TabOneViewController.rightbtn(_:)), for: UIControlEvents.touchUpInside)

        customView3.addSubview(rightbtn)
        let rightlabel:UILabel = UILabel(frame:CGRect(x: 0, y: perww*4, width: w/2, height: perww))
        rightlabel.text = "我能帮"
        rightlabel.textColor = UIColor.black
        rightlabel.textAlignment = NSTextAlignment.center
        rightlabel.font = UIFont(name: "Bobz Type", size: 30)
        customView3.addSubview(rightlabel)
        self.view.addSubview(customView3)
        ////////////////////////////////////
        let customView4 = UIView(frame: CGRect(x: 0, y: h1*7, width: w, height: h1*3))
        let w3 = w/6
        _ = w/6
        let totalh=h1*3;
        let childh=totalh/7;
        let tel1 = UIButton(frame:CGRect(x: w3-childh, y: childh, width: childh*2, height: childh*2))
        tel1.setBackgroundImage(UIImage(named:"xz_da_icon"),for:UIControlState())
         tel1.addTarget(self, action: #selector(TabOneViewController.tel1btn(_:)), for: UIControlEvents.touchUpInside)
        customView4.addSubview(tel1)
        let tel1_label:UILabel = UILabel(frame:CGRect(x: 0, y: childh*3, width: w/3, height: childh))
        tel1_label.text = "110报警"
        tel1_label.textColor = UIColor.black
        tel1_label.textAlignment = NSTextAlignment.center
        //tel1_label.font = UIFont(name: "Bobz Type", size: 10)
        tel1_label.font = UIFont.systemFont(ofSize: 14)

        customView4.addSubview(tel1_label)
        
        
        
        
        let tel2 = UIButton(frame:CGRect(x: 3*w3-childh, y: childh, width: childh*2, height: childh*2))
        tel2.setBackgroundImage(UIImage(named:"xz_ji_icon"),for:UIControlState())
        tel2.addTarget(self, action: #selector(TabOneViewController.tel2btn(_:)), for: UIControlEvents.touchUpInside)
        customView4.addSubview(tel2)
        let tel2_label:UILabel = UILabel(frame:CGRect(x: 2*w3, y: childh*3, width: w/3, height: childh))
        tel2_label.text = "120报警"
        tel2_label.textColor = UIColor.black
        tel2_label.textAlignment = NSTextAlignment.center
        //tel2_label.font = UIFont(name: "Bobz Type", size: 10)
        tel2_label.font = UIFont.systemFont(ofSize: 14)

        customView4.addSubview(tel2_label)
        


        
        //tel3 = UIButton(frame:CGRectMake(5*w3-25, y3-25, 50, 50))
        tel3.frame=CGRect(x: 5*w3-childh, y: childh, width: childh*2, height: childh*2)
        tel3.setBackgroundImage(UIImage(named:"xz_ren_icon"),for:UIControlState())
        tel3.addTarget(self, action: #selector(TabOneViewController.tel3btn(_:)), for: UIControlEvents.touchUpInside)

        customView4.addSubview(tel3)

        
        
        
        tel3_label.frame=CGRect(x: 4*w3, y: childh*3, width: w/3, height: childh)
        tel3_label.text = "未设置"
        //tel3_label.attributedText = tel3strMutableString;
        tel3_label.textColor = UIColor.black
        tel3_label.textAlignment = NSTextAlignment.center
        tel3_label.font = UIFont.systemFont(ofSize: 14)
        customView4.addSubview(tel3_label)
        

        
        
        self.view.addSubview(customView4)
        
        
        
        
        let customView5 = UIView(frame: CGRect(x: w/2, y: h1*4, width: 1, height: h1*3))
        customView5.backgroundColor=UIColor(colorLiteralRed: 215/255.0, green: 212/255.0, blue: 212/255.0, alpha: 1)
        self.view.addSubview(customView5)
        
        let customView6 = UIView(frame: CGRect(x: 0, y: h1*7, width: w, height: 1))
        customView6.backgroundColor=UIColor(colorLiteralRed: 215/255.0, green: 212/255.0, blue: 212/255.0, alpha: 1)

        self.view.addSubview(customView6)
        
        let defaults = UserDefaults.standard;
        let userid = defaults.object(forKey: "userid") as! NSString;
        loaduserinfo(userid as String);
        loadgg();
    }
    
    func leftbtn(_ sender:UIButton)
    {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "publishController") as! PublishViewController
        vc.cat=0;
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func rightbtn(_ sender:UIButton)
    {
        let vc = ListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tel1btn(_ sender:UIButton)
    {
        UIApplication.shared.openURL(URL(string :"tel://110")!)
    }
    func tel2btn(_ sender:UIButton)
    {
        
        UIApplication.shared.openURL(URL(string :"tel://120")!)
    }
    func tel3btn(_ sender:UIButton)
    {
        
        UIApplication.shared.openURL(URL(string :"tel://"+"\(self.tel3_phonenum)")!)
        
    }
    
    func loaduserinfo(_ userid:String)
        
    {
        
        let url_str:String = "http://api.bbxiaoqu.com/getuserinfo.php?userid=" + userid
        Alamofire.request(url_str)
            .responseJSON { response in
                if let JSON:NSArray = response.result.value as! NSArray {
                    print("JSON1: \(JSON.count)")
                    if(JSON.count>0)
                    {
                         let data:NSDictionary = JSON[0] as! NSDictionary;
                        
                        //let aaa = data.object(forKey: "userid")
                        
                        let userid:String = data.value(forKey: "userid") as! String
                         let pass:String = data.value(forKey: "pass") as! String
                        
                        
                        ///let aaaemergency = data.value(forUndefinedKey: "emergencycontact")
                        //let bbbemergency = data.object(forKey: "emergencycontact")
                        
                        let emergency:String = data.value(forKey: "emergencycontact") as! String
                        
                        let emergencytelphone:String = data.value(forKey: "emergencycontacttelphone") as! String
                        

                        
                        
//                        var emergency:String;
//                        if data["emergencycontact"] == nil
//                        {
//                            emergency="";
//                        }else
//                        {
//                            
//                            //print(emergency)
//                            emergency = data.object(forKey: "emergencycontact") as! String;
//                            //emergency = data["emergencycontact"] as! String;
//                            
//                        }
//                        var emergencytelphone:String;
//                        //if(data.object(forKey: "emergencycontacttelphone")==nil)
//                        if data["emergencycontacttelphone"] == nil
//                        {
//                            emergencytelphone="";
//                        }else
//                        {
//                            emergencytelphone = data.object(forKey: "emergencycontacttelphone") as! String;
//                            //emergencytelphone = data["emergencycontacttelphone"]
//                        }
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

    
    func loadgg()
        
    {
        
        let url_str:String = "http://api.bbxiaoqu.com/gonggao.php"
        Alamofire.request(url_str,method:HTTPMethod.post, parameters:nil)
            .responseJSON { response in
                //print(response.result.value)
                if let JSON:NSArray = response.result.value as! NSArray {
                    //print("JSON1: \(JSON.count)")
                    
                    if(JSON.count>0)
                    {
                        let data:NSDictionary=JSON[0] as! NSDictionary
                        var id:String;
                        if(data.object(forKey: "id")==nil)
                        {
                            id="";
                        }else
                        {
                            id = data.object(forKey: "id") as! String;
                        }
                        var title:String;
                         if(data.object(forKey: "title")==nil)
                        {
                            title="";
                        }else
                        {
                            title = data.object(forKey: "title") as! String;
                        }
                        var publishdate:String;
                        if(data.object(forKey: "publishdate")==nil)
                        {
                            publishdate="";
                        }else
                        {
                            publishdate = data.object(forKey: "publishdate") as! String;
                        }
                        
                        
                        let defaults = UserDefaults.standard;
                        defaults.set(id, forKey: "ggid");
                        defaults.set(title, forKey: "ggtitle");
                        defaults.set(publishdate, forKey: "ggdate");
                        defaults.synchronize();

                    }
                }
        }
    }
    
    
    
//     func openxmpp() {
//        zdl().xxmaindl = self
//        zdl().connect()
//    }
//    
    
    override func viewWillDisappear(_ animated: Bool) {
        print("-2");
    }

    
   override  func viewDidDisappear(_ animated: Bool)
   {
        print("-1");
    }
    
       

    //获取总代理
    func zdl() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
   

  
    
    func newMainMsg(_ aMsg: WXMessage) {
        
        let defaults = UserDefaults.standard;
        var openmessflag:String=""
        if(defaults.bool(forKey: "openmessflag"))
        {
             openmessflag = defaults.object(forKey: "openmessflag") as! String;
        }else
        {
            openmessflag="0"
        }
        //var openmessflag:Bool = defaults.objectForKey("openmessflag") as! Bool;
       // var openvoiceflag:Bool = defaults.objectForKey("openvoiceflag") as! Bool;
        var openvoiceflag:String=""
        if(defaults.bool(forKey: "openvoiceflag"))
        {
            openvoiceflag = defaults.object(forKey: "openvoiceflag") as! String;
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
                    
                    let o:Notice=Notice();
                    o.systemSound()
                    
                }
            }
            }
    }

       

    @IBAction func cansos(_ sender: UIButton) {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "tabone") as! OneViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func sos(_ sender: UIButton) {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "publishController") as! PublishViewController
        vc.cat=0;
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    
    @IBAction func top(_ sender: UIButton) {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "topviewController") as! TopViewController
       
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

    //处理方向变更信息
    func didUpdateUserHeading(_ userLocation: BMKUserLocation!) {
        if(userLocation.location != nil)
        {
            print("经度: \(userLocation.location.coordinate.latitude)")
            print("纬度: \(userLocation.location.coordinate.longitude)")
            let defaults = UserDefaults.standard;
            defaults.set(String(userLocation.location.coordinate.latitude), forKey: "lat");
            defaults.set(String(userLocation.location.coordinate.longitude), forKey: "lng");
            defaults.synchronize();
            
            
            //locService.stopUserLocationService()
        }else{
            NSLog("userLocation.location is nil")
        }
    }
    
    
    
    //处理位置坐标更新
    func didUpdateBMKUserLocation(_ userLocation: BMKUserLocation!) {
         if(userLocation.location != nil)
         {
            print("经度: \(userLocation.location.coordinate.latitude)")
            print("纬度: \(userLocation.location.coordinate.longitude)")
            
            let defaults = UserDefaults.standard;
            defaults.set(String(userLocation.location.coordinate.latitude), forKey: "lat");
            defaults.set(String(userLocation.location.coordinate.longitude), forKey: "lng");
            
//            defaults.setNilValueForKey("province");//省直辖市
//            defaults.setNilValueForKey("city");//城市
//            defaults.setNilValueForKey("sublocality");//区县
//            defaults.setNilValueForKey("thoroughfare");//街道
//            defaults.setNilValueForKey("address");


            defaults.synchronize();
            
            
            let pt:CLLocationCoordinate2D=CLLocationCoordinate2D(latitude: userLocation.location.coordinate.latitude, longitude: userLocation.location.coordinate.longitude)
            
            let option:BMKReverseGeoCodeOption=BMKReverseGeoCodeOption();
            option.reverseGeoPoint=pt;
            //_search.reverseGeoCode(option)
            
            let _userid = defaults.object(forKey: "userid") as! NSString;
            let _token = defaults.object(forKey: "token") as! NSString;
            
            Alamofire.request("http://api.bbxiaoqu.com/updatechannelid.php",method:HTTPMethod.post, parameters:["_userId" : _userid,"_channelId":_token])
                                .responseJSON { response in
                                     print(response.result.value)
            }
            

            
            
            Alamofire.request("http://api.bbxiaoqu.com/updatelocation.php", method:HTTPMethod.post, parameters:["_userId" : _userid,"_lat":String(userLocation.location.coordinate.latitude),"_lng":String(userLocation.location.coordinate.longitude),"_os":"ios"])
                                .responseJSON { response in
                                    print(response.result.value)
                                    
            }
         }else{
            NSLog("userLocation.location is nil")
        }
    }
    
    
    func onGetReverseGeoCodeResult(_ searcher:BMKGeoCodeSearch, result:BMKReverseGeoCodeResult,  errorCode:BMKSearchErrorCode)
    {
        if(errorCode.rawValue==0)
        {
           
            print("province: \(result.addressDetail.province)")
            print("city: \(result.addressDetail.city)")
            print("district: \(result.addressDetail.district)")
            print("streetName: \(result.addressDetail.streetName)")
            print("streetNumber: \(result.addressDetail.streetNumber)")
            

            
            print("address: \(result.address)")
            let defaults = UserDefaults.standard;
            defaults.set(result.addressDetail.province, forKey: "province");//省直辖市
            defaults.set(result.addressDetail.city , forKey: "city");//城市
            defaults.set(result.addressDetail.district , forKey: "sublocality");//区县
            defaults.set(result.addressDetail.streetName, forKey: "thoroughfare");//街道
            defaults.set(result.address  , forKey: "address");
            defaults.synchronize();

        }else
        {
            let defaults = UserDefaults.standard;
            let a:String = "";
            defaults.set("", forKey: "province");//省直辖市
            defaults.set(a, forKey: "city");//城市
            defaults.set(a, forKey: "sublocality");//区县
            defaults.set(a, forKey: "thoroughfare");//街道
            defaults.set(a, forKey: "address");
            defaults.synchronize();

        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
           // locService.delegate = self
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
