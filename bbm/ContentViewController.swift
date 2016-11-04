//
//  ContentViewController.swift
//  bbm
//
//  Created by ericsong on 15/10/10.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

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
    
  
   
   
    var timer:Timer!
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
    @IBAction func inforeportaction(_ sender: UIButton) {
        
        
        
        
        if(self.inforeport_btn.titleLabel?.text! == "举报")
        {
            let actionSheet=UIActionSheet()
            actionSheet.title = "请选择举报类型"
            actionSheet.addButton(withTitle: "取消")
            actionSheet.addButton(withTitle: "广告")
            actionSheet.addButton(withTitle: "政治")
            actionSheet.addButton(withTitle: "暴恐")
            actionSheet.addButton(withTitle: "淫秽")
            actionSheet.addButton(withTitle: "赌博")
            actionSheet.addButton(withTitle: "诈骗")
            actionSheet.addButton(withTitle: "其它")
            actionSheet.cancelButtonIndex=0
            actionSheet.delegate=self
            actionSheet.show(in: self.view);
        }else if(self.inforeport_btn.titleLabel?.text! == "取消")
        {
            let defaults = UserDefaults.standard;
            let senduseridstr = defaults.object(forKey: "userid") as! String;
            let  dics:Dictionary<String,String> = ["_tsuid" : self.puserid,"_uid" : senduseridstr,"_infoid" : self.infoid,"_guid" : self.guid,"_tsreason" : "","_action" : "remove"]
            let url_str:String = "http://api.bbxiaoqu.com/addusertsinfo.php";
            
            Alamofire.request(url_str, method:HTTPMethod.post,parameters:dics)
                .responseString{ response in
                    if(response.result.isSuccess)
                    {
                        self.inforeport_btn.setTitle("举报", for: UIControlState())
                    }
            }
            
        }
    }

    //评价
    @IBOutlet weak var evaluate_btn: UIButton!
    @IBAction func evaluateacton(_ sender: UIButton) {
        let defaults = UserDefaults.standard;
        senduserid = defaults.object(forKey: "userid") as! String;
        let sb = UIStoryboard(name:"Main", bundle: nil)

        if(puserid==senduserid)
        {
            let vc = sb.instantiateViewController(withIdentifier: "bmuserviewcontroller") as! BmUserViewController
            //创建导航控制器
            vc.guid=self.guid;
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
    
    
    //收藏
    @IBOutlet weak var gzbtn: UIButton!
    @IBAction func gzbtnaction(_ sender: UIButton) {
        print("gzbtnaction")
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async { () -> Void in
            if(self.gzbtn.titleLabel?.text == "收藏")
            {
                let sqlitehelpInstance1=sqlitehelp.shareInstance()
                
                let defaults = UserDefaults.standard;
                let userid = defaults.object(forKey: "userid") as! String;
                sqlitehelpInstance1.addgz(self.guid, userid: userid)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.gzbtn.setTitle("取消", for: UIControlState())
                    //self.gzbtn.imageView?.image=UIImage(named: "xz_aixin_icon_sel")
                    self.gzbtn.setImage(UIImage(named: "xz_aixin_icon_sel"), for: UIControlState())
                    self.successNotice("收藏成功")
                })
            }else if(self.gzbtn.titleLabel?.text == "取消")
            {
                
                let sqlitehelpInstance1=sqlitehelp.shareInstance()
                
                let defaults = UserDefaults.standard;
                let userid = defaults.object(forKey: "userid") as! String;
                sqlitehelpInstance1.removegz(self.guid, userid: userid)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.gzbtn.setTitle("收藏", for: UIControlState())
                    //self.gzbtn.imageView?.image=UIImage(named: "xz_aixin_icon")
                    self.gzbtn.setImage(UIImage(named: "xz_aixin_icon"), for: UIControlState())
                    self.successNotice("取消收藏成功")
                })
            }
        }
    }
    //交流处理
    @IBOutlet weak var rl_bottom: UIView!
    @IBOutlet weak var chat_btn: UIButton!
    @IBAction func dohelp(_ sender: UIButton) {
        let actionSheet=UIActionSheet()
        actionSheet.title = "请选择举报类型"
        actionSheet.addButton(withTitle: "取消")
        actionSheet.addButton(withTitle: "在线聊天")
        actionSheet.addButton(withTitle: "文字评论")
        actionSheet.cancelButtonIndex=0
        actionSheet.delegate=self
        actionSheet.show(in: self.view);

    }

    @IBOutlet weak var _tableview: UITableView!
    @IBAction func runchat(_ sender: UIButton) {
        let defaults = UserDefaults.standard;
        senduserid = defaults.object(forKey: "userid") as! String;
        let sb = UIStoryboard(name:"Main", bundle: nil)
        if(puserid==senduserid)
        {
            let vc = sb.instantiateViewController(withIdentifier: "bmuserviewcontroller") as! BmUserViewController
            //创建导航控制器
            vc.guid=self.guid;
            self.navigationController?.pushViewController(vc, animated: true)
        }else
        {
            //做了一次报名动作
            self.savebmThread();

            
            let defaults = UserDefaults.standard;
            let myuserid = defaults.object(forKey: "userid") as! String;
            
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "chatviewController") as! ChatViewController
            vc.from=puserid
            vc.myself=myuserid;
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
                        print("点击了："+actionSheet.buttonTitle(at: buttonIndex)!)
        let tag:String = actionSheet.buttonTitle(at: buttonIndex)!
       if(tag == "在线聊天")
       {
            let defaults = UserDefaults.standard;
            let userid = defaults.object(forKey: "userid") as! String;
            if(self.puserid==userid)
            {
                self.successNotice("请选择与其它人聊天")
            }else
            {
                //做了一次报名动作
                self.savebmThread();
                self.AddInfoHelpUserThread();
                let defaults = UserDefaults.standard;
                let myuserid = defaults.object(forKey: "userid") as! String;
                let sb = UIStoryboard(name:"Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "chatviewController") as! ChatViewController
                vc.from=puserid
                vc.myself=myuserid;
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if(tag == "文字评论")
        {
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "discuzzviewcontroller") as! DiscuzzViewController
            //创建导航控制器
            vc.guid=self.guid;
            self.navigationController?.pushViewController(vc, animated: true)


        }else
        {//举报
            
            if(self.inforeport_btn.titleLabel?.text! == "举报")
            {
                if(tag != "取消")
                {
                    let defaults = UserDefaults.standard;
                    let senduseridstr = defaults.object(forKey: "userid") as! String;
                    let  dics:Dictionary<String,String> = ["_tsuid" : self.puserid,"_uid" : senduseridstr,"_infoid" : self.infoid,"_guid" : self.guid,"_tsreason" : tag,"_action" : "add"]
                    let url_str:String = "http://api.bbxiaoqu.com/addusertsinfo.php";
                    Alamofire.request(url_str,method:HTTPMethod.post, parameters:dics)
                        .responseString{ response in
                            if(response.result.isSuccess)
                            {
                                self.inforeport_btn.setTitle("取消", for: UIControlState())
                            }
                    }
                }
            }else if(self.inforeport_btn.titleLabel?.text! == "取消")
            {
                let defaults = UserDefaults.standard;
                let senduseridstr = defaults.object(forKey: "userid") as! String;
                let  dics:Dictionary<String,String> = ["_tsuid" : self.puserid,"_uid" : senduseridstr,"_infoid" : self.infoid,"_guid" : self.guid,"_tsreason" : tag,"_action" : "remove"]
                let url_str:String = "http://api.bbxiaoqu.com/addusertsinfo.php";
                Alamofire.request(url_str,method:HTTPMethod.post, parameters:dics)
                    .responseString{ response in
                        if(response.result.isSuccess)
                        {
                            self.inforeport_btn.setTitle("举报", for: UIControlState())
                        }
                }
                
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
    override func viewDidLoad() {
   
        super.viewDidLoad()
        self.navigationItem.title="查看"
        let returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(ContentViewController.backClick))
        
        item3.tintColor=UIColor.white
        
        self.navigationItem.leftBarButtonItem=item3
        
        
        
        
        let searchimg=UIImage(named: "xz_nav_icon_search")
        
        let item4=UIBarButtonItem(image: searchimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(ContentViewController.searchClick))
        
        item4.tintColor=UIColor.white
        
        self.navigationItem.rightBarButtonItem=item4        
        _tableview!.delegate=self
        _tableview!.dataSource=self
        
        _tableview.estimatedRowHeight = 250
        //setSeparatorInset:UIEdgeInsetsMake
        _tableview.rowHeight = UITableViewAutomaticDimension

        
        
        self.headimgview!.isUserInteractionEnabled = true
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
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        
        activityIndicatorView.frame = CGRect(x: self.view.frame.size.width/2 - 50, y: 250, width: 100, height: 100)
        
        
        
        activityIndicatorView.hidesWhenStopped = true
        
        activityIndicatorView.color = UIColor.black
        
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
    
        let w:CGFloat = UIScreen.main.bounds.width
        
        content_view.frame=CGRect(x: 0,y: 130,width: CGFloat(w),height: content_view_hight)

        content_end_view.frame=CGRect(x: 0,y: 130+content_view_hight,width: CGFloat(w),height: 30)
        
        let th = self.view.frame.size.height-(130+content_view_hight+30);
        
        _tableview.frame=CGRect(x: 0,y: 130+content_view_hight+30,width: CGFloat(w),height: th)
        
        headimgview.layer.cornerRadius = headimgview.frame.width / 2
        
        // image还需要加上这一句, 不然无效
        
        headimgview.layer.masksToBounds = true
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
         activityIndicatorView.startAnimating()
        Alamofire.request(url_str,method:HTTPMethod.get, parameters:nil)
            .responseJSON {response in
                self.activityIndicatorView.stopAnimating()
                if(response.result.isSuccess)
                {
                    print(response.result.value)
                    
                    if let JSON:NSArray = response.result.value as! NSArray {
                        print("JSON1: \(JSON.count)")
                        if(JSON.count>0)
                        {
                            self.infoid = (JSON[0] as! NSDictionary).object(forKey: "id") as! String;
                            let title:String = (JSON[0] as! NSDictionary).object(forKey: "title") as! String;
                            let contentstr:String = (JSON[0] as! NSDictionary).object(forKey: "content") as! String;
                             
                                
                            self.photo = (JSON[0] as! NSDictionary).object(forKey: "photo") as! String;
                            let sendtimestr:String = (JSON[0] as! NSDictionary).object(forKey: "sendtime") as! String;
                            let sendaddress = (JSON[0] as! NSDictionary).object(forKey: "address") as! String
                            let status = (JSON[0] as! NSDictionary).object(forKey: "status") as! String

                            
                            let infocatagroy:String = (JSON[0] as! NSDictionary).object(forKey: "infocatagroy") as! String;
                            self.headface = (JSON[0] as! NSDictionary).object(forKey: "headface") as! String
                            self.puserid = (JSON[0] as! NSDictionary).object(forKey: "senduser") as! String;
                            self.puser = (JSON[0] as! NSDictionary).object(forKey: "username") as! String;
                            
                            let report = (JSON[0] as! NSDictionary).object(forKey: "report") as! String;
                            if((JSON[0] as! NSDictionary).object(forKey: "issolution") as! String == "1")
                            {
                                self.issolution=true
                            }else
                            {
                                self.issolution=false
                            }
                            self.solutionid = (JSON[0] as! NSDictionary).object(forKey: "solutionid") as! String;
                            //处理后边数据
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.senduser_label.text=self.puser
                                self.sendtime.text = sendtimestr;
                                self.sendaddr.text = sendaddress;
                            
                                self.addcontent(contentstr);
                                self.addimgviewpic(self.photo);
                                
                                
                                //判断是不是本人
                                let defaults = UserDefaults.standard;
                                let userid = defaults.object(forKey: "userid") as! String;
                                if(self.puserid==userid)
                                {
                                    //不能举报
                                    self.inforeport_btn.isHidden=true
                                    //不能收藏
                                    self.gzbtn.isHidden=true
                                    //可以评价
                                    self.evaluate_btn.isHidden=false
                                    //可以评论
                                    self.rl_bottom.isHidden=false
                                    
                                }else
                                {
                                    //能举报
                                    self.inforeport_btn.isHidden=false
                                    //能收藏
                                    self.gzbtn.isHidden=false
                                    //不可以评价
                                     self.evaluate_btn.isHidden=true
                                    //可以评论
                                    self.rl_bottom.isHidden=false
                                    
                                    
                                    let sqlitehelpInstance1=sqlitehelp.shareInstance()
                                    
                                    let defaults = UserDefaults.standard;
                                    let userid = defaults.object(forKey: "userid") as! String;
                                    let ishavezhan:Bool = sqlitehelpInstance1.isexitgz(self.infoid, userid: userid)
                                    if ishavezhan
                                    {
                                        self.gzbtn.titleLabel!.text="取消"
                                        self.gzbtn.setImage(UIImage(named: "xz_aixin_icon_sel"), for: UIControlState())
                                        
                                    }else
                                    {
                                        self.gzbtn.titleLabel!.text="收藏"
                                        self.gzbtn.setImage(UIImage(named: "xz_aixin_icon"), for: UIControlState())
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
                                    
                                    DispatchQueue.main.async(execute: { () -> Void in
                                        self.evaluate_btn.setTitle("查看帮助我的人", for: UIControlState())
                                    //self.evaluate_btn.titleLabel?.text="查看帮助我的人"
                                    
                                    self.issolution=true
                                    self.infostatus.image=UIImage(named: "xz_yijiejue_icon")
                                    });
                                }else
                                {
                                    DispatchQueue.main.async(execute: { () -> Void in
                                        self.issolution=false
                                        self.infostatus.image=UIImage(named: "xz_qiuzhu_icon")
                                    });
                                }
                                if(report=="1")
                                {
                                    self.isjb=true
                                 }
                            })
                            
                            let sqlitehelpInstance1=sqlitehelp.shareInstance()
                            let defaults = UserDefaults.standard;
                            let userid = defaults.object(forKey: "userid") as! String;
                            if(sqlitehelpInstance1.isexitgz(self.guid, userid: userid))
                            {
                                self.gzbtn.titleLabel?.text="取消"

                            }else
                            {
                                 self.gzbtn.titleLabel?.text="收藏"
                            }
                            self.loadheadface(self.puserid,headname:self.headface)
                            self.loaddiscuzzBody(self.infoid)
                        }else{
                            self.successNotice("信息已移除")
                            print("信息已移除")
                              self.navigationController?.popViewController(animated: true)

                        }
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
        let w:CGFloat = UIScreen.main.bounds.width-20

        let posy=CGFloat(130);
        let customView = UIView(frame: CGRect(x: 10, y: posy, width:w, height: CGFloat(1)))
        customView.backgroundColor=UIColor.gray
        self.view.addSubview(customView)
    }
    var imgView:UIView=UIView();
    func addimgview()
    {
        
        
    }
    
    //添加内容
    var contenthight:CGFloat=0.0;
    var content_view_hight:CGFloat=0.0;
    func addcontent(_ contentstr:String)
    {
//        var content = UILabel.init()
//        content.text = contentstr
//         content.font = UIFont.systemFontOfSize(14)
//        let options:NSStringDrawingOptions = .UsesLineFragmentOrigin
//        let boundingRect = contentstr.boundingRectWithSize(CGSizeMake(200, 0), options: options, attributes:[NSFontAttributeName:UIFont(name: "Heiti SC", size: 14.0)!], context: nil)
//        contenthight=boundingRect.height
//        content.frame = CGRectMake(10, 0, UIScreen.mainScreen().applicationFrame.width-20, boundingRect.height)
//        content.numberOfLines = 0;
//        content.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
                let content = UICopyLabel.init()
                content.text = contentstr
                 content.font = UIFont.systemFont(ofSize: 14)
                let options:NSStringDrawingOptions = .usesLineFragmentOrigin
                let boundingRect = contentstr.boundingRect(with: CGSize(width: 200, height: 0), options: options, attributes:[NSFontAttributeName:UIFont(name: "Heiti SC", size: 14.0)!], context: nil)
                contenthight=boundingRect.height
                content.frame = CGRect(x: 10, y: 0, width: UIScreen.main.applicationFrame.width-20, height: boundingRect.height)
                content.numberOfLines = 0;
                content.lineBreakMode = NSLineBreakMode.byWordWrapping

        self.content_view.addSubview(content)
    
    }
 
    func addimgviewpic(_ photo:String)
    {
        self.photoArr = photo.characters.split{$0 == ","}.map{String($0)}
        self.picnum=self.photoArr.count
        let w:CGFloat = UIScreen.main.bounds.width-20
        content_view_hight=contenthight+CGFloat(w/4)
        if(self.picnum>0)
        {
            
            imgView = UIView(frame: CGRect(x: 10, y: contenthight, width:w, height: CGFloat(w/4)))
            self.content_view.addSubview(imgView)
            let bw:CGFloat = UIScreen.main.bounds.width-20
            var index=0
            if(self.picnum>4)
            {
                self.picnum=4
            }
            let count = 4;
            for j:Int in 0 ..< self.picnum
            {
                let imageView:UIImageView = UIImageView();
                let sw=bw/4;
                let x:CGFloat = sw * CGFloat(j);
                imageView.frame=CGRect(x: x+5, y: 5, width: sw-10, height: sw-10);
                imageView.tag=j
                let picname:String = self.photoArr[j]
                let imgurl = "http://api.bbxiaoqu.com/uploads/" + picname
                
                
                self.pics.append(imgurl)
                //imageView.contentMode=UIViewContentMode.ScaleAspectFit
                imageView.image=UIImage(named: "xz_pic_text_loading")
                Util.loadpic(imageView, url: imgurl)

                
                imageView.isUserInteractionEnabled=true
                
                imageView.tag = j
                
                //点击事件
                
                let touch = UITapGestureRecognizer.init(target: self, action: #selector(ContentViewController.tapimg(_:)))
                

                
                imageView.addGestureRecognizer(touch)
                //添加边框
                let layer:CALayer = imageView.layer
                layer.borderColor=UIColor.lightGray.cgColor
                layer.opacity=1
                layer.borderWidth = 1.0;
                self.imgView.addSubview(imageView);
            }
        }
      
    }

    func tapimg(_ recognizer:UITapGestureRecognizer)
    {
        let imgView:UIView = recognizer.view!;
        let tapTag:NSInteger = imgView.tag;
        
        
        let url:String=self.pics[tapTag]
        
        let sb = UIStoryboard(name:"Main", bundle: nil)
        //let vc = sb.instantiateViewControllerWithIdentifier("picviewController") as! PicViewController
        let vc = sb.instantiateViewController(withIdentifier: "picsviewController") as! PicsViewController
        //创建导航控制器
        vc.url = url
        vc.pics = self.pics;
        self.navigationController?.pushViewController(vc, animated: true)
        

        
        
        print(tapTag)

    }

    
    override func viewWillDisappear(_ animated: Bool) {
        
        _search.delegate=nil
        locService.delegate=self


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
            
            //            defaults.setNilValueForKey("province");//省直辖市
            //            defaults.setNilValueForKey("city");//城市
            //            defaults.setNilValueForKey("sublocality");//区县
            //            defaults.setNilValueForKey("thoroughfare");//街道
            //            defaults.setNilValueForKey("address");
            
            
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
            
            Alamofire.request( "http://api.bbxiaoqu.com/updatechannelid.php", method:HTTPMethod.post,parameters:["_userId" : _userid,"_channelId":_token])
                .responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    print(response.result.value)
                    
                    
            }
            
            
            
            
            Alamofire.request("http://api.bbxiaoqu.com/updatelocation.php", method:HTTPMethod.post, parameters:["_userId" : _userid,"_lat":String(userLocation.location.coordinate.latitude),"_lng":String(userLocation.location.coordinate.longitude),"_os":"ios"])
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
        //_search.delegate=nil
    }

    
    func showuser()
    {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "userinfoviewcontroller") as! UserInfoViewController
        //创建导航控制器
        vc.userid=self.puserid;
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
  

    func loadheadface(_ userid:String,headname:String)
    {
        if(headname.characters.count>0)
        {
        let myhead:String="http://api.bbxiaoqu.com/uploads/" + headface
        Util.loadheadface(self.headimgview, url: myhead)
            self.headimgview.layer.cornerRadius = self.headimgview.frame.width/2
            self.headimgview.layer.masksToBounds = true
            
        }else
        {
            
            self.headimgview?.image=UIImage(named: "xz_wo_icon")
            self.headimgview.layer.cornerRadius = self.headimgview.frame.width/2
            self.headimgview.layer.masksToBounds = true
        }
        
    }
    

    
        func loaddiscuzzBody(_ infoid:String)
        {
            let url_str:String = "http://api.bbxiaoqu.com/getdiscuzz.php?infoid=" + infoid
            Alamofire.request(url_str,  method:HTTPMethod.get,parameters:nil)
                .responseJSON { response in
                     if(response.result.isSuccess)
                    {
                    if let JSON = response.result.value as? NSArray {
                        print("JSON1: \(JSON.count)")
                        if(JSON.count>0)
                        {
                            for data in JSON{
                                let id:String = (data as! NSDictionary).object(forKey: "id") as! String;
                                let headface:String = (data as! NSDictionary).object(forKey: "headface") as! String;
                                let sendtime:String = (data as! NSDictionary).object(forKey: "sendtime") as! String;
                                let message:String = (data as! NSDictionary).object(forKey: "message") as! String;
                                let uid:String = (data as! NSDictionary).object(forKey: "senduserid") as! String;
                                let username:String = (data as! NSDictionary).object(forKey: "senduser") as! String;
                                let item_obj:itempl = itempl(id: id, userid: uid, username: username, headafce: headface, actiontime: sendtime, content: message)
                                  self.items.append(item_obj)
                            }
                            DispatchQueue.main.async(execute: { () -> Void in
                                if(self.items.count==0)
                                {
                                    self._tableview.isHidden=true
                                }else
                                {
                                    self._tableview.isHidden=false
                                self._tableview.reloadData();
                                //self._tableview.doneRefresh();
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
         self.navigationController?.popViewController(animated: true)
    }

    
    func reportClick()
    {
        if(self.isjb)
        {
            self.successNotice("他人已举报")
        }else
        {
            let alertView = UIAlertView()
            alertView.title = "系统提示"
            alertView.message = "您确定要举报吗？"
            alertView.addButton(withTitle: "取消")
            alertView.addButton(withTitle: "确定")
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
        let defaults = UserDefaults.standard;
        let senduseridstr = defaults.object(forKey: "userid") as! String;

        let  dics:Dictionary<String,String> = ["_infoid" : self.infoid,"_userid" : senduseridstr,"_guid" : self.guid,"_action" : "add"]
        
        let url_str:String = "http://api.bbxiaoqu.com/adduserbminfo.php";
        Alamofire.request(url_str, method:HTTPMethod.post, parameters:dics)
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
        let defaults = UserDefaults.standard;
        let senduseridstr = defaults.object(forKey: "userid") as! String;
        
        let  dics:Dictionary<String,String> = ["_userid" : self.puserid,"_senduserid" : senduseridstr,"_infoid" : self.infoid,"_guid" : self.guid,"_type" : "chat","_content" : "已通过私信方式与发布者进行了沟通","_action" : "add"]
        
        let url_str:String = "http://api.bbxiaoqu.com/addinfohelpuser_v1.php";
        Alamofire.request(url_str,  method:HTTPMethod.post,parameters:dics)
            .responseString{ response in
                if(response.result.isSuccess)
                {
                    
                }
        }
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
            
            let  dic:Dictionary<String,String> = ["guid" : guid, "userid": userid, "addtime": strNowTime]
            Alamofire.request( "http://api.bbxiaoqu.com/savereport.php", method:HTTPMethod.post,parameters: dic)
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
    
    func dismiss(_ timer:Timer){
        alertView!.dismiss(withClickedButtonIndex: 0, animated:true)
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count;
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath:IndexPath) -> CGFloat
    {
        //计算行高，返回，textview根据数据计算高度
                   let fixedWidth:CGFloat = 260;
            let contextLab:UITextView=UITextView()
            contextLab.text=(self.items[indexPath.row] as itempl).content
            let newSize:CGSize = contextLab.sizeThatFits(CGSize(width: fixedWidth, height: 123));
            let height=(newSize.height)
            print("height---\(height)")
            return height+60
           }

    
    lazy var placeholderImage: UIImage = {
        let image = UIImage(named: "xz_wo_icon")!
        return image
    }()
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellId = "daymiccell"
        var cell:PlTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as! PlTableViewCell?
        if(cell == nil)
        {
            cell = PlTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
        }
        cell?.pluser?.text=(self.items[indexPath.row] as itempl).username
        cell?.pltime.text=(self.items[indexPath.row] as itempl).actiontime
        cell?.plcontent?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell?.plcontent?.numberOfLines=0
        cell?.plcontent?.text=(self.items[indexPath.row] as itempl).content
        let headface:String = (self.items[indexPath.row] as itempl).headface;
        if(headface.characters.count>0)
        {
            let myhead:String="http://api.bbxiaoqu.com/uploads/" + headface
            cell?.plheadface?.af_setImage(
                withURL: URL(string: myhead)!,
                placeholderImage: placeholderImage,
                filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: (cell?.plheadface?.frame.size)!, radius: 2.0),
                imageTransition: .crossDissolve(0.2)
            )
//            Alamofire.request(myhead).responseImage { response in
//                debugPrint(response)
//                
//                print(response.request)
//                print(response.response)
//                debugPrint(response.result)
//                
//                if let image = response.result.value {
//                    print("image downloaded: \(image)")
//                    cell?.plheadface?.image=UIImage(data: image)
//                }
//            }

        }else
        {
            cell?.plheadface?.image=UIImage(named: "xz_wo_icon")
        }
        cell?.plheadface.layer.cornerRadius =  (cell?.plheadface.frame.width)! / 2
        cell?.plheadface.layer.masksToBounds = true

        tableView.isUserInteractionEnabled = true
        if(self.issolution)
        {
            if(self.solutionid==(self.items[indexPath.row] as itempl).id)
            {
                //cell?.plgoodbtn.titleLabel?.text="获最佳"
                cell?.plgoodbtn.setTitle("获最佳", for: UIControlState())
                cell?.plgoodbtn.isEnabled=false;
                cell?.plgoodbtn.isHidden=false

            
            }else
            {
                cell?.plgoodbtn.isHidden=true

            }
        }else
        {
                cell?.plgoodbtn.isHidden=true
        }
        
        
         return cell!
    }
    
    
    func tapped(_ button:UIButton){
        let pos:Int = button.tag
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        
        var  dic:Dictionary<String,String> = ["_infoid" : infoid, "_guid": guid]
        
         dic["_solutiontype"] = "1"
         dic["_solutionpostion"] = (self.items[pos] as itempl).id
         dic["_solutionuserid"] = (self.items[pos] as itempl).userid
        dic["_solutiontime"] = strNowTime
        
        Alamofire.request("http://api.bbxiaoqu.com/solution.php", method:HTTPMethod.post,parameters: dic)
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
    
    func keyBoardWillShow(_ note:Notification)
    {
        let userInfo  = note.userInfo as! NSDictionary
        let  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        var keyBoardBoundsRect = self.view.convert(keyBoardBounds, to:nil)
        
        var keyBaoardViewFrame = sendView.frame
        let deltaY = keyBoardBounds.size.height
        
        let animations:(() -> Void) = {
            
            self.sendView.transform = CGAffineTransform(translationX: 0,y: -deltaY)
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
            
        }else{
            
            animations()
        }
        
        
    }
    
    func keyBoardWillHide(_ note:Notification)
    {
        
        let userInfo  = note.userInfo as! NSDictionary
        
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        
        let animations:(() -> Void) = {
            
            self.sendView.transform = CGAffineTransform.identity
            
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
            
        }else{
            
            animations()
        }
        
        
        
        
    }
    
    func handleTouches(_ sender:UITapGestureRecognizer){
        
        if sender.location(in: self.view).y < self.view.bounds.height - 250{
            txtMsg.resignFirstResponder()
            
            
        }
        
        
    }

    

    
}

