//

//  RootTabBarController.swift

//  bbm

//

//  Created by songgc on 16/8/5.

//  Copyright © 2016年 sprin. All rights reserved.

//



import UIKit
import Alamofire
class RootTabBarController: UITabBarController,UINavigationControllerDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate ,XxMainDL{
    
    var titles=["首页","会话","襄助榜","我的"]
    var seltabIndex:Int = 0;
    var newmessnum:Int = 0;
    var contentView:UIView!
    var locService:BMKLocationService!
    var _search:BMKGeoCodeSearch!
    var baritem:UITabBarItem! ;
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor=UIColor.white
        self.navigationItem.title="襄助"
        self.creatSubViewControllers()
        self.tabBar.tintColor=UIColor.red
        let navBar=UINavigationBar.appearance()
        navBar.barTintColor=UIColor(red: 204/255, green: 0, blue: 0, alpha: 1)
        var arrs=[String:AnyObject]();
        arrs[NSForegroundColorAttributeName]=UIColor.white
        navBar.titleTextAttributes=arrs
        //self.navigationController?.navigationBar.tintColor=UIColor.redColor()
        if(seltabIndex == 0)
        {
            let img=UIImage(named: "xz_laba_icon")
            let item3=UIBarButtonItem(image: img, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(RootTabBarController.jumpchatlist))
            item3.tintColor=UIColor.white
            self.navigationItem.leftBarButtonItem=item3
            
        }else
        {
            let returnimg=UIImage(named: "xz_nav_return_icon")
            let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(RootTabBarController.backClick))
            item3.tintColor=UIColor.white
            self.navigationItem.leftBarButtonItem=item3
            
        }
        let searchimg=UIImage(named: "xz_nav_icon_search")
        let item4=UIBarButtonItem(image: searchimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(RootTabBarController.searchClick))
        item4.tintColor=UIColor.white
        self.navigationItem.rightBarButtonItem=item4
        
        // 设置定位精确度，默认：kCLLocationAccuracyBest
        BMKLocationService.setLocationDesiredAccuracy(kCLLocationAccuracyBest)
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        BMKLocationService.setLocationDistanceFilter(10)
        
        //初始化BMKLocationService
        locService = BMKLocationService()
        locService.delegate = self
        //启动LocationService
        locService.startUserLocationService()
        
        _search=BMKGeoCodeSearch()
        _search.delegate=self
        self.view.isUserInteractionEnabled=true
        self.automaticallyAdjustsScrollViewInsets = false
        openxmpp() //开启xmpp
        
        baritem = self.tabBar.items![1] as UITabBarItem;
        //baritem.badgeValue="1"

    }
    
    
    func openxmpp() {
        zdl().xxmaindl = self
        let isconnect:Bool=zdl().connect()
        NSLog("isconnect:\(isconnect)");

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
            
            newmessnum=newmessnum+1;
            if(newmessnum>0)
            {
                baritem.badgeValue = String(newmessnum)
            }
            if openvoiceflag=="1"
            {
                let o:Notice=Notice();
                o.systemSound()
            }
        }
    }


  
    func searchClick()
    {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "souviewcontroller") as! SouViewController
        self.navigationController?.pushViewController(vc, animated: true)
        //var vc = SearchViewController()
        //self.navigationController?.pushViewController(vc, animated: true)
    }

    func backClick()
    {
        NSLog("back");
        self.selectedIndex = 0;
        NSLog("%i is the tabbar item",self.selectedIndex);
//        let root  = RootTabBarController()
//        let nvc=UINavigationController(rootViewController:root);
//        //设置根视图
//        self.view.window!.rootViewController=nvc;
    }
    
    func jumpchatlist()
    {
        
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "noticeviewcontroller") as! NoticeTableViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
         // Dispose of any resources that can be recreated.
     }
    
    
    
    
    
    // UITabBarDelegate协议的方法，在用户选择不同的标签页时调用
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //通过tag查询到上方容器的label，并设置为当前选择的标签页的名称
        NSLog("Selected is %d",item.tag);
        self.navigationItem.title=titles[item.tag]
      
        seltabIndex = item.tag
        if(seltabIndex == 0)
        {
            let img=UIImage(named: "xz_laba_icon")
            let item3=UIBarButtonItem(image: img, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(RootTabBarController.jumpchatlist))
            item3.tintColor=UIColor.white
            self.navigationItem.leftBarButtonItem=item3
        }else
        {
            let returnimg=UIImage(named: "xz_nav_return_icon")
            let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(RootTabBarController.backClick))
            item3.tintColor=UIColor.white
            self.navigationItem.leftBarButtonItem=item3
            if(seltabIndex == 1)
            {
                baritem.badgeValue=nil
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
    
    
    
    
    
    func creatSubViewControllers(){
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let TabOne = sb.instantiateViewController(withIdentifier: "mainController") as! TabOneViewController
        let TabTwo = sb.instantiateViewController(withIdentifier: "newrecentviewcontroller") as! RecentViewController
        let TabThree = sb.instantiateViewController(withIdentifier: "topviewController") as! TopViewController
         let TabFour = sb.instantiateViewController(withIdentifier: "mybaseinfoviewcontroller") as! MybaseInfoViewController

        
        let tabArray = [TabOne,TabTwo,TabThree,TabFour]
        var images_sel = ["xz_fang_icon_sel","xz_huihua_icon_sel","xz_lei_icon_sel","xz_wo_icon_sel"]
        var images = ["xz_fang_icon","xz_hua_icon","xz_lei_icon","xz_wo_icon"]
        for  index in 0...3{
            let item : UITabBarItem = UITabBarItem (title: titles[index], image: UIImage(named: images[index]), selectedImage: UIImage(named: images_sel[index]))
            item.tag=index
            tabArray[index].tabBarItem = item;
        }
        self.viewControllers = tabArray
    }
    
    
    //处理位置坐标更新
    
    func didUpdate(_ userLocation: BMKUserLocation!) {
        
        if(userLocation.location != nil)
            
        {
            print("经度: \(userLocation.location.coordinate.latitude)")
            print("纬度: \(userLocation.location.coordinate.longitude)")
            let defaults = UserDefaults.standard;
            defaults.set(String(userLocation.location.coordinate.latitude), forKey: "lat");
            defaults.set(String(userLocation.location.coordinate.longitude), forKey: "lng");
            defaults.synchronize();
            
            let pt:CLLocationCoordinate2D=CLLocationCoordinate2D(latitude: userLocation.location.coordinate.latitude, longitude: userLocation.location.coordinate.longitude)
            
            let option:BMKReverseGeoCodeOption=BMKReverseGeoCodeOption();
            option.reverseGeoPoint=pt;
            _search.reverseGeoCode(option)
            locService.stopUserLocationService()
            let _userid = defaults.object(forKey: "userid") as! NSString;
            if(defaults.object(forKey: "token") != nil)
            {
                
                let _token = defaults.object(forKey: "token") as! NSString;
                Alamofire.request("http://api.bbxiaoqu.com/updatechannelid.php", method:HTTPMethod.post,parameters:["_userId" : _userid,"_channelId":_token])
                    
                    .responseJSON { response in
                           print(response.result)   // result of response serialization
                  }
                
                
                
                Alamofire.request("http://api.bbxiaoqu.com/updatelocation.php", method:HTTPMethod.post,parameters:["_userId" : _userid,"_lat":String(userLocation.location.coordinate.latitude),"_lng":String(userLocation.location.coordinate.longitude),"_os":"ios"])
                    .responseJSON { response in
                        
                         print(response.result)   // result of response serialization
                        
                        
                        
                }
                
            }
            
        }else{
            
            NSLog("userLocation.location is nil")
            
        }
        
    }
    
    
    
    var province:String="";
     var city:String="";
     var district:String="";
     var streetName:String="";
    
    func onGetReverseGeoCodeResult(_ searcher:BMKGeoCodeSearch, result:BMKReverseGeoCodeResult,  errorCode:BMKSearchErrorCode)
        
    {
        
        if(errorCode.rawValue==0)
            
        {
            print("province: \(result.addressDetail.province)")
            print("city: \(result.addressDetail.city)")
            print("district: \(result.addressDetail.district)")
            print("streetName: \(result.addressDetail.streetName)")
            print("streetNumber: \(result.addressDetail.streetNumber)")
            province=result.addressDetail.province;
            city=result.addressDetail.city;
            district=result.addressDetail.district;
            streetName=result.addressDetail.streetName;
            print("address: \(result.address)")
            let defaults = UserDefaults.standard;
            defaults.set(result.addressDetail.province, forKey: "province");//省直辖市
            defaults.set(result.addressDetail.city , forKey: "city");//城市
            defaults.set(result.addressDetail.district , forKey: "sublocality");//区县
            defaults.set(result.addressDetail.streetName, forKey: "thoroughfare");//街道
            defaults.set(result.addressDetail.streetName, forKey: "street");//街道

            defaults.set(result.address  , forKey: "address");
            defaults.synchronize();
            
            //求距离求小区

            loaduservisiblerange();
            //求距离求小区
            loaduservisiblexiaoqu();
            //self.loaduservisiblexiaoqu();
            
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
    func loaduservisiblerange()
    {
        
        Alamofire.request( "http://api.bbxiaoqu.com/getuservisiblerange.php", method:HTTPMethod.post,parameters:["country" : "中国","province":province,"city":city,"district":district,"street":streetName])
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                    if let tempdata = response.result.value {
                       
                        let JSON:NSDictionary = tempdata as! NSDictionary;
                        print("JSON1: \(JSON.count)")
                        if(JSON.count>0)
                        {
                            let rang:NSNumber = JSON.object(forKey: "rang") as! NSNumber;
                            let defaults = UserDefaults.standard;
                            let formatter = NumberFormatter ( )
                            let rangstr=formatter.string(from: rang);

                            defaults.set(rangstr, forKey: "rang");//省直辖市
                            defaults.synchronize();


                        }
                    }else
                    {
                        let defaults = UserDefaults.standard;
                        defaults.set("4", forKey: "rang");//省直辖市
                        defaults.synchronize();
                    }
                }else
                {
                    let defaults = UserDefaults.standard;
                    defaults.set("4", forKey: "rang");//省直辖市
                    defaults.synchronize();

                }
                
        }
     }

    
    
    func loaduservisiblexiaoqu()
        
    {
        
        let defaults = UserDefaults.standard;
        
        let _userid = defaults.object(forKey: "userid") as! NSString;
        
        Alamofire.request( "http://api.bbxiaoqu.com/getuservisiblecommunity.php", method:HTTPMethod.post,parameters:["userid" :_userid])
            
            .responseJSON { response in
                if(response.result.isSuccess)
                    
                {
                    
                    if let tempdata = response.result.value {
                        
                        let JSON:NSDictionary = tempdata as! NSDictionary;
                        print("JSON1: \((JSON as AnyObject).count)")
                        if((JSON as NSDictionary).count>0)
                        {
                            let community:String = (JSON as NSDictionary).object(forKey: "community") as! String;
                            let community_id:String = (JSON as NSDictionary).object(forKey: "community_id") as! String;
                            let defaults = UserDefaults.standard;
                            defaults.set(community, forKey: "community");//省直辖市
                            defaults.set(community_id, forKey: "community_id");//省直辖市
                            defaults.synchronize();
                        }
                        
                    }
                    
                    
                    
                }
        }
        
                
        }
        

    

}

