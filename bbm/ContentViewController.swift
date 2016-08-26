//
//  ContentViewController.swift
//  bbm
//
//  Created by ericsong on 15/10/10.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire

class ContentViewController: UIViewController,UINavigationControllerDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate ,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate{
    var alertView:UIAlertView?
     var txtMsg:UITextField!
    var sendView:UIView!;

    @IBOutlet weak var headimgview: UIImageView!
    @IBOutlet weak var senduser_label: UILabel!
    @IBOutlet weak var sendtime: UILabel!
    @IBOutlet weak var sendaddr: UILabel!
    @IBOutlet var scrollview: UIScrollView!

    var infoid:String = "";
    var guid:String = "";
    var puserid:String=""
    var puser:String=""
    
    var senduserid:String=""
    var senduser:String=""
    var headface:String=""
    var isjb:Bool = false;
    
  
   
   
    var timer:NSTimer!
    var picnum:Int = 0
    var photoArr:[String] = []
    var items:[itempl]=[]
    var pics:[String]=[]
    
    var issolution:Bool=false;//是否解决
    var solutionid:String="0"//解决ID

    
    
    var locService:BMKLocationService!
    var _search:BMKGeoCodeSearch!
    
    @IBOutlet weak var infostatus: UIImageView!
    @IBOutlet weak var headview: UIView!
    @IBOutlet weak var content_view: UIView!
    @IBOutlet weak var content_end_view: UIView!
    var activityIndicatorView: UIActivityIndicatorView!
    //举报
    @IBOutlet weak var inforeport_btn: UIButton!
    @IBAction func inforeportaction(sender: UIButton) {
        
        
        
        
        if(self.inforeport_btn.titleLabel?.text! == "举报")
        {
            var actionSheet=UIActionSheet()
            actionSheet.title = "请选择举报类型"
            actionSheet.addButtonWithTitle("取消")
            actionSheet.addButtonWithTitle("广告")
            actionSheet.addButtonWithTitle("政治")
            actionSheet.addButtonWithTitle("暴恐")
            actionSheet.addButtonWithTitle("淫秽")
            actionSheet.addButtonWithTitle("赌博")
            actionSheet.addButtonWithTitle("诈骗")
            actionSheet.addButtonWithTitle("其它")
            actionSheet.cancelButtonIndex=0
            actionSheet.delegate=self
            actionSheet.showInView(self.view);
        }else if(self.inforeport_btn.titleLabel?.text! == "取消")
        {
            let defaults = NSUserDefaults.standardUserDefaults();
            var senduseridstr = defaults.objectForKey("userid") as! String;
            let  dics:Dictionary<String,String> = ["_tsuid" : self.puserid,"_uid" : senduseridstr,"_infoid" : self.infoid,"_guid" : self.guid,"_tsreason" : "","_action" : "remove"]
            var url_str:String = "http://api.bbxiaoqu.com/addusertsinfo.php";
            Alamofire.request(.POST,url_str, parameters:dics)
                .responseString{ response in
                    if(response.result.isSuccess)
                    {
                        self.inforeport_btn.setTitle("举报", forState: UIControlState.Normal)
                    }
            }
            
        }
    }

