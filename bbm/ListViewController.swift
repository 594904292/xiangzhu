//
//  ListViewController.swift
//  bbm
//
//  Created by songgc on 16/8/16.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire

class ListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UITabBarDelegate,UINavigationControllerDelegate,ApnsDelegate{
    var _tableView:UITableView!
    
    var start:Int = 0
    var limit:Int = 10

     var selectedTabNumber:Int = 0;
    //添加Tab Bar控件
    var tabBar:UITabBar!
    //Tab Bar Item的名称数组
    var tabs = ["待解决","全部","我的"]
    var activityIndicatorView: UIActivityIndicatorView!
    
    
    var items:[itemMess]=[]
    func NewMessage(_ string:String){
        if(selectedTabNumber==0)
        {
            
            querydata(0)
        }else if(selectedTabNumber==1)
        {
            
            querydata(1)
        }else if(selectedTabNumber==2)
        {
            
            querydata(2)
        }
        
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        super.viewDidLoad()
        self.navigationItem.title="我能帮"
        let returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(ListViewController.backClick))
        
        item3.tintColor=UIColor.white
        self.navigationItem.leftBarButtonItem=item3
        let item2 = UIBarButtonItem(title: "添加", style: UIBarButtonItemStyle.done, target: self, action: #selector(ListViewController.addClick))
        item2.tintColor=UIColor.white
        self.navigationItem.rightBarButtonItem=item2
        addtabbar()
        let w:CGFloat = UIScreen.main.bounds.width
        let posx=w/CGFloat(3);
        addline(posx);
        addline(posx*2);
        tabBar.selectedItem=tabBar.items![selectedTabNumber] 
        //var rect  = self.view.frame
        //var rect  =  UIScreen.main.applicationFrame
        var rect:CGRect = CGRect(x:0,y:20,width:
                                           UIScreen.main.bounds.width,
                                 height:UIScreen.main.bounds.height-20)
        //var rect:CGRect = UIScreen.main.bounds
        //println(screenBounds) //iPhone6输出：（0.0,0.0,375.0,667.0）
        
         rect.origin.y = rect.origin.y+tabBar.frame.origin.y+tabBar.frame.size.height-1
        _tableView = UITableView(frame: rect)
        _tableView.register(OneTableViewCell.self, forCellReuseIdentifier: "cell")//注册自定义cell
        
        self.view.addSubview(_tableView)
        
        _tableView.delegate = self
        _tableView.dataSource = self

        //普通带文字下拉刷新的定义
       self._tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(ListViewController.headerRefresh))
        //普通带文字上拉加载的定义
        self._tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(ListViewController.footerRefresh))
      
        
        
        _tableView.estimatedRowHeight = 250
        //setSeparatorInset:UIEdgeInsetsMake
        _tableView.rowHeight = UITableViewAutomaticDimension
        
        self._tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        //设置分割线颜色
        self._tableView.separatorColor = UIColor.red
        //设置分割线内边距
        self._tableView.separatorInset = UIEdgeInsetsMake(5, 0, 0, 0)
        
        
        // 定义一个 activityIndicatorView
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicatorView.frame = CGRect(x: self.view.frame.size.width/2 - 50, y: 250, width: 100, height: 100)
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = UIColor.black
        self.view.addSubview(activityIndicatorView)
        querydata(selectedTabNumber)


        
    }
   
    
    
    //下拉刷新操作
    func headerRefresh(){
        //模拟数据请求，设置10s是为了便于观察动画
        //self.delay(10) { () -> () in

                        self.start=0;
                        if(self.selectedTabNumber==0)
                        {
                            self.querydata(0)
                        }else if(self.selectedTabNumber==1)
                        {
                            self.querydata(1)
                        }else if(self.selectedTabNumber==2)
                        {
                            self.querydata(2)
                        }
                        self._tableView.reloadData()
                        self._tableView.mj_header.endRefreshing()
        
        //}
    }
    
    //上拉加载操作
    func footerRefresh(){
        //模拟数据请求，设置10s是为了便于观察动画
        
            //self.start=self.limit;
            if(self.selectedTabNumber==0)
            {
                self.querydata(0)
            }else if(self.selectedTabNumber==1)
            {
                self.querydata(1)
            }else if(self.selectedTabNumber==2)
            {
                self.querydata(2)
            }
            self._tableView.reloadData()
            //self._tableView.headerView?.endRefreshing()
        self._tableView.mj_footer.endRefreshing()
    }
    