    //评价
    @IBOutlet weak var evaluate_btn: UIButton!
    @IBAction func evaluateacton(sender: UIButton) {
        let defaults = NSUserDefaults.standardUserDefaults();
        senduserid = defaults.objectForKey("userid") as! String;
        let sb = UIStoryboard(name:"Main", bundle: nil)

        if(puserid==senduserid)
        {
            let vc = sb.instantiateViewControllerWithIdentifier("bmuserviewcontroller") as! BmUserViewController
            //创建导航控制器
            vc.guid=self.guid;
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
    
    
    //收藏
    @IBOutlet weak var gzbtn: UIButton!
    @IBAction func gzbtnaction(sender: UIButton) {
        print("gzbtnaction")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            if(self.gzbtn.titleLabel?.text == "收藏")
            {
                let sqlitehelpInstance1=sqlitehelp.shareInstance()
                
                let defaults = NSUserDefaults.standardUserDefaults();
                var userid = defaults.objectForKey("userid") as! String;
                sqlitehelpInstance1.addgz(self.guid, userid: userid)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.gzbtn.setTitle("取消", forState: UIControlState.Normal)
                    //self.gzbtn.imageView?.image=UIImage(named: "xz_aixin_icon_sel")
                    self.gzbtn.setImage(UIImage(named: "xz_aixin_icon_sel"), forState: UIControlState.Normal)
                    self.successNotice("收藏成功")
                })
            }else if(self.gzbtn.titleLabel?.text == "取消")
            {
                
                let sqlitehelpInstance1=sqlitehelp.shareInstance()
                
                let defaults = NSUserDefaults.standardUserDefaults();
                let userid = defaults.objectForKey("userid") as! String;
                sqlitehelpInstance1.removegz(self.guid, userid: userid)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.gzbtn.setTitle("收藏", forState: UIControlState.Normal)
                    //self.gzbtn.imageView?.image=UIImage(named: "xz_aixin_icon")
                    self.gzbtn.setImage(UIImage(named: "xz_aixin_icon"), forState: UIControlState.Normal)
                    self.successNotice("取消收藏成功")
                })
            }
        }
    }
    //交流处理
    @IBOutlet weak var rl_bottom: UIView!
    @IBOutlet weak var chat_btn: UIButton!
    @IBAction func dohelp(sender: UIButton) {
        var actionSheet=UIActionSheet()
        actionSheet.title = "请选择举报类型"
        actionSheet.addButtonWithTitle("取消")
        actionSheet.addButtonWithTitle("在线聊天")
        actionSheet.addButtonWithTitle("文字评论")
        actionSheet.cancelButtonIndex=0
        actionSheet.delegate=self
        actionSheet.showInView(self.view);

    }

    @IBOutlet weak var _tableview: UITableView!
    @IBAction func runchat(sender: UIButton) {
        let defaults = NSUserDefaults.standardUserDefaults();
        senduserid = defaults.objectForKey("userid") as! String;
        let sb = UIStoryboard(name:"Main", bundle: nil)
        if(puserid==senduserid)
        {
            let vc = sb.instantiateViewControllerWithIdentifier("bmuserviewcontroller") as! BmUserViewController
            //创建导航控制器
            vc.guid=self.guid;
            self.navigationController?.pushViewController(vc, animated: true)
        }else
        {
            //做了一次报名动作
            self.savebmThread();

            
            let defaults = NSUserDefaults.standardUserDefaults();
            let myuserid = defaults.objectForKey("userid") as! String;
            
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("chatviewController") as! ChatViewController
            vc.from=puserid
            vc.myself=myuserid;
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
                        print("点击了："+actionSheet.buttonTitleAtIndex(buttonIndex)!)
        var tag:String = actionSheet.buttonTitleAtIndex(buttonIndex)!
       if(tag == "在线聊天")
       {
            let defaults = NSUserDefaults.standardUserDefaults();
            var userid = defaults.objectForKey("userid") as! String;
            if(self.puserid==userid)
            {
                self.successNotice("请选择与其它人聊天")
            }else
            {
                //做了一次报名动作
                self.savebmThread();
                self.AddInfoHelpUserThread();
                let defaults = NSUserDefaults.standardUserDefaults();
                let myuserid = defaults.objectForKey("userid") as! String;
                let sb = UIStoryboard(name:"Main", bundle: nil)
                let vc = sb.instantiateViewControllerWithIdentifier("chatviewController") as! ChatViewController
                vc.from=puserid
                vc.myself=myuserid;
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if(tag == "文字评论")
        {
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("discuzzviewcontroller") as! DiscuzzViewController
            //创建导航控制器
            vc.guid=self.guid;
            self.navigationController?.pushViewController(vc, animated: true)


        }else
        {//举报
            
            if(self.inforeport_btn.titleLabel?.text! == "举报")
            {
                if(tag != "取消")
                {
                    let defaults = NSUserDefaults.standardUserDefaults();
                    var senduseridstr = defaults.objectForKey("userid") as! String;
                    let  dics:Dictionary<String,String> = ["_tsuid" : self.puserid,"_uid" : senduseridstr,"_infoid" : self.infoid,"_guid" : self.guid,"_tsreason" : tag,"_action" : "add"]
                    var url_str:String = "http://api.bbxiaoqu.com/addusertsinfo.php";
                    Alamofire.request(.POST,url_str, parameters:dics)
                        .responseString{ response in
                            if(response.result.isSuccess)
                            {
                                self.inforeport_btn.setTitle("取消", forState: UIControlState.Normal)
                            }
                    }
                }
            }else if(self.inforeport_btn.titleLabel?.text! == "取消")
            {
                let defaults = NSUserDefaults.standardUserDefaults();
                var senduseridstr = defaults.objectForKey("userid") as! String;
                let  dics:Dictionary<String,String> = ["_tsuid" : self.puserid,"_uid" : senduseridstr,"_infoid" : self.infoid,"_guid" : self.guid,"_tsreason" : tag,"_action" : "remove"]
                var url_str:String = "http://api.bbxiaoqu.com/addusertsinfo.php";
                Alamofire.request(.POST,url_str, parameters:dics)
                    .responseString{ response in
                        if(response.result.isSuccess)
                        {
                            self.inforeport_btn.setTitle("举报", forState: UIControlState.Normal)
                        }
                }
                
            }

        }
    
        
    }
    func searchClick()
    {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("souviewcontroller") as! SouViewController
        self.navigationController?.pushViewController(vc, animated: true)
        //var vc = SearchViewController()
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
   
        super.viewDidLoad()
        self.navigationItem.title="查看"
        var returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.Plain, target: self,  action: "backClick")
        
        item3.tintColor=UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem=item3
        
        
        
        
        var searchimg=UIImage(named: "xz_nav_icon_search")
        
        let item4=UIBarButtonItem(image: searchimg, style: UIBarButtonItemStyle.Plain, target: self,  action: "searchClick")
        
        item4.tintColor=UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem=item4        
        _tableview!.delegate=self
        _tableview!.dataSource=self
        
        _tableview.estimatedRowHeight = 250
        //setSeparatorInset:UIEdgeInsetsMake
        _tableview.rowHeight = UITableViewAutomaticDimension

        
        
        self.headimgview!.userInteractionEnabled = true
        self.headimgview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ContentViewController.showuser)))
 
  
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
        //addline();//内容上方细线
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        
        activityIndicatorView.frame = CGRectMake(self.view.frame.size.width/2 - 50, 250, 100, 100)
        
        
        
        activityIndicatorView.hidesWhenStopped = true
        
        activityIndicatorView.color = UIColor.blackColor()
        
        self.view.addSubview(activityIndicatorView)

        //加载用户细线
        if(guid.characters.count>0)
        {
            loadinfo("guid",id: guid);
        }else
        {
            loadinfo("infoid",id: infoid);
        }
        


        

  }
    
    
    override func viewDidLayoutSubviews() {
    
        let w:CGFloat = UIScreen.mainScreen().bounds.width
        
        content_view.frame=CGRectMake(0,130,CGFloat(w),content_view_hight)

        content_end_view.frame=CGRectMake(0,130+content_view_hight,CGFloat(w),30)
        
        let th = self.view.frame.size.height-(130+content_view_hight+30);
        
        _tableview.frame=CGRectMake(0,130+content_view_hight+30,CGFloat(w),th)
        
        headimgview.layer.cornerRadius = headimgview.frame.width / 2
        
        // image还需要加上这一句, 不然无效
        
        headimgview.layer.masksToBounds = true
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
         activityIndicatorView.startAnimating()
        Alamofire.request(.GET,url_str, parameters:nil)
            .responseJSON {response in
                self.activityIndicatorView.stopAnimating()
                if(response.result.isSuccess)
                {
                    print(response.result.value)
                    
                    if let JSON = response.result.value {
                        print("JSON1: \(JSON.count)")
                        if(JSON.count==0)
                        {
                            
                        }else
                        {
                            self.infoid = JSON[0].objectForKey("id") as! String;
                            let title:String = JSON[0].objectForKey("title") as! String;
                            let contentstr:String = JSON[0].objectForKey("content") as! String;
                            self.photo = JSON[0].objectForKey("photo") as! String;
                            let sendtimestr:String = JSON[0].objectForKey("sendtime") as! String;
                            let sendaddress = JSON[0].objectForKey("address") as! String
                            let status = JSON[0].objectForKey("status") as! String

                            
                            let infocatagroy:String = JSON[0].objectForKey("infocatagroy") as! String;
                            self.headface = JSON[0].objectForKey("headface") as! String
                            self.puserid = JSON[0].objectForKey("senduser") as! String;
                            self.puser = JSON[0].objectForKey("username") as! String;
                            
                            var report = JSON[0].objectForKey("report") as! String;
                            if(JSON[0].objectForKey("issolution") as! String == "1")
                            {
                                self.issolution=true
                            }else
                            {
                                self.issolution=false
                            }
                            self.solutionid = JSON[0].objectForKey("solutionid") as! String;
                            //处理后边数据
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.senduser_label.text=self.puser
                                self.sendtime.text = sendtimestr;
                                self.sendaddr.text = sendaddress;
                            
                                self.addcontent(contentstr);
                                self.addimgviewpic(self.photo);
                                
                                
                                //判断是不是本人
                                let defaults = NSUserDefaults.standardUserDefaults();
                                var userid = defaults.objectForKey("userid") as! String;
                                if(self.puserid==userid)
                                {
                                    //不能举报
                                    self.inforeport_btn.hidden=true
                                    //不能收藏
                                    self.gzbtn.hidden=true
                                    //可以评价
                                    self.evaluate_btn.hidden=false
                                    //可以评论
                                    self.rl_bottom.hidden=false
                                    
                                }else
                                {
                                    //能举报
                                    self.inforeport_btn.hidden=false
                                    //能收藏
                                    self.gzbtn.hidden=false
                                    //不可以评价
                                     self.evaluate_btn.hidden=true
                                    //可以评论
                                    self.rl_bottom.hidden=false
                                    
                                    
                                    let sqlitehelpInstance1=sqlitehelp.shareInstance()
                                    
                                    let defaults = NSUserDefaults.standardUserDefaults();
                                    var userid = defaults.objectForKey("userid") as! String;
                                    var ishavezhan:Bool = sqlitehelpInstance1.isexitgz(self.infoid, userid: userid)
                                    if ishavezhan
                                    {
                                        self.gzbtn.titleLabel!.text="取消"
                                        self.gzbtn.setImage(UIImage(named: "xz_aixin_icon_sel"), forState: UIControlState.Normal)
                                        
                                    }else
                                    {
                                        self.gzbtn.titleLabel!.text="收藏"
                                        self.gzbtn.setImage(UIImage(named: "xz_aixin_icon"), forState: UIControlState.Normal)
                                    }
                                    var ishavets:Bool = sqlitehelpInstance1.isexitts(self.infoid, userid: userid)
                                    if ishavezhan
                                    {
                                        self.inforeport_btn.titleLabel!.text="取消"
                                     }else
                                    {
                                        self.inforeport_btn.titleLabel!.text="举报"
                                    }

                                    
                                }
                                if(status=="2")
                                {
                                    
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.evaluate_btn.setTitle("查看帮助我的人", forState: UIControlState.Normal)
                                    //self.evaluate_btn.titleLabel?.text="查看帮助我的人"
                                    
                                    self.issolution=true
                                    self.infostatus.image=UIImage(named: "xz_yijiejue_icon")
                                        });
                                }else
                                {
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in

                                    self.issolution=false
                                    self.infostatus.image=UIImage(named: "xz_qiuzhu_icon")

                                      });
                                }

                                
                                if(report=="1")
                                {
                                    self.isjb=true
                                    //self.reportbtn.hidden=false
                                    //self.reportbtn.setTitle("已举报", forState: UIControlState.Normal)
                                    //self.reportbtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                                }
                            })
                        }
                        
                        
                        
                        
                        //
                        var sqlitehelpInstance1=sqlitehelp.shareInstance()
                        let defaults = NSUserDefaults.standardUserDefaults();
                        var userid = defaults.objectForKey("userid") as! String;
                        if(sqlitehelpInstance1.isexitgz(self.guid, userid: userid))
                        {
                            self.gzbtn.titleLabel?.text="取消"

                        }else
                        {
                             self.gzbtn.titleLabel?.text="收藏"
                        }
                        
                        self.loadheadface(self.puserid,headname:self.headface)
                        self.loaddiscuzzBody(self.infoid)
                        //
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }        
    }
    
    func addline()
    {
        var w:CGFloat = UIScreen.mainScreen().bounds.width-20

        let posy=CGFloat(130);
        let customView = UIView(frame: CGRect(x: 10, y: posy, width:w, height: CGFloat(1)))
        customView.backgroundColor=UIColor.grayColor()
        self.view.addSubview(customView)
    }
    var imgView:UIView=UIView();
    func addimgview()
    {
        
        
    }
    
    //添加内容
    var contenthight:CGFloat=0.0;
    var content_view_hight:CGFloat=0.0;
    func addcontent(contentstr:String)
    {
        var content = UILabel.init()
        content.text = contentstr
         content.font = UIFont.systemFontOfSize(14)
        let options:NSStringDrawingOptions = .UsesLineFragmentOrigin
        let boundingRect = contentstr.boundingRectWithSize(CGSizeMake(200, 0), options: options, attributes:[NSFontAttributeName:UIFont(name: "Heiti SC", size: 14.0)!], context: nil)
        contenthight=boundingRect.height
        content.frame = CGRectMake(10, 0, UIScreen.mainScreen().applicationFrame.width-20, boundingRect.height)
        content.numberOfLines = 0;
        content.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.content_view.addSubview(content)
    
    }
 
    func addimgviewpic(photo:String)
    {
        self.photoArr = photo.characters.split{$0 == ","}.map{String($0)}
        self.picnum=self.photoArr.count
        var w:CGFloat = UIScreen.mainScreen().bounds.width-20
        content_view_hight=contenthight+CGFloat(w/4)
        if(self.picnum>0)
        {
            
            imgView = UIView(frame: CGRect(x: 10, y: contenthight, width:w, height: CGFloat(w/4)))
            self.content_view.addSubview(imgView)
            let bw:CGFloat = UIScreen.mainScreen().bounds.width-20
            var index=0
            if(self.picnum>4)
            {
                self.picnum=4
            }
            let count = 4;
            for(var j:Int=0;j<self.picnum;j++)
            {
                let imageView:UIImageView = UIImageView();
                let sw=bw/4;
                var x:CGFloat = sw * CGFloat(j);
                imageView.frame=CGRectMake(x+5, 5, sw-10, sw-10);
                imageView.tag=j
                let picname:String = self.photoArr[j]
                var imgurl = "http://api.bbxiaoqu.com/uploads/".stringByAppendingString(picname)
                
                
                self.pics.append(imgurl)

                
                let nsd = NSData(contentsOfURL:NSURL(string: imgurl)!)
                //var img = UIImage(data: nsd!,scale:1.5);  //在这里对图片显示进行比例缩放
                imageView.image=UIImage(data: nsd!);
                imageView.userInteractionEnabled=true
                
                imageView.tag = j
                
                //点击事件
                
                let touch = UITapGestureRecognizer.init(target: self, action: "tapimg:")
                

                
                imageView.addGestureRecognizer(touch)
                //添加边框
                var layer:CALayer = imageView.layer
                layer.borderColor=UIColor.lightGrayColor().CGColor
                layer.opacity=1
                layer.borderWidth = 1.0;
                self.imgView.addSubview(imageView);
            }
        }
      
    }

    func tapimg(recognizer:UITapGestureRecognizer)
    {
        let imgView:UIView = recognizer.view!;
        let tapTag:NSInteger = imgView.tag;
        
        
        let url:String=self.pics[tapTag]
        
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("picviewController") as! PicViewController
        //创建导航控制器
        vc.url = url
        vc.pics = self.pics;
        self.navigationController?.pushViewController(vc, animated: true)
        

        
        
        print(tapTag)

    }

    
    override func viewWillDisappear(animated: Bool) {
        
        _search.delegate=nil
        locService.delegate=self


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
            _search.reverseGeoCode(option)
           locService.stopUserLocationService()
            let _userid = defaults.objectForKey("userid") as! NSString;
          
            if(defaults.objectForKey("token") != nil)
            {
            
            let _token = defaults.objectForKey("token") as! NSString;
            
            Alamofire.request(.POST, "http://api.bbxiaoqu.com/updatechannelid.php", parameters:["_userId" : _userid,"_channelId":_token])
                .responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    print(response.result.value)
                    
                    
            }
            
            
            
            
            Alamofire.request(.POST, "http://api.bbxiaoqu.com/updatelocation.php", parameters:["_userId" : _userid,"_lat":String(userLocation.location.coordinate.latitude),"_lng":String(userLocation.location.coordinate.longitude),"_os":"ios"])
                .responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    print(response.result.value)
                    
            }
            }
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
        //_search.delegate=nil
    }

    
    func showuser()
    {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("userinfoviewcontroller") as! UserInfoViewController
        //创建导航控制器
        vc.userid=self.puserid;
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
  

    func loadheadface(userid:String,headname:String)
    {
        if(headname.characters.count>0)
        {
        var myhead:String="http://api.bbxiaoqu.com/uploads/".stringByAppendingString(headface)
        Alamofire.request(.GET, myhead).response { (_, _, data, _) -> Void in
            if let d = data as? NSData!
            {
                self.headimgview?.image=UIImage(data: d)
                self.headimgview.layer.cornerRadius = 5.0
                self.headimgview.layer.masksToBounds = true
            }
        }
        }else
        {
            self.headimgview?.image=UIImage(named: "logo")
            self.headimgview.layer.cornerRadius = 5.0
            self.headimgview.layer.masksToBounds = true
        }
        
    }
    

    
        func loaddiscuzzBody(infoid:String)
        {
            let url_str:String = "http://api.bbxiaoqu.com/getdiscuzz.php?infoid=".stringByAppendingString(infoid)
            Alamofire.request(.GET,url_str, parameters:nil)
                .responseJSON { response in
                     if(response.result.isSuccess)
                    {
                    if let JSON = response.result.value as? NSArray {
                        print("JSON1: \(JSON.count)")
                        if(JSON.count>0)
                        {
                            for data in JSON{
                                let id:String = data.objectForKey("id") as! String;
                                let headface:String = data.objectForKey("headface") as! String;
                                let sendtime:String = data.objectForKey("sendtime") as! String;
                                let message:String = data.objectForKey("message") as! String;
                                let uid:String = data.objectForKey("senduserid") as! String;
                                let username:String = data.objectForKey("senduser") as! String;
                                let item_obj:itempl = itempl(id: id, userid: uid, username: username, headafce: headface, actiontime: sendtime, content: message)
                                  self.items.append(item_obj)
                            }
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                if(self.items.count==0)
                                {
                                    self._tableview.hidden=true
                                }else
                                {
                                    self._tableview.hidden=false
                                self._tableview.reloadData();
                                self._tableview.doneRefresh();
                                }
                            })
    
                        }
                          self._tableview.reloadData();
                    }
            }else
            {
                self.successNotice("网络请求错误")
                print("网络请求错误")
            }
        }
    
    }
    

    func backClick()
    {
        NSLog("back");
         self.navigationController?.popViewControllerAnimated(true)
    }

    
    func reportClick()
    {
        if(self.isjb)
        {
            self.successNotice("他人已举报")
        }else
        {
            var alertView = UIAlertView()
            alertView.title = "系统提示"
            alertView.message = "您确定要举报吗？"
            alertView.addButtonWithTitle("取消")
            alertView.addButtonWithTitle("确定")
            alertView.cancelButtonIndex=0
            alertView.delegate=self;
            alertView.show()
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
    
    
    func savebmThread()
    {
        let defaults = NSUserDefaults.standardUserDefaults();
        var senduseridstr = defaults.objectForKey("userid") as! String;

        let  dics:Dictionary<String,String> = ["_infoid" : self.infoid,"_userid" : senduseridstr,"_guid" : self.guid,"_action" : "add"]
        
        var url_str:String = "http://api.bbxiaoqu.com/adduserbminfo.php";
        Alamofire.request(.POST,url_str, parameters:dics)
            .responseString{ response in
                if(response.result.isSuccess)
                {
                    print("报名成功")
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
        
        let  dics:Dictionary<String,String> = ["_userid" : self.puserid,"_senduserid" : senduseridstr,"_infoid" : self.infoid,"_guid" : self.guid,"_type" : "chat","_content" : "已通过私信方式与发布者进行了沟通","_action" : "add"]
        
        var url_str:String = "http://api.bbxiaoqu.com/addinfohelpuser_v1.php";
        Alamofire.request(.POST,url_str, parameters:dics)
            .responseString{ response in
                if(response.result.isSuccess)
                {
                    
                }
        }
    }
        
    
    func alertView(alertView:UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if(buttonIndex==alertView.cancelButtonIndex){
            print("点击了取消")
        }
        else
        {
            NSLog("add")
            let defaults = NSUserDefaults.standardUserDefaults();
            let userid = defaults.objectForKey("userid") as! String;
            var date = NSDate()
            var timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
            var strNowTime = timeFormatter.stringFromDate(date) as String
            
            var  dic:Dictionary<String,String> = ["guid" : guid, "userid": userid, "addtime": strNowTime]
            Alamofire.request(.POST, "http://api.bbxiaoqu.com/savereport.php", parameters: dic)
                .responseJSON { response in
                    if(response.result.isSuccess)
                    {
                        self.isjb=true;
                         //self.reportbtn.hidden=false
                        //self.reportbtn.setTitle("已举报", forState: UIControlState.Normal)
                        //self.reportbtn.enabled=false
                        
                    }else
                    {
                        self.successNotice("网络请求错误")
                        print("网络请求错误")
                    }
                    
            }
            
        }
    }
    
    func dismiss(timer:NSTimer){
        alertView!.dismissWithClickedButtonIndex(0, animated:true)
    }

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count;
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat
    {
        //计算行高，返回，textview根据数据计算高度
                   var fixedWidth:CGFloat = 260;
            var contextLab:UITextView=UITextView()
            contextLab.text=(self.items[indexPath.row] as itempl).content
            var newSize:CGSize = contextLab.sizeThatFits(CGSizeMake(fixedWidth, 123));
            var height=(newSize.height)
            print("height---\(height)")
            return height+60
           }

    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellId = "daymiccell"
        var cell:PlTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as! PlTableViewCell?
        if(cell == nil)
        {
            cell = PlTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
        }
        cell?.pluser?.text=(self.items[indexPath.row] as itempl).username
        cell?.pltime.text=(self.items[indexPath.row] as itempl).actiontime
        cell?.plcontent?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell?.plcontent?.numberOfLines=0
        cell?.plcontent?.text=(self.items[indexPath.row] as itempl).content
        var headface:String = (self.items[indexPath.row] as itempl).headface;
        if(headface.characters.count>0)
        {
            var myhead:String="http://api.bbxiaoqu.com/uploads/".stringByAppendingString(headface)
            Alamofire.request(.GET, myhead).response {
                (_, _, data, _) -> Void in
                if let d = data as? NSData!
                {
                    cell?.plheadface?.image=UIImage(data: d)
                }
            }
        }else
        {
            cell?.plheadface?.image=UIImage(named: "logo")
        }
        cell?.plheadface.layer.cornerRadius =  (cell?.plheadface.frame.width)! / 2
        cell?.plheadface.layer.masksToBounds = true

        tableView.userInteractionEnabled = true
        if(self.issolution)
        {
            if(self.solutionid==(self.items[indexPath.row] as itempl).id)
            {
                //cell?.plgoodbtn.titleLabel?.text="获最佳"
                cell?.plgoodbtn.setTitle("获最佳", forState: UIControlState.Normal)
                cell?.plgoodbtn.enabled=false;
                cell?.plgoodbtn.hidden=false

            
            }else
            {
                cell?.plgoodbtn.hidden=true

            }
        }else
        {
                cell?.plgoodbtn.hidden=true
        }
        
        
         return cell!
    }
    
    
    func tapped(button:UIButton){
        var pos:Int = button.tag
        var date = NSDate()
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        var strNowTime = timeFormatter.stringFromDate(date) as String
        
        var  dic:Dictionary<String,String> = ["_infoid" : infoid, "_guid": guid]
        
         dic["_solutiontype"] = "1"
         dic["_solutionpostion"] = (self.items[pos] as itempl).id
         dic["_solutionuserid"] = (self.items[pos] as itempl).userid
        dic["_solutiontime"] = strNowTime
        
        Alamofire.request(.POST, "http://api.bbxiaoqu.com/solution.php", parameters: dic)
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                    self.successNotice("已解决")
                    print("已解决")

                    
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
                
        }
        

        
        
    }
    
    func keyBoardWillShow(note:NSNotification)
    {
        let userInfo  = note.userInfo as! NSDictionary
        var  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        var keyBoardBoundsRect = self.view.convertRect(keyBoardBounds, toView:nil)
        
        var keyBaoardViewFrame = sendView.frame
        var deltaY = keyBoardBounds.size.height
        
        let animations:(() -> Void) = {
            
            self.sendView.transform = CGAffineTransformMakeTranslation(0,-deltaY)
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
            
            
        }else{
            
            animations()
        }
        
        
    }
    
    func keyBoardWillHide(note:NSNotification)
    {
        
        let userInfo  = note.userInfo as! NSDictionary
        
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        
        let animations:(() -> Void) = {
            
            self.sendView.transform = CGAffineTransformIdentity
            
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
            
            
        }else{
            
            animations()
        }
        
        
        
        
    }
    
    func handleTouches(sender:UITapGestureRecognizer){
        
        if sender.locationInView(self.view).y < self.view.bounds.height - 250{
            txtMsg.resignFirstResponder()
            
            
        }
        
        
    }

    

    
}