//    //延迟方法
//    func delay(time:Double,closure:() -> ()){
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    //}
    func addtabbar()
    {
        //在底部创建Tab Bar
        tabBar = UITabBar(frame:
            CGRect(x: 0,y: 60,width: self.view.bounds.width,height: 30))
        let tabItem1 = UITabBarItem(title: tabs[0], image: nil, tag: 0)
        let tabItem2 = UITabBarItem(title: tabs[1], image: nil, tag: 1)
        let tabItem3 = UITabBarItem(title: tabs[2], image: nil, tag: 2)
        let attributes =  [NSForegroundColorAttributeName: UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0),
                           NSFontAttributeName: UIFont(name: "Heiti SC", size: 18.0)!]
        let selattributes =  [NSForegroundColorAttributeName: UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0),NSFontAttributeName: UIFont(name: "Heiti SC", size: 18.0)!]
        
        tabItem1.setTitleTextAttributes(attributes , for: UIControlState.selected)
        tabItem1.setTitleTextAttributes(attributes , for: UIControlState())
        tabItem1.setTitleTextAttributes(selattributes , for: UIControlState.highlighted)
        
        tabItem2.setTitleTextAttributes(attributes , for: UIControlState.selected)
        tabItem2.setTitleTextAttributes(attributes , for: UIControlState())
        tabItem2.setTitleTextAttributes(selattributes , for: UIControlState.highlighted)
        
        tabItem3.setTitleTextAttributes(attributes , for: UIControlState.selected)
        tabItem3.setTitleTextAttributes(attributes , for: UIControlState())
        tabItem3.setTitleTextAttributes(selattributes , for: UIControlState.highlighted)
        
        tabItem1.titlePositionAdjustment=UIOffset(horizontal: 0,vertical: -6)
        tabItem2.titlePositionAdjustment=UIOffset(horizontal: 0,vertical: -6)
        tabItem3.titlePositionAdjustment=UIOffset(horizontal: 0,vertical: -6)

        
        let items:[UITabBarItem] = [tabItem1,tabItem2,tabItem3]
        tabBar.tintColor=UIColor.red
        
        let image = UIImage(named: "xz_you_icon")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 10, 0, 50), resizingMode: UIImageResizingMode.stretch)
        tabBar.selectionIndicatorImage=image
        let meiimage1 = UIImage(named: "xz_mei_icon")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 10, 0, 50), resizingMode: UIImageResizingMode.stretch)
        
        tabBar.backgroundImage=meiimage1
        //设置Tab Bar的标签页
        tabBar.setItems(items, animated: true)
        //本类实现UITabBarDelegate代理，切换标签页时能响应事件
        tabBar.delegate = self
        //代码添加到界面上来
        
        
        
        self.view.addSubview(tabBar);
    }
    
    func addline(_ posx:CGFloat)
    {
        
        let posy=CGFloat(tabBar.frame.origin.y+15);
        let customView = UIView(frame: CGRect(x: posx, y: posy, width:1, height: tabBar.frame.size.height))
        let imageView=UIImageView(image:UIImage(named:"xz_xi_icon"))
        imageView.frame=CGRect(x: 0,y: 0,width: 1,height: 30)
        customView.addSubview(imageView)
        self.view.addSubview(customView)
    }
    
    // UITabBarDelegate协议的方法，在用户选择不同的标签页时调用
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
         print("loaditeminfo: \(self.loaditeminfo)")
        if(self.loaditeminfo)
        {
            NSLog("click item ...");
        }else
        {
            self.items.removeAll()
            if(item.title=="待解决")
            {
                selectedTabNumber=0
              
                
                querydata(0)
            }else if(item.title=="全部")
            {
                selectedTabNumber=1
                querydata(1)
            }else if(item.title=="我的")
            {
                selectedTabNumber=2
                querydata(2)
            }
            self._tableView.reloadData()
        }
        
    }
   
    

    func backClick()
    {
        NSLog("back");
        self.navigationController!.popViewController(animated: true)
        
    }
    
    
    func addClick()
    {
        NSLog("addClick");
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "publishController") as! PublishViewController
        vc.cat=0
        self.navigationController?.pushViewController(vc, animated: true)
        
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return array.count
        return self.items.count;

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      

        if (items[indexPath.row] as itemMess).infocatagory=="gg"
        {
            let toph=CGFloat(15);

            let str:String = "cell\(indexPath.row)_\(self.selectedTabNumber)"
            let cell:OneTableViewCellForGg = OneTableViewCellForGg(style: UITableViewCellStyle.default, reuseIdentifier: str)
            
            let namestr:String=(items[indexPath.row] as itemMess).username
            cell.username.text = namestr//array[indexPath.row]//(items[indexPath.row] as itemMess).username
            
            cell.headface.image=UIImage(named: "xz_wo_icon")
            cell.headface.layer.cornerRadius = cell.headface.frame.width / 2
            cell.timesgo.text=(items[indexPath.row] as itemMess).time
            cell.content.text=(items[indexPath.row] as itemMess).content
            
            let string:NSString = cell.content.text! as NSString
            let options:NSStringDrawingOptions = .usesLineFragmentOrigin
            let boundingRect = string.boundingRect(with: CGSize(width: 200, height: 0), options: options, attributes:[NSFontAttributeName:cell.content.font], context: nil)
            cell.content.frame = CGRect(x: 10, y: toph+33+20, width: UIScreen.main.bounds.width-20, height: boundingRect.height)
            cell.content.numberOfLines = 10;
            
            return cell
        }else
        {
             let str:String = "cell\(indexPath.row)_\(self.selectedTabNumber)"
            let cell:OneTableViewCell = OneTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: str)

        let namestr:String=(items[indexPath.row] as itemMess).username
        cell.username.text = namestr//array[indexPath.row]//(items[indexPath.row] as itemMess).username
        let options:NSStringDrawingOptions = .usesLineFragmentOrigin
        let boundingRect = namestr.boundingRect(with: CGSize(width: 200, height: 0), options: options, attributes:[NSFontAttributeName:cell.username.font], context: nil)
        if((items[indexPath.row] as itemMess).sex == "0")
        {
            cell.seximg.image=UIImage(named: "xz_nan_icon")
        }else
        {
            cell.seximg.image=UIImage(named: "xz_nv_icon")
        }
        cell.seximg.frame=CGRect(x: boundingRect.width+70, y: 25, width: 10, height: 15)
        if (items[indexPath.row] as itemMess).street.characters.count > 0
        {
            cell.street.text=(items[indexPath.row] as itemMess).street
        }else
        {
            cell.street.text="未知"
        }
        let streettr:String = cell.street.text!
        let distanceboundingRect = streettr.boundingRect(with: CGSize(width: 200, height: 0), options: options, attributes:[NSFontAttributeName:cell.street.font], context: nil)
        cell.distance.frame=CGRect(x: distanceboundingRect.width+70, y: 43, width: distanceboundingRect.width*2, height: 30)
        cell.distance.text=(items[indexPath.row] as itemMess).address
        cell.timesgo.text=(items[indexPath.row] as itemMess).time
        cell.content.text=(items[indexPath.row] as itemMess).content
        if((items[indexPath.row] as itemMess).headface.characters.count>0)
        {
            let myhead:String="http://api.bbxiaoqu.com/uploads/" + (items[indexPath.row] as itemMess).headface
            
           

            Util.loadpic(cell.headface, url: myhead)
            cell.headface.layer.cornerRadius = cell.headface.frame.width / 2
            // image还需要加上这一句, 不然无效
            cell.headface.layer.masksToBounds = true
        }else
        {
            cell.headface.image=UIImage(named: "xz_wo_icon")
            cell.headface.layer.cornerRadius = cell.headface.frame.width / 2
            // image还需要加上这一句, 不然无效
            cell.headface.layer.masksToBounds = true

        
        }
        let bw:CGFloat = UIScreen.main.bounds.width-20
        let sw=bw/4;
        var photoArr:[String] = (items[indexPath.row] as itemMess).photo.characters.split{$0 == ","}.map{String($0)}
        var picnum=photoArr.count
        if(picnum>4)
        {
            picnum=4
        }
        for j:Int in 0 ..< picnum
        {
            let imageView:UIImageView = UIImageView();
             let x:CGFloat = sw * CGFloat(j);
            //imageView.frame = CGRectMake(x+5, 5, sw-10, sw-10);
            
            imageView.frame = CGRect.init(x: x+5, y: 5, width: sw-10, height: sw-10);
            imageView.tag=indexPath.row*100+j
            let picname:String = photoArr[j]
            let imgurl = "http://api.bbxiaoqu.com/uploads/".appending(picname)
            let layer:CALayer = imageView.layer
            layer.borderColor=UIColor.lightGray.cgColor
            layer.opacity=1
            layer.borderWidth = 1.0;
            imageView.image=UIImage(named: "xz_pic_text_loading")
            Util.loadpic(imageView,url: imgurl);
            //cell.imageView!.image = UIImage(named :"logo")
            cell.imgview.contentMode = UIViewContentMode.scaleAspectFit
            cell.imgview.addSubview(imageView);
        }
        
        let defaults = UserDefaults.standard;
        
        let userid = defaults.object(forKey: "userid") as! String;
        
        if((items[indexPath.row] as itemMess).userid==userid)
        {
        
            cell.delimg.isHidden=false
            cell.clickBtn.isHidden = false
            cell.clickBtn.isUserInteractionEnabled=true
            cell.clickBtn.tag = indexPath.row
            //点击事件
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(ListViewController.tapLabel(_:)))
            //绑定tap
            cell.clickBtn.addGestureRecognizer(tap)
        }else
        {
            cell.delimg.isHidden=true
            cell.clickBtn.isHidden = true
        }

        
        
            cell.tag1.text=("浏览:" + (items[indexPath.row] as itemMess).visnum) + "次"
            cell.tag2.text=("评论:" + (items[indexPath.row] as itemMess).plnum) + "次"
            
            if ((items[indexPath.row] as itemMess).status == "0")
            {
                cell.statusimg.image =  UIImage(named: "xz_qiuzhu_icon")
            }else if ((items[indexPath.row] as itemMess).status == "1")
            {
                cell.statusimg.image = UIImage(named: "xz_qiuzhu_icon")
            }else if ((items[indexPath.row] as itemMess).status == "2")
            {
                cell.statusimg.image = UIImage(named: "xz_yijiejue_icon")
            }
            

        
  
        return cell
        }
    }
    
      var sel_guid:String="";
        func tapLabel(_ recognizer:UITapGestureRecognizer){
            let labelView:UIView = recognizer.view!;
            let tapTag:NSInteger = labelView.tag;
            print(tapTag)
            sel_guid=(items[tapTag] as itemMess).guid 
            let alertController = UIAlertController(title: "系统提示", message: "您确定要删除吗?", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
            let callOkActionHandler = { (action:UIAlertAction!) -> Void in
                 let url:String="http://api.bbxiaoqu.com/delinfoforguid.php?_guid=" + self.sel_guid;
                Alamofire.request(url).response { response in
                    print("Request: \(response.request)")
                    print("Response: \(response.response)")
                    print("Error: \(response.error)")
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                         DispatchQueue.main.async(execute: { () -> Void in
                            print("utf8Text : \(utf8Text)")
                            Thread.sleep(forTimeInterval: 2)  // 模拟两秒的执行时间
                            //self.querydata(self.selectedTabNumber)
                            self.headerRefresh();
                        });
                        
                    }
                }
                
            }
            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: callOkActionHandler)
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
       
    }
    
    
    var loaditeminfo:Bool=false;
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         // activityIndicatorView.startAnimating()
        loaditeminfo=true
        if(items.count>0)
        {
            print("clicked at \(indexPath.row)")
            let aa:itemMess=items[indexPath.row] as itemMess;
            if aa.infocatagory=="gg"
            {
                print("didSelectRowAtIndexPath at \(aa.guid) clicked")
            }else
            {
                let sb = UIStoryboard(name:"Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "contentviewController") as! ContentViewController
                //创建导航控制器
                //vc.message = aa.content;
                vc.guid=aa.guid
                vc.infoid=aa.guid
                //设置根视图
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else
        {
            print("items.count : \(items.count)")

        }
        let time: TimeInterval = 2.0
        let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC); DispatchQueue.main.asyncAfter(deadline: delay) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        loaditeminfo=false

    }
    
   

    func tableViewCellClicked(_ sender:AnyObject) {
        print("tableViewCell appButton at \((sender as! UIButton).tag) clicked")
    }

    func roundoff(_ x:Double)->Int
    {
        let a:Int = Int(x)
        let b:Double = Double(a)+0.5
        if(x>b)
        { return a+1 }
        else
        { return a}
    }
    
    func querydata(_ Category:Int)
    {
        var url:String="";
        let defaults = UserDefaults.standard;
        let userid = defaults.object(forKey: "userid") as! String;
        let lat = defaults.object(forKey: "lat") as! String;
        let lng = defaults.object(forKey: "lng") as! String;
        let visiblerange = defaults.object(forKey: "rang") as! String;
        let community_id = defaults.object(forKey: "community_id") as! String;
        self.start=self.items.count;
        if(Category==0)
        {
            url=(((((((((((("http://api.bbxiaoqu.com/getinfos_v2.php?userid=" + userid) + "&latitude=") + lat) + "&longitude=") + lng) + "&visiblerange=") + visiblerange) + "&community_id=") + community_id) + "&rang=xiaoqu&status=0&start=") + String(self.start)) + "&limit=") + String(self.limit);
            if( self.start==0)
            {
                let defaults = UserDefaults.standard;
                let vcontent = defaults.object(forKey: "ggtitle") as! String;
                let vtime = defaults.object(forKey: "ggdate") as! String;
                let vid = defaults.object(forKey: "ggid") as! String;

            let item_obj:itemMess = itemMess(userid: "admin", headface:"",sex:"",vname:  "系统公告", vtime: vtime, city: "",street: "",vaddress: "", vcontent: vcontent, vcommunity: "admin", vlng: "", vlat: "", vguid: vid, vinfocatagory: "gg", vphoto: "", status: "", visnum: "", plnum: "")
            
            self.items.append(item_obj)
            }
            
        }else if(Category==1)
        {
            url=(((((((((((("http://api.bbxiaoqu.com/getinfos_v2.php?userid=" + userid) + "&latitude=") + lat) + "&longitude=") + lng) + "&visiblerange=") + visiblerange) + "&community_id=") + community_id) + "&rang=xiaoqu&status=1&start=") + String(self.start)) + "&limit=") + String(self.limit);
            
        }else if(Category==2)
        {
            url=(((((((((((("http://api.bbxiaoqu.com/getinfos_v2.php?userid=" + userid) + "&latitude=") + lat) + "&longitude=") + lng) + "&visiblerange=") + visiblerange) + "&community_id=") + community_id) + "&rang=self&status=1&start=") + String(self.start)) + "&limit=") + String(self.limit);
            
        }
        print("url: \(url)")
        activityIndicatorView.startAnimating()
        
        Alamofire.request( url, method:HTTPMethod.get,parameters: nil)
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                    
                    

                    
                    if let jsonItem = response.result.value as? NSArray{
                        for tempdata in jsonItem{
                            //print("data: \(data)")
                            let data: NSDictionary = tempdata as! NSDictionary;

                            let content:String = data.object(forKey: "content") as! String;
                            let senduserid:String = data.object(forKey: "senduser") as! String;
                             let sex:String=data.object(forKey: "sex") as! String;
                            
                            var sendnickname:String = "";
                            //if(data.object(forKey: "username")!.isKind(of: NSNull))
                            
                            if((data.object(forKey: "username")) != nil)
                            {
                                
                                
                                 sendnickname   = data.object(forKey: "username") as! String;
                                
                            }else
                            {
                               
                                sendnickname="";
                            }
                            let guid:String = data.object(forKey: "guid") as! String;
                            let sendtime:String;
                            let temptime:String=data.object(forKey: "sendtime") as! String;
                            let date:Date = Date()
                            let formatter:DateFormatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            let dateString = formatter.string(from: date)
                            
                            if(temptime.contains(dateString))
                            {
                                sendtime = temptime.subString(start: 11)
                                
                            }else
                            {
                                
                                sendtime = (temptime as NSString).substring(with: NSRange(location: 0,length: 10))
                            }
                            
                            let infolng:String = data.object(forKey: "lng") as! String;
                            let infolat:String = data.object(forKey: "lat") as! String;
                            
                            
                            let lat_1=(infolat as NSString).doubleValue;
                            let lng_1=(infolng as NSString).doubleValue;
                            
                            let lat_2=(lat as NSString).doubleValue;
                            let lng_2=(lng as NSString).doubleValue;
                            var address:String="";
                            
                           
                               let p1:BMKMapPoint = BMKMapPointForCoordinate(CLLocationCoordinate2D(latitude: lat_1, longitude: lng_1))
                                let p2:BMKMapPoint = BMKMapPointForCoordinate(CLLocationCoordinate2D(latitude: lat_2, longitude: lng_2))
                                let distance:CLLocationDistance = BMKMetersBetweenMapPoints(p1, p2);
                                
                                print("距离: %0.2f米", distance);
                                let one:UInt32 = UInt32(distance)
                                
                                if(one>1000)
                                {
                                    address = ("\(self.roundoff(Double(one)/1000))千米");
                                }else
                                {
                                    address = ("\(one)米");
                                }
                            
                             let city:String = data.object(forKey: "city") as! String;
                            let street:String = data.object(forKey: "street") as! String;
                            let photo:String = data.object(forKey: "photo") as! String;
                            var community:String = ""
                            if((data.object(forKey: "community")) != nil)
                            {
                                community = "";
                            }else
                            {
                                community = data.object(forKey: "community") as! String;
                                
                            }
                            let infocatagroy:String = data.object(forKey: "infocatagroy") as! String;
                            let status:String = data.object(forKey: "status") as! String;
                            let visit:String = data.object(forKey: "visit") as! String;
                            let plnum:String = data.object(forKey: "plnum") as! String;
                            let headface:String = data.object(forKey: "headface") as! String;
                            let item_obj:itemMess = itemMess(userid: senduserid,headface:headface,sex:sex, vname: sendnickname, vtime: sendtime, city: city,street: street,vaddress: address, vcontent: content, vcommunity: community, vlng: lng, vlat: lat, vguid: guid, vinfocatagory: infocatagroy, vphoto: photo, status: status, visnum: visit, plnum: plnum)
                            self.items.append(item_obj)
                            
                        }
                        self._tableView.reloadData()
                        self.activityIndicatorView.stopAnimating()
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                    self.activityIndicatorView.stopAnimating()
                }
                
        }
        
    }
}
